# Copilot Instructions for `csi-nn2`

## Build, test, and lint

- The root `Makefile` is the normal entry point. It wraps CMake with target-specific config flags, uses the expected cross-compilers from `cmake/rules.cmake`, and installs outputs into `install_nn2/<target>`.

- Common library builds:
  - `make nn2_ref_x86`
  - `make nn2_rvv`
  - `make nn2_rvm`
  - `make nn2_c906`
  - `make nn2_c920`
  - `make nn2_c906_so`
  - `make nn2_c920_so`
  - `make menuconfig`

- Linux RISC-V builds default to `riscv64-unknown-linux-gnu-{gcc,g++}`; ELF builds default to `riscv64-unknown-elf-gcc`. Set `CONFIG_USE_COMPILER_PATH=ON` when you need to drive CMake with an explicit compiler path, as `onnx_bert/makefile.baremetal` does.

- `make menuconfig` is the interactive Kconfig entry point. Root `CMakeLists.txt` reads `config.cmake` from the build directory or repository root, and the backend-specific `source/*/CMakeLists.txt` files are the source-selection layer behind those config flags.

- Examples and packaging expect installed artifacts rather than raw objects. After building a backend, example binaries link against `install_nn2/<target>/...`:
  - `make -C example c906_m1_f16`

- The in-repo bare-metal BERT flow has dedicated entry points:
  - `make -C onnx_bert -f makefile.baremetal`
  - `make -C onnx_bert -f makefile.baremetal rvm_tvm`

- Test entry points that exist in-tree:
  - `make -C tests test_c906`
  - `make -C tests unit_test_opt_interface`
  - `python -m pytest tests/autotest/interface_test.py --board c906 --dtype 8 --accuracy 0.99`

- Most validation and unit-test makefiles link against matching backend build directories such as `c906_static_build`, `c920_build`, and `rvv_build`, so build the matching backend before running them.

- Single-test patterns:
  - Layer validation: `make -C tests/validation_layer -f Makefile.c906 TYPE=32 convolution.o`  
    `TYPE=8|16|32` selects the dtype variant and emits `tests/validation_layer/convolution.o.elf`.
  - RVV unit test: `make -C tests/unit_test -f Makefile.rvv add.o`  
    This emits `tests/unit_test/add.o.elf`.
  - Single pytest target: `python -m pytest tests/autotest/interface_test.py::TestHeterogeneous::test_subgraph_fuse -q`

- Autotest dependencies are heavier than the top-level `pytest.ini` suggests. `tests/autotest/interface_test.py` imports `tests/onnx_ref/ref.py`, which depends on `onnx`, `onnxruntime`, `torch`, and `tensorflow`, and board-style tests execute ELFs through `qemu-riscv64`. Build the required `validation_layer` or `unit_test` ELFs before invoking pytest.

- `tests/autotest/conftest.py` adds `--board`, `--dtype`, `--accuracy`, and `--flow`. `TestCSINN.test_layer` only gets parameterized cases when `--flow` is supplied, because it pulls case definitions from the external flow service in `tests/autotest/interface_test.py`. Without `--flow`, the direct pytest targets that still make sense are the unit/interface tests such as `test_opt_interface`, `TestHeterogeneous`, and `TestTVMGen`, once the required ELFs have been built.

- Lint/format commands:
  - `make clint`
  - `pre-commit run clang-format --all-files`

## High-level architecture

- `include/csinn/*.h` defines the public CSI-NN2 API and runtime data structures. `source/nn2/*.c` is the common dispatcher/session layer, and `source/nn2/setup.c` owns backend initialization plus the `(api, op, dtype)` callback tables.

- The portable execution stack is split into two layers:
  - `source/reference/` is the scalar correctness baseline and quantization/dequantization fallback.
  - `source/graph_ref/` is the graph runtime used for graph and hybrid modes; it manages graph/session I/O, node execution, and heterogeneous scheduling.

