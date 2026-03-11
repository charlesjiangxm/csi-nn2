#FILE NAME      : Makefile
#FUNCTION       : the Makefile compile the test patterns  
#	          The flow of compilation:
#	        *.[c|asm]-> *.o->*.elf-> *.hex-> *.pat
#-------------------------------------------------------------------------
#
#-------------------------------------------------------------------
# the compiler toolset setting
#TOOL_EXTENSION	=  /iotproj/rv_tools/riscv64-elf-x86_64_2.0.3/bin/
CC      = ${TOOL_EXTENSION}/riscv64-unknown-linux-gnu-gcc
AS      = ${TOOL_EXTENSION}/riscv64-unknown-linux-gnu-as
LINK    = ${TOOL_EXTENSION}/riscv64-unknown-linux-gnu-ld
OBJDUMP = ${TOOL_EXTENSION}/riscv64-unknown-linux-gnu-objdump
OBJCOPY = ${TOOL_EXTENSION}/riscv64-unknown-linux-gnu-objcopy
CONVERT	=../tests/bin/Srec2vmem

CSRCFILE = $(shell find $(SMART_PATH)/work -maxdepth 1 -name "*.c")
SSRCFILE = $(shell find $(SMART_PATH)/work -maxdepth 1 -name "*.S")
sSRCFILE = $(shell find $(SMART_PATH)/work -maxdepth 1 -name "*.s")

SSRC = $(wildcard $(SSRCFILE))
sSRC = $(wildcard $(sSRCFILE))
CSRC = $(wildcard $(CSRCFILE)) 

OBJECTS = $(SSRC:%.S=%.o) $(sSRC:%.s=%.o) $(CSRC:%.c=%.o)

FLAG_ABI = 
FLAG_MARCH = -mtune=c907fdvm
#CPU_ARCH_FLAG_0 => CPU Arch: c920, c920v
ifeq (${CPU_ARCH_FLAG}, C907)
  FLAG_MARCH += -march=rv64imac_zicbom_zicbop_zicboz_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zawrs_zca_zcb_zba_zbb_zbc_zbs_sscofpmf_sstc_svinval_svnapot_svpbmt_xtheadc
  FLAG_ABI   = -mabi=lp64 -mcpu=c907
else ifeq (${CPU_ARCH_FLAG}, C907fd)
  FLAG_MARCH += -march=rv64imafdc_zicbom_zicbop_zicboz_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zawrs_zfa_zfbfmin_zfh_zca_zcb_zcd_zba_zbb_zbc_zbs_sscofpmf_sstc_svinval_svnapot_svpbmt_xtheadc
  FLAG_ABI   = -mabi=lp64d -mcpu=c907fd
else ifeq (${CPU_ARCH_FLAG}, C907fdv)
  FLAG_MARCH += -march=rv64imafdcv_zicbom_zicbop_zicboz_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zawrs_zfa_zfbfmin_zfh_zca_zcb_zcd_zba_zbb_zbc_zbs_zvfbfmin_zvfbfwma_zvfh_sscofpmf_sstc_svinval_svnapot_svpbmt_xtheadc_xtheadvdot
  FLAG_ABI   = -mabi=lp64d -mcpu=c907fdv
else ifeq (${CPU_ARCH_FLAG}, C907fdvm)
  FLAG_MARCH += -march=rv64imafdcv_zicbom_zicbop_zicboz_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zawrs_zfa_zfbfmin_zfh_zca_zcb_zcd_zba_zbb_zbc_zbs_zvfbfmin_zvfbfwma_zvfh_sscofpmf_sstc_svinval_svnapot_svpbmt_xtheadc_xtheadmatrix_xtheadvdot
  FLAG_ABI   = -mabi=lp64d -mcpu=c907fdvm
endif

CFLAGS = ${FLAG_MARCH} ${FLAG_ABI} 

ifeq (${CASENAME}, coremark)
  CFLAGS += -c -O3 -funroll-all-loops -finline-limit=500 -fgcse-sm -fno-schedule-insns -fno-code-hoisting -msignedness-cmpiv -mno-thread-jumps1 -mno-iv-adjust-addr-cost -mno-expand-split-imm -g -Wno-implicit-function-declaration
