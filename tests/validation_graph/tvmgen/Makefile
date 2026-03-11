ROOT_DIR := ../../..
TOOLBIN ?=
RISCV_GCC := $(if $(TOOLBIN),$(TOOLBIN)/riscv64-unknown-linux-gnu-gcc,riscv64-unknown-linux-gnu-gcc)
INCLUDE = \
	-I$(ROOT_DIR)/include \
	-I$(ROOT_DIR)/include/backend \
	-I$(ROOT_DIR)/include/csinn \
	-I$(ROOT_DIR)/include/graph \
	-I$(ROOT_DIR)/include/shl_public \
	-I$(ROOT_DIR)/tests/utils
TVMGEN_BACKEND ?= c906

ifeq ($(TVMGEN_BACKEND),rvm_elf)
CFLAGS = -O2 -g3 -march=rv64gcv_zfh_zvfh_xtheadc_xtheadvdot_xtheadmatrix0p3 -mabi=lp64d -static \
	-DTVMGEN_TEST_BASE_API=CSINN_RVM
SHL_LIB_DIR = $(ROOT_DIR)/rvm_elf_build
SHL_LIB = $(SHL_LIB_DIR)/libshl_rvm_rtos.a
else
CFLAGS = -O2 -g3 -march=rv64gcv0p7_zfh_xtheadc -mabi=lp64d -static \
	-DTVMGEN_TEST_BASE_API=CSINN_C906
SHL_LIB_DIR = $(ROOT_DIR)/c906_static_build
SHL_LIB = $(SHL_LIB_DIR)/libshl_c906.a
endif

test_objs =

test_objs += reg.o
test_objs += callback.o

all: csi

csi: $(test_objs)

rvm_tvmgen:
	$(MAKE) -f $(lastword $(MAKEFILE_LIST)) TVMGEN_BACKEND=rvm_elf all

$(test_objs): %.o: %.c
	$(RISCV_GCC) -c $(CFLAGS) $(INCLUDE) $< -o $@
	$(RISCV_GCC) $@ $(CFLAGS) -L$(SHL_LIB_DIR) $(SHL_LIB) -lc -lm -lstdc++ -o $@.elf

.PHONY: all clean rvm_tvmgen
clean:
	rm -rf  $(test_objs) *.a *.asm *.elf *.bin *.asm
