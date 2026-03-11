# Bare-metal C907 `onnx_bert` guide

## Overview

This guide covers the in-repo bare-metal `onnx_bert/` demo and the two build variants
currently wired by `onnx_bert/makefile.baremetal`.

| Variant | Command | Base API | Output ELF | Current status |
| --- | --- | --- | --- | --- |
| RVV (default) | `make -C onnx_bert -f makefile.baremetal` | `CSINN_RVV` | `onnx_bert/build_baremetal/onnx_bert_baremetal.elf` | Validated end to end in Xuantie simulator |
| RVM + TVM | `make -C onnx_bert -f makefile.baremetal rvm_tvm` or `make -C onnx_bert -f makefile.baremetal ONNX_BERT_BAREMETAL_VARIANT=rvm_tvm` | `CSINN_RVM` | `onnx_bert/build_baremetal_rvm_tvm/onnx_bert_baremetal.elf` | Build passed; `tests/validation_graph/tvmgen` passed for C906 and RVM; full `onnx_bert` simulator run is currently blocked in this environment because `cskysim` is missing host `libfdt.so.1` |

Both variants rebuild CSI-NN2 with `CONFIG_GRAPH_REFERENCE_TVMGEN=ON`. The existing RVV
flow remains the validated default in this repo. The `rvm_tvm` variant is the explicit
opt-in path for combining the bare-metal harness with `CSINN_RVM` and external
TVM-generated registrations.

## How external TVM-generated code plugs in

The repo-side glue is:

- `onnx_bert/tvm_registration.h`
  - defines `struct onnx_bert_tvmgen_registry`,
  - declares the external `onnx_bert_tvmgen_registry()` hook,
  - declares `onnx_bert_tvmgen_register()`.
- `onnx_bert/tvm_registration.c`
  - provides a weak `onnx_bert_tvmgen_registry()` that returns `NULL` when no external
    TVM registry is linked,
  - calls `shl_tvmgen_map_reg(registry->map, registry->size)` when a strong registry is
    present.
- `onnx_bert/main.c`
  - calls `onnx_bert_tvmgen_register()` immediately before creating the CSI-NN2 session,
    so TVM-generated callbacks are installed before graph setup begins.

If you want the `rvm_tvm` build to register actual TVM-generated kernels, the external
TVM build must provide:

1. the generated kernel/source files,
2. a translation unit that defines a strong `onnx_bert_tvmgen_registry()` and returns the
   `struct shl_tvmgen_name_func` map plus size,
3. any additional include paths needed by those sources.

Pass those files through the existing make variables:

```bash
make -C onnx_bert -f makefile.baremetal ONNX_BERT_BAREMETAL_VARIANT=rvm_tvm \
  ONNX_BERT_TVM_SRCS="generated/onnx_bert_tvm_reg.c generated/onnx_bert_tvm_kernels.c" \
  ONNX_BERT_TVM_CPPFLAGS="-I$(pwd)/generated"
```

Each `struct shl_tvmgen_name_func.name` entry must exactly match the corresponding
`params->base.name` string emitted by `onnx_bert/model.c` (for example
`take_Gather_30_0`), because graph-ref resolves TVM-generated functions by operator name
during session setup.

If no external `onnx_bert_tvmgen_registry()` is linked, the weak stub remains in place and
no extra TVM-generated registrations are installed.

## Prerequisites

You need:

1. a Xuantie Linux toolchain that provides
   `riscv64-unknown-linux-gnu-gcc`, `g++`, `objcopy`, and `size`;
2. the Xuantie simulator package if you want to run the ELF;
3. this repo checkout.

`onnx_bert/makefile.baremetal` defaults `TOOLBIN` to:

```text
/home/charlesjiangxm/xuantie/Xuantie-900-gcc-linux-6.6.36-glibc-x86_64-V3.3.0/bin
```

Override `TOOLBIN` on the make command line if your toolchain lives elsewhere.

## Build commands

### Default RVV build

```bash
cd /home/charlesjiangxm/github/csi-nn2
make -C onnx_bert -f makefile.baremetal
```

### Explicit RVM + TVM build

Either of the following commands selects the RVM bare-metal library and output directory:

```bash
cd /home/charlesjiangxm/github/csi-nn2
make -C onnx_bert -f makefile.baremetal rvm_tvm
# or
make -C onnx_bert -f makefile.baremetal ONNX_BERT_BAREMETAL_VARIANT=rvm_tvm
```