- `source/tvm_gen/` plugs TVM-generated kernels into the graph runtime by name. Root `CMakeLists.txt` enables `CONFIG_GRAPH_REFERENCE_TVMGEN` for C906 and C920 builds, so graph execution on those targets can resolve TVM-generated code through the same graph path.

- `source/thead_rvv/` is the shared RISC-V Vector backend. It registers dtype-specific callbacks, capability checks, and perf hooks, and it is the main fallback layer for target-specific optimized backends.

- `source/c906_opt/`, `source/c908_opt/`, `source/c920_opt/`, `source/c920v2_opt/`, `source/e907_opt/`, and `source/thead_matrix/` provide target overrides. Their `setup.c` files register only the target-specific specializations and then fall back to RVV or reference behavior when an op is not specialized.

- `source/llm/` and `include/llm/` contain the LLM-specific runtime path. Root CMake only appends `LLM_SRCS` for the x86 reference build and the C920 build.

- `python/setup.py` is a packaging layer for prebuilt artifacts under `install_nn2/...`; it does not build the C library itself.

- The test stack mirrors the runtime stack:
  - `tests/python_ref/` generates per-op reference data.
  - `tests/validation_layer/` and `tests/unit_test/` compile ELFs against a specific backend library.
  - `tests/validation_graph/` exercises graph-mode paths such as `hlight` and `tvmgen`.
  - `tests/autotest/` ties those binaries to QEMU and Python reference checks.

## Key conventions

- When adding or changing an op, update the whole mirror set together: the NN2 entry point if needed, the affected backend `setup.c` registration, the backend `CMakeLists.txt`/`Kconfig` source gating, and the matching validation assets under `tests/validation_layer/` plus `tests/python_ref/`.

- Follow the existing file layout instead of inventing new organization:
  - reference code is usually one file per op in `source/reference/`
  - optimized backends are split by dtype/layout such as `fp32/`, `fp16/`, `int8/`, `int4/`, with suffixes like `_nhwc`, `_packn`, and `_gemm`

- Keep the callback chain intact. RVV registers `(dtype, op)` handlers in `source/thead_rvv/setup.c`; target backends register only their overrides and then fall back (`c906 -> rvv -> ref`, `c920 -> rvv -> ref`). Graph and hybrid session setup intentionally routes through `GREF` runtime callbacks rather than bypassing them.

- `source/c906_opt/setup.c` and `source/c920_opt/setup.c` intentionally use different graph-layout defaults (`c906` starts with packn off, `c920` starts with packn on), and both turn packn off if any node is routed through `TVMGEN`. Preserve that behavior when changing graph/session setup.

- Backend registrations usually carry more than just an exec function. The existing optimized backends register companion init/capability/perf/est hooks together; follow the registration style already used by that backend instead of wiring only the kernel body.

- The repo has two source-selection modes: full builds that glob whole backend trees, and source-selected/ELF builds that depend on the curated `*_SRCS_MOD` lists in backend `CMakeLists.txt`. If you add a new file, wire it into the backend CMake/Kconfig path too so smaller builds do not silently miss it.

- Example makefiles and `python/setup.py` expect the installed `install_nn2/<target>` layout, while most validation and unit-test makefiles link directly against backend build directories such as `c906_static_build` and `rvv_build`. If you change library names or build/install paths, update all of those downstream consumers too.

- Test makefiles only build files listed in their `test_objs` variables. Adding a new source file under `tests/validation_layer/`, `tests/unit_test/`, or `tests/validation_graph/` is not enough unless the relevant `Makefile.*` also lists it.

- The per-target test makefiles hardcode `-DCSINN_API=...` to select the backend under test. Keep that macro consistent with the linked library when cloning or modifying a test makefile.

- Formatting is repo-driven. `.clang-format` is Google-derived with 4-space indentation and a 100-column limit, and `.pre-commit-config.yaml` only enforces `clang-format`.