else
  CFLAGS += -c -O2 -g -Wno-return-mismatch -Wno-implicit-function-declaration -Wno-implicit-int
endif

ifeq (${CASENAME}, coremark)
  CFLAGS += -D FORCE_1CORE
else ifeq (${CASENAME}, dhry)
  CFLAGS += -D FORCE_1CORE
else ifeq (${CASENAME}, sgemm)
  CFLAGS += -D FORCE_1CORE
else ifeq (${CASENAME},gemm_fp16)
  CFLAGS += -D FORCE_1CORE
endif

#INCLUDEDIRS = \
              -I$(SMART_PATH)/work \

CFLAGS += $(INCLUDEDIRS)
CFLAGS += -D CONFIG_BOARD_XIAOHUI_EVB -D ${CORENUM}

LINKFLAGS = -Tlinker.lcf -nostdlib -static -no-pie ${FLAG_MARCH} ${FLAG_ABI}

LINKLIBS = -lgcc

OBJDUMPFLAGS = -S -Mnumeric

HEXFLAGS	= -O srec

%.o : %.c
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.s
	${CC} -c ${CFLAGS} -o $@ $<

%.o : %.S
	${CC} -c ${CFLAGS} -o $@ $<

${FILE}.elf : ${OBJECTS} linker.lcf
	${CC} ${LINKFLAGS} ${OBJECTS} -o $@ ${LINKLIBS} -lm 

${FILE}.obj : ${FILE}.elf
	${OBJDUMP} ${OBJDUMPFLAGS} $< > $@

INST_HEX = ${FILE}_inst.hex
DATA_HEX = ${FILE}_data.hex
FILE_HEX = ${FILE}.hex

${FILE}.hex : ${FILE}.elf
	${OBJCOPY} ${HEXFLAGS} $< ${INST_HEX} -j .text*  -j .rodata* -j .eh_frame*
	${OBJCOPY} ${HEXFLAGS} $< ${DATA_HEX} -j .data*  -j .bss -j .COMMON
	${OBJCOPY} ${HEXFLAGS} $< $@ 

INST_PAT = inst.pat
DATA_PAT = data.pat
FILE_PAT = case.pat

%.pat	: %.hex
	rm -f *.pat
	${CONVERT} ${INST_HEX} ${INST_PAT}
	${CONVERT} ${DATA_HEX} ${DATA_PAT}
	${CONVERT} ${FILE_HEX} ${FILE_PAT}


#--------------------------------------------------------------------
# target setting
.PHONY :all
all : ${FILE}.pat ${FILE}.hex ${FILE}.elf ${FILE}.obj

#---------------------------------------------------------------------
# clean some medium code and .pat
.PHONY :clean 
clean:
	rm -rf *.o *.pat *.elf *.obj *.hex

#--------------------------------------------------------------------
# clean files except elf files
.PHONY :clean_expt_elf
clean_expt_elf:
	@echo clean
	@rm -rf  *.o *.pat  *.obj *.hex 

#--------------------------------------------------------------------
# run elf directly
.PHONY :run_elf
run_elf: 
	$(eval ELF_FILES := $(wildcard *.elf))
	$(eval ELF_NAMES := $(patsubst %.elf,%,$(ELF_FILES)))
	@echo ".elf is $(ELF_NAMES).elf"

	${OBJCOPY} ${HEXFLAGS} $(ELF_NAMES).elf ${ELF_NAMES}_inst.hex -j .text* -j .rodata* -j .eh_frame*
	${OBJCOPY} ${HEXFLAGS} $(ELF_NAMES).elf ${ELF_NAMES}_data.hex -j .data* -j .bss -j .COMMON
	${OBJCOPY} ${HEXFLAGS} $(ELF_NAMES).elf ${ELF_NAMES}.hex
	rm -f *.pat
	${CONVERT} ${ELF_NAMES}_inst.hex ${INST_PAT}
	${CONVERT} ${ELF_NAMES}_data.hex ${DATA_PAT}
	${CONVERT} ${ELF_NAMES}.hex ${FILE_PAT} 