Generated ELFs:

```text
onnx_bert/build_baremetal/onnx_bert_baremetal.elf
onnx_bert/build_baremetal_rvm_tvm/onnx_bert_baremetal.elf
```

## What each build does

Each build:

1. configures and rebuilds CSI-NN2 with `CONFIG_GRAPH_REFERENCE_TVMGEN=ON`,
2. builds the matching bare-metal library:
   - RVV default: `rvv_elf_build/libshl_rvv_rtos.a`
   - RVM + TVM: `rvm_elf_build/libshl_rvm_rtos.a`
3. compiles `main.c`, `model.c`, `tvm_registration.c`, and any files listed in
   `ONNX_BERT_TVM_SRCS`,
4. converts these runtime inputs into embedded ELF objects:
   - `model.params`
   - `input_ids.0.bin`
   - `input_mask.1.bin`
   - `segment_ids.2.bin`
   - `input_ids.0.bin_output0_1_384.txt`
   - `input_ids.0.bin_output1_1_384.txt`
5. links the final image with `lib/linker_xiaohui.lcf`.

## Validation status

### RVV default flow

The default RVV ELF was validated in the Xuantie simulator with the embedded inputs and
gold outputs.

Observed pass output:

```text
onnx_bert bare-metal boot
creating session
session ready
input_0 ready
input_1 ready
input_2 ready
running inference
inference complete, validating outputs
output_0: count=384 max_abs_diff=0.016602 mismatches=0 tolerance=0.040000
output_1: count=384 max_abs_diff=0.013672 mismatches=0 tolerance=0.040000
onnx_bert bare-metal validation passed
```

### RVM + TVM flow

Current verified status in this repo:

- `make -C onnx_bert -f makefile.baremetal rvm_tvm` builds successfully.
- The graph-reference TVM validation coverage under `tests/validation_graph/tvmgen`
  passed for both C906 and RVM.
- The RVM / RVM-ELF path used by this build enables `CONFIG_GRAPH_REFERENCE_TVMGEN`.

The remaining unverified step is full bare-metal simulator execution of:

```text
onnx_bert/build_baremetal_rvm_tvm/onnx_bert_baremetal.elf
```

In this environment, `cskysim` fails before the ELF runs because the host runtime is
missing `libfdt.so.1`.

## Run in the simulator

Use the `xiaohui_c907` SoC XML because it provides enough DRAM for the embedded model
image.

```bash
QEMU_ROOT=/home/charlesjiangxm/xuantie/xuantie_qemu5
SOC_XML=$QEMU_ROOT/soccfg/riscv64/xiaohui_c907_cfg.xml
ELF=/home/charlesjiangxm/github/csi-nn2/onnx_bert/build_baremetal/onnx_bert_baremetal.elf
# For the RVM + TVM variant, use:
# ELF=/home/charlesjiangxm/github/csi-nn2/onnx_bert/build_baremetal_rvm_tvm/onnx_bert_baremetal.elf

PATH=$QEMU_ROOT/bin:$PATH \
$QEMU_ROOT/bin/cskysim -soc "$SOC_XML" -kernel "$ELF" -nographic
```

For the validated RVV flow, the console ends with:

```text
onnx_bert bare-metal validation passed
```

The RVM + TVM ELF uses the same simulator entry point once the host-side `cskysim`
dependencies are fixed.

## Troubleshooting host simulator dependencies

If `cskysim` fails before loading the ELF, inspect missing host libraries with:

```bash
ldd /home/charlesjiangxm/xuantie/xuantie_qemu5/bin/cskysim | grep "not found"
```

In the environment used for this repo work, the missing dependency is currently
`libfdt.so.1`. Until that host runtime issue is fixed, the `rvm_tvm` bare-metal ELF
cannot be fully revalidated in `cskysim` here.

## Known limitations

1. The RVV build remains the only bare-metal `onnx_bert` path validated end to end in the
   simulator.
2. The `rvm_tvm` path is build-validated and graph-validated, but still awaits full
   bare-metal simulator execution in an environment with working `cskysim` host
   dependencies.
3. If no external `onnx_bert_tvmgen_registry()` is linked, `tvm_registration.c` falls
   back to the weak stub and installs no extra TVM-generated registrations.
4. The simulator image does not auto-exit after printing the validation summary; stop
   `cskysim` manually.
