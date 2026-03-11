#PART 1:  SET HANDLER ENTRY
#PART 2:  Change To x Mode

#####################################################################
#                Included Macro                                     #
#  1.  SETEXP         Set exp's handler entry address               #
#  2.  SETMEXP        Set mmode exp's handler entry address         #
#  3.  SETSEXP        Set smode exp's handler entry address         #
#  4.  SETINT         Set interrupt's handler entry address         #
#  5.  SETMINT        Set mmode interrupt's handler entry address   #
#  6.  SETSINT        Set smode interrupt's handler entry address   #
#  7.  TRAP_TO_M      Change to M Mode                              #
#  8.  CHG_TO_S       Change to S Mode                              #
#  9.  CHG_TO_U       Change to U Mode                              #
#  10. MSTATUS_MPP_S  Set MPP 2'b01                                 #
#  11. MSTATUS_MPP_U  Set MPP 2'b00                                 #
#                                                                   #
#####################################################################

.include "core_mmu.s"
.include "core_l2c.s"
.include "core_lsu.s"
.include "core_ifu.s"
.include "core_plic.s"
.include "core_cp0.s"
.include "core_vec.s"
.include "fp_macro_inst.h"
.include "fp_num_def.h"
.include "core_t_extension.s"


#==================MACRO DEFINE=============================
#.set CLIC_INT      ,0x1
#.set NORM_INT      ,0x0

.set CORENUM       ,0x1
.set INTNUM        ,128

#for memory mapped  int addr
#msip
.set MSIP_ADDR_CORE0        ,0xffffffc004000000 
.set MSIP_ADDR_CORE1        ,0xffffffc004000004 
.set MSIP_ADDR_CORE2        ,0xffffffc004000008 
.set MSIP_ADDR_CORE3        ,0xffffffc00400000c 

#rewritenew
#mtimecmp
.set MTIME_CMP_ADDR_CORE0   ,0xffffffc004004000 
.set MTIME_CMP_ADDR_CORE0H  ,0xffffffc004004004 
.set MTIME_CMP_ADDR_CORE1   ,0xffffffc004004008 
.set MTIME_CMP_ADDR_CORE1H  ,0xffffffc00400400c 
.set MTIME_CMP_ADDR_CORE2   ,0xffffffc004004010 
.set MTIME_CMP_ADDR_CORE2H  ,0xffffffc004004014 
.set MTIME_CMP_ADDR_CORE3   ,0xffffffc004004018 
.set MTIME_CMP_ADDR_CORE3H  ,0xffffffc00400401c 

#mtime
.set MTIME_ADDR             ,0xffffffc00400bff8 

#ssip
.set SSIP_ADDR_CORE0        ,0xffffffc00400c000 
.set SSIP_ADDR_CORE1        ,0xffffffc00400c004 
.set SSIP_ADDR_CORE2        ,0xffffffc00400c008 
.set SSIP_ADDR_CORE3        ,0xffffffc00400c00c 

#stimecmp
.set STIME_CMP_ADDR_CORE0   ,0xffffffc00400d000 
.set STIME_CMP_ADDR_CORE0H  ,0xffffffc00400d004 
.set STIME_CMP_ADDR_CORE1   ,0xffffffc00400d008 
.set STIME_CMP_ADDR_CORE1H  ,0xffffffc00400d00c 
.set STIME_CMP_ADDR_CORE2   ,0xffffffc00400d010 
.set STIME_CMP_ADDR_CORE2H  ,0xffffffc00400d014 
.set STIME_CMP_ADDR_CORE3   ,0xffffffc00400d018 
.set STIME_CMP_ADDR_CORE3H  ,0xffffffc00400d01c 

#plic memory
.set PLICBASE_M    ,0x4000000000
.set PLICBASE_S    ,0xffffffc000000000
.set INTPRIO       ,0x0
.set INTPEND       ,0x1000
.set INTIE         ,0x2000
.set INTIE_HART    ,0x80


.set INT_S_PERM    ,0x1ffffc
.set INTTH	    ,0x200000
.set INTCLAIM      ,0x200004
.set INTHC_HART    ,0x1000


#for m  memory mapped  int addr
#msip
.set MSIP_M_ADDR_CORE0        ,0x4004000000 
.set MSIP_M_ADDR_CORE1        ,0x4004000004 
.set MSIP_M_ADDR_CORE2        ,0x4004000008 
.set MSIP_M_ADDR_CORE3        ,0x400400000c 

#rewritenew
#mtimecmp
.set MTIME_CMP_M_ADDR_CORE0   ,0x4004004000 
.set MTIME_CMP_M_ADDR_CORE0H  ,0x4004004004 
.set MTIME_CMP_M_ADDR_CORE1   ,0x4004004008 
.set MTIME_CMP_M_ADDR_CORE1H  ,0x400400400c 
.set MTIME_CMP_M_ADDR_CORE2   ,0x4004004010 
.set MTIME_CMP_M_ADDR_CORE2H  ,0x4004004014 
.set MTIME_CMP_M_ADDR_CORE3   ,0x4004004018 
.set MTIME_CMP_M_ADDR_CORE3H  ,0x400400401c 

#mtime
.set MTIME_M_ADDR             ,0x400400bff8 

#ssip
.set SSIP_M_ADDR_CORE0        ,0x400400c000 
.set SSIP_M_ADDR_CORE1        ,0x400400c004 
.set SSIP_M_ADDR_CORE2        ,0x400400c008 
.set SSIP_M_ADDR_CORE3        ,0x400400c00c 

#stimecmp
.set STIME_CMP_M_ADDR_CORE0   ,0x400400d000 
.set STIME_CMP_M_ADDR_CORE0H  ,0x400400d004 
.set STIME_CMP_M_ADDR_CORE1   ,0x400400d008 
.set STIME_CMP_M_ADDR_CORE1H  ,0x400400d00c 
.set STIME_CMP_M_ADDR_CORE2   ,0x400400d010 
.set STIME_CMP_M_ADDR_CORE2H  ,0x400400d014 
.set STIME_CMP_M_ADDR_CORE3   ,0x400400d018 
.set STIME_CMP_M_ADDR_CORE3H  ,0x400400d01c 

#for Mmode added csr
#.set mnxti         ,0x345
#.set mintstatus    ,0x346
#.set mtvt          ,0x307

.set mcntinhbt     ,0x320
.set mxstatus      ,0x7c0
.set mhcr          ,0x7c1
.set mcor          ,0x7c2
.set mccr2         ,0x7c3
.set mcer2         ,0x7c4
.set mhint         ,0x7c5
.set mrmr          ,0x7c6
.set mrvbr         ,0x7c7
.set mcer          ,0x7c8
.set mcounterwen   ,0x7c9
.set mcounterinten ,0x7ca
.set mcounterof    ,0x7cb
.set mhint2        ,0x7cc
.set mhint3        ,0x7cd
.set mhint4        ,0x7cE

.set mcins         ,0x7d2
.set mcindex       ,0x7d3
.set mcdata0       ,0x7d4
.set mcdata1       ,0x7d5
.set cpuid         ,0xfc0
.set mcountinhibit ,0x320
.set scountinhibit ,0x5c8

#for Smode added csr
.set sxstatus       ,0x5c0
.set shcr           ,0x5c1
.set scer2          ,0x5c2
.set scer           ,0x5c3
.set scounterinten  ,0x5c4
.set scounterof     ,0x5c5

.set scycle         ,0x5e0
.set stime          ,0x5e1
.set sinstret       ,0x5e2
.set shpmcounter3   ,0x5e3
.set shpmcounter4   ,0x5e4
.set shpmcounter5   ,0x5e5
.set shpmcounter6   ,0x5e6
.set shpmcounter7   ,0x5e7
.set shpmcounter8   ,0x5e8
.set shpmcounter9   ,0x5e9
.set shpmcounter10  ,0x5ea
.set shpmcounter11  ,0x5eb
.set shpmcounter12  ,0x5ec
.set shpmcounter13  ,0x5ed
.set shpmcounter14  ,0x5ee
.set shpmcounter15  ,0x5ef
.set shpmcounter16  ,0x5f0
.set shpmcounter17  ,0x5f1
.set shpmcounter18  ,0x5f2
.set shpmcounter19  ,0x5f3
.set shpmcounter20  ,0x5f4
.set shpmcounter21  ,0x5f5
.set shpmcounter22  ,0x5f6
.set shpmcounter23  ,0x5f7
.set shpmcounter24  ,0x5f8
.set shpmcounter25  ,0x5f9
.set shpmcounter26  ,0x5fa
.set shpmcounter27  ,0x5fb
.set shpmcounter28  ,0x5fc
.set shpmcounter29  ,0x5fd
.set shpmcounter30  ,0x5fe
.set shpmcounter31  ,0x5ff

.set mhpmcr         ,0x7f0
.set shpmcr         ,0x5c9
.set mhpmsp         ,0x7f1
.set mhpmep         ,0x7f2
.set shpmsp         ,0x5ca
.set shpmep         ,0x5cb

.set smir           ,0x9c0
.set smlo0          ,0x9c1
.set smhi           ,0x9c2
.set smcr           ,0x9c3

#for Umode added csr
.set fxcr          ,0x800
.set vlenb         ,0xc22

.set cycle         ,0xc00
.set time          ,0xc01
.set instret       ,0xc02
.set hpmcounter3   ,0xc03
.set hpmcounter4   ,0xc04
.set hpmcounter5   ,0xc05
.set hpmcounter6   ,0xc06
.set hpmcounter7   ,0xc07
.set hpmcounter8   ,0xc08
.set hpmcounter9   ,0xc09
.set hpmcounter10  ,0xc0a
.set hpmcounter11  ,0xc0b
.set hpmcounter12  ,0xc0c
.set hpmcounter13  ,0xc0d
.set hpmcounter14  ,0xc0e
.set hpmcounter15  ,0xc0f
.set hpmcounter16  ,0xc10
.set hpmcounter17  ,0xc11
.set hpmcounter18  ,0xc12
.set hpmcounter19  ,0xc13
.set hpmcounter20  ,0xc14
.set hpmcounter21  ,0xc15
.set hpmcounter22  ,0xc16
.set hpmcounter23  ,0xc17
.set hpmcounter24  ,0xc18
.set hpmcounter25  ,0xc19
.set hpmcounter26  ,0xc1a
.set hpmcounter27  ,0xc1b
.set hpmcounter28  ,0xc1c
.set hpmcounter29  ,0xc1d
.set hpmcounter30  ,0xc1e
.set hpmcounter31  ,0xc1f

#.set CLICBASE      ,0xE000E100
#.set INTIP         ,0x0
#.set INTIE         ,0x400
#.set INTCFG        ,0x800
#.set CLICCFG        ,0xb00
#.set CLICTH	      ,0xb04
#.set CLICTHCFG     ,0xb08


.ifndef delegation
.set EPC            ,0x341
.set STATUS         ,0x300
.set IE             ,0x304
.set IP             ,0x344
.set TVEC           ,0x305
.set COUNTEREN      ,0x306
.set SCRATCH        ,0x340
.set CAUSE          ,0x342
.set TVAL           ,0x343
.macro RETN
 mret
.endm
.set VECTOR_TABLE   ,mvector_table
.else
.set EPC            ,0x141
.set STATUS         ,0x100
.set IE             ,0x104
.set IP             ,0x144
.set TVEC           ,0x105
.set COUNTEREN      ,0x106
.set SCRATCH        ,0x140
.set CAUSE          ,0x142
.set TVAL           ,0x143
.macro RETN
 sret
.endm
.set VECTOR_TABLE   ,svector_table
.endif

.macro EXIT
  la   x1, __exit
  jr   x1
.endm

.macro FAIL
  la   x1, __fail 
  jr   x1
.endm  

#.macro WSC
#  .long 0xcff01073 
#.endm 
#
#===========================================================


# ===============PART1 : SET HANDLER ENTRY==================
#------------------------------------------------------------------------
# --Part 1.1 Set exp's handler entry address
.macro SETEXP EXP_CODE, HANDLER_BEGIN,HANDLER_END
  #push stack
  sd   t0, -24(sp)   #address cann't be changed 
  sd   t1, -32(sp)   #it relates to crt0.s

  #t1 = the address that stores expcode's handler entry address
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, VECTOR_TABLE
  add  t1, t1, t0
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0 
  
  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END 

  #to match sync_exception and async_exception in crt0.s to make smoke.s run
  #a4 is x14 register
  ld   a4, -16(sp)
.endm

# --Part 1.2 Set mmode exp's handler entry address
.macro SETMEXP EXP_CODE, HANDLER_BEGIN,HANDLER_END
  sd   t0, -24(sp)   #address cann't be changed 
  sd   t1, -32(sp)   #it relates to crt0.s

 #t1 = the address that stores expcode's handler entry address
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, mvector_table
  add  t1, t1, t0
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0 
  
  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END 

  ld   a4, -16(sp)
.endm

# --Part 1.3 Set smode exp's handler entry address
.macro SETSEXP EXP_CODE, HANDLER_BEGIN,HANDLER_END
  sd   t0, -24(sp)   #address cann't be changed 
  sd   t1, -32(sp)   #it relates to crt0.s

  #t1 = the address that stores expcode's handler entry address
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, svector_table
  add  t1, t1, t0
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0 
  
  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END 

  ld   a4, -16(sp)
.endm

# --Part 1.4 Set interrupt's handler entry address
.macro SETINT EXP_CODE, HANDLER_BEGIN,HANDLER_END
  sd   t0, -24(sp)   #address cann't be changed
  sd   t1, -32(sp)   #it relates to crt0.s

# addi t0,x0,\VECTOR_MODE
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, VECTOR_TABLE + 128  #intterrupt start address, to skip the exception address
  add  t1, t1, t0
#  la   t2, clic_vector_table
#  .long 0x00028463 #beqz t0,label_1
#  mv   t0, t2
#  .short 0xa011    #j label_2
#  #label_1:
#  mv   t0,t1
#  #label_2:
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0   

  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END
 
  ld   a4, -16(sp)
.endm

# --Part 1.5 Set mmode interrupt's handler entry address
.macro SETMINT EXP_CODE, HANDLER_BEGIN,HANDLER_END
  sd   t0, -24(sp)   #address cann't be changed
  sd   t1, -32(sp)   #it relates to crt0.s

#  addi t0,x0,\VECTOR_MODE
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, mvector_table + 128  #intterrupt start address
  add  t1, t1, t0
#  la   t2, clic_vector_table
#  .long 0x00028463 #beqz t0,label_1
#  mv   t0, t2
#  .short 0xa011    #j label_2
#  #label_1:
#  mv   t0,t1
#  #label_2:
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0   

  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END
 
  ld   a4, -16(sp)
.endm

# --Part 1.6 Set smode interrupt's handler entry address
.macro SETSINT EXP_CODE, HANDLER_BEGIN,HANDLER_END
  sd   t0, -24(sp)   #address cann't be changed
  sd   t1, -32(sp)   #it relates to crt0.s

#  addi t0,x0,\VECTOR_MODE
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, svector_table + 128  #intterrupt start address
  add  t1, t1, t0
#  la   t2, clic_vector_table
#  .long 0x00028463 #beqz t0,label_1
#  mv   t0, t2
#  .short 0xa011    #j label_2
#  #label_1:
#  mv   t0,t1
#  #label_2:
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0   

  la   t0, \HANDLER_BEGIN
  sd   t0, 0(t1) 

  ld   t1, -32(sp)
  ld   t0, -24(sp)
  j    \HANDLER_END
 
  ld   a4, -16(sp)
.endm
#------------------------------------------------------------------------

.macro CONTEXT_PUSH
  sw   
.endm

#===============Part 2:Change to Mode=========================================
#------------------------------------------------------------------------
# --Part 2.1: Change to M Mode
.macro TRAP_TO_M HANDLER_BEGIN,HANDLER_END
  addi sp,sp,-16
  sd   t0, 8(sp)   #address cann't be changed 
  sd   t1, 16(sp)   #address cann't be changed 

  la   t0, \HANDLER_BEGIN
  li   t1, 0
  ebreak

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16
  j    \HANDLER_END
.endm

# --Part 2.2: Change to S Mode
.macro CHG_TO_S 
  addi sp,sp,-8
  sd   t1, 8(sp)   #address cann't be changed

  li   t1, 1 
  c.ebreak

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

# --Part 2.3: Change to U Mode
.macro CHG_TO_U
  addi sp,sp,-8
  sd   t1, 8(sp)   #address cann't be changed

  li   t1, 2
  c.ebreak

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

# --Part 2.4: Set MPP 2'b01
.macro MSTATUS_MPP_S
  addi sp,sp,-16
  sd   t0, 8(sp)   #address cann't be changed 
  sd   t1, 16(sp)   #address cann't be changed 

  csrr t0, mstatus
  li   t1, 0xffffffffffffefff 
  and  t0, t0, t1
  li   t1, 0x800
  or   t0, t0, t1  #MPP = 2'b01
  csrw mstatus, t0

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16

.endm

# --Part 2.5: Set MPP 2'b00
.macro MSTATUS_MPP_U
  addi sp,sp,-16
  sd   t0, 8(sp)   #address cann't be changed 
  sd   t1, 16(sp)   #address cann't be changed 

  csrr t0, mstatus
  li   t1, 0xffffffffffffe7ff  #MPP = 2'b00
  and  t0, t0, t1
  csrw mstatus, t0

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16

.endm
#-----------------------------------------------------------------

.macro RET_FROM_M
  mret
.endm
.macro RECOVER_EXP_EBREAK SEED

  sd   t0, -8(sp)   #address cann't be changed
  sd   t1, -16(sp)   #it relates to crt0.s

  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, mvector_table
  add  t1, t1, t0
  li   t0, 3
  slli t0,t0,0x3
  add  t1,t1,t0

  la   t0, EXP_EBREAK_BEGIN_\SEED 
  sd   t0, 0(t1)

  ld   t1, -16(sp)
  ld   t0, -8(sp)
  j    EXP_EBREAK_END_\SEED

  ld   a4, -16(sp)
  EXP_EBREAK_BEGIN_\SEED:
  bnez t1, CHG_\SEED 
#  .short 0xe891
  csrr t1, mepc
  addi t1, t1,2
  csrw mepc,t1
  jr   t0

  CHG_\SEED:
  addi t1,t1,-1
  bnez t1, CHG_TO_U_\SEED
  CHG_TO_S_\SEED:
  csrr t1, mepc
  addi t1, t1,2
  csrw mepc,t1  
  li t1, 0x1000
  csrc mstatus,t1
  li t1, 0x800
  csrs mstatus,t1
  mret

  CHG_TO_U_\SEED:
  csrr t1, mepc
  addi t1, t1,2
  csrw mepc,t1
  li t1, 0x1000
  csrc mstatus,t1
  li t1, 0x800
  csrc mstatus,t1
  mret

  
  EXP_EBREAK_END_\SEED:
  nop 
.endm

.ifndef tee_extension
.macro RECOVER_EXP_MEINT SEED

  sd   t0, -8(sp)   #address cann't be changed
  sd   t1, -16(sp)   #it relates to crt0.s

  csrr t0, mhartid
  slli t0, t0, 8
  #la   t1, mvector_table + 128  #intterrupt start address
  la   t1, VECTOR_TABLE + 128  #intterrupt start address
  add  t1, t1, t0
  li   t0, 11
  slli t0,t0,0x3
  add  t1,t1,t0

  la   t0, EXP_MEINT_BEGIN_\SEED 
  sd   t0, 0(t1)

  ld   t1, -16(sp)
  ld   t0, -8(sp)
  j    EXP_MEINT_END_\SEED

  ld   a4, -16(sp)
  EXP_MEINT_BEGIN_\SEED:
  mret
  EXP_MEINT_END_\SEED:
  nop 
.endm
.else
.macro RECOVER_EXP_MEINT SEED

  sd   t0, -8(sp)   #address cann't be changed
  sd   t1, -16(sp)   #it relates to crt0.s

  csrr t0, mhartid
  slli t0, t0, 8
  #la   t1, mvector_table + 128  #intterrupt start address
  la   t1, VECTOR_TABLE + 128  #intterrupt start address
  add  t1, t1, t0
  li   t0, 11
  slli t0,t0,0x3
  add  t1,t1,t0

  la   t0, EXP_MEINT_BEGIN_\SEED 
  sd   t0, 0(t1)

  ld   t1, -16(sp)
  ld   t0, -8(sp)
  j    EXP_MEINT_END_\SEED

  ld   a4, -16(sp)
  EXP_MEINT_BEGIN_\SEED:
  # inv tlb for isa(not necessarily)
  sfence.vma x0,x0 
  # clr cache
  dcache.call
  # disable cache
  DATA_CACHE_DIS
  INST_CACHE_DIS
  csrw  mie,x0
  # disable mmu
  MMU_DIS
  # disable snoop
  SNOOP_DIS
  fence iorw,iorw
  # wfi
  wfi
  mret
  EXP_MEINT_END_\SEED:
  nop 
.endm
.endif

.macro RECOVER_EXP_MEINT_DEL SEED

  sd   t0, -8(sp)   #address cann't be changed
  sd   t1, -16(sp)   #it relates to crt0.s

  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, svector_table + 128  #intterrupt start address
  add  t1, t1, t0
  li   t0, 11
  slli t0,t0,0x3
  add  t1,t1,t0

  la   t0, EXP_MEINT_BEGIN_DEL_\SEED
  sd   t0, 0(t1)

  ld   t1, -16(sp)
  ld   t0, -8(sp)
  j    EXP_MEINT_END_DEL_\SEED

  ld   a4, -16(sp)
  EXP_MEINT_BEGIN_DEL_\SEED:
  sret
  EXP_MEINT_END_DEL_\SEED:
  nop
.endm

.macro RECOVER_EXP_SEINT_DEL SEED

  sd   t0, -8(sp)   #address cann't be changed
  sd   t1, -16(sp)   #it relates to crt0.s

  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, svector_table + 128  #intterrupt start address
  add  t1, t1, t0
  li   t0, 9
  slli t0,t0,0x3
  add  t1,t1,t0

  la   t0, EXP_SEINT_BEGIN_DEL_\SEED
  sd   t0, 0(t1)

  ld   t1, -16(sp)
  ld   t0, -8(sp)
  j    EXP_SEINT_END_DEL_\SEED

  ld   a4, -16(sp)
  EXP_SEINT_BEGIN_DEL_\SEED:
  sret
  EXP_SEINT_END_DEL_\SEED:
  nop
.endm

#.macro SETSEXP EXP_CODE, HANDLER_BEGIN,HANDLER_END
#  la   t1, secure_vector_table
#  addi t0,x0,\EXP_CODE
#  slli t0,t0,0x2
#  add  t1,t1,t0 
#  
#  la   t0, \HANDLER_BEGIN
#  sw   t0, 0(t1) 
#  j    \HANDLER_END 
#  lw   a4, -8(sp)
#.endm

#.macro SETSINT VECTOR_MODE,EXP_CODE, HANDLER_BEGIN,HANDLER_END
#  addi t0,x0,\VECTOR_MODE
#  la   t1, secure_vector_table + 64  #intterrupt start address
#  la   t2, secure_clic_vector_table
#  .long 0x00028463 #beqz t0,label_1
#  mv   t0, t2
#  .short 0xa011    #j label_2
#  #label_1:
#  mv   t0,t1
#  #label_2:
#  addi t1,x0,\EXP_CODE
#  slli t1,t1,0x2
#  add  t1,t1,t0   
#
#  la   t0, \HANDLER_BEGIN
#  sw   t0, 0(t1) 
#  j    \HANDLER_END 
#  lw   a4, -8(sp)
#.endm
#
#.macro SETWSC HANDLER_BEGIN,HANDLER_END
#  la   x4,\HANDLER_BEGIN 
#  csrr x3,nt_mebr
#  sw   x4,0(x3)
#  j    \HANDLER_END
#.endm
#
#.macro SETSWSC HANDLER_BEGIN,HANDLER_END
#  la   x4, \HANDLER_BEGIN 
#  csrr x3, mebr
#  sw   x4,0(x3)
#  j    \HANDLER_END
#
#.endm

##hardware clic cfg 
#.macro CHECK_STAT_C
##backup x10
#  csrw	mscratch,x10
##check all reg 
#  mv	x10,x1
#  mv	x10,x2
#  mv	x10,x3
#  mv	x10,x4
#  mv	x10,x5
#  mv	x10,x6
#  mv	x10,x7
#  mv	x10,x8
#  mv	x10,x9
#  mv	x10,x11
#  mv	x10,x12
#  mv	x10,x13
#  mv	x10,x14
#  mv	x10,x15
##check current status
##tee related csr
#  csrr	x10,mxstatus
##common csr
#  csrr	x10,mstatus
#  csrr	x10,mcause
#  csrr	x10,mtvec
#  csrr	x10,mip
#  csrr	x10,mie
#  csrr  x10,mepc
#  csrr	x10,mtval
##clic related csr
#  csrr	x10,mtvt
#  csrr	x10,mnxti
#  csrr	x10,mintstatus
##recover x10
#  csrr	x10,mscratch
#.endm  
#
##hardareware msp cfg/tee 
#.macro RV_NIE_SP
##backup x10
#  csrw	mscratch,x10
##push mstatus/mcause/mxstatus/mepc
#  csrr	x10,mstatus 
#  sw	x10,-4(x2)
#  csrr	x10,mcause 
#  sw	x10,-8(x2)
#  csrr	x10,mxstatus
#  sw	x10,-12(x2)
#  csrr	x10,mepc
#  sw	x10,-16(x2)
##recover x10
#  csrr	x10,mscratch
##push x5~x7,x10~x15
#  sw	x5,-20(x2)
#  sw	x6,-24(x2)
#  sw	x7,-28(x2)
#  sw	x10,-32(x2)
#  sw	x11,-36(x2)
#  sw	x12,-40(x2)
#  sw	x13,-44(x2)
#  sw	x14,-48(x2)
#  sw	x15,-52(x2)
#  addi	x2,x2,-52
##set ie
#  csrsi	mstatus,0x8
#.endm 
#
##hardareware msp cfg/tee 
#.macro RV_NIR_SP
##clr ie
#  csrci	mstatus,0x8
##pop x5-x7,x10~x15
#  lw	x15,0x0(x2)
#  lw	x14,0x4(x2)
#  lw	x13,0x8(x2)
#  lw	x12,0xc(x2)
#  lw	x11,0x10(x2)
#  lw	x10,0x14(x2)
#  lw	x7,0x18(x2)
#  lw	x6,0x1c(x2)
#  lw	x5,0x20(x2)
##backup x10
#  csrw	mscratch,x10
##pop mepc/mxstatus/mcause/mstatus
#  lw	x10,0x24(x2)
#  csrw	mepc,x10
#  lw	x10,0x28(x2)
#  csrw	mxstatus,x10
#  lw	x10,0x2c(x2)
#  csrw	mcause,x10
#  lw	x10,0x30(x2)
#  csrw	mstatus,x10
##move sp
#  addi	x2,x2,0x34
##recover x10
#  csrr	x10,mscratch
##return
#  mret
#.endm  
#
 
.macro RECOVER_EXP EXP_CODE,PC_ADD,SEED
  csrr t0, mhartid
  slli t0, t0, 8
  la   t1, VECTOR_TABLE
  add  t1, t1, t0
  addi t0,x0,\EXP_CODE
  slli t0,t0,0x3
  add  t1,t1,t0 
  
  la   t0, EXP_BEGIN_\SEED\EXP_CODE
  sd   t0, 0(t1) 

  j    EXP_END_\SEED\EXP_CODE

  EXP_BEGIN_\SEED\EXP_CODE:
  # epc + 4 
  csrr x31, EPC
  addi x31,x31,\PC_ADD
  csrw EPC,x31
  # ret
  RETN
  EXP_END_\SEED\EXP_CODE:
.endm


.macro CPU_WRITE ADDR, DATA
  #backup regs
  addi	x2, x2, -16
  sd	x12,  (x2)
  sd	x13, 8(x2)

  #write 
  li	x12, \ADDR
  li	x13, \DATA
  sw    x13, (x12)

  #restore regs
  ld    x13, 8(x2)
  ld    x12,  (x2)
  addi	x2, x2, 16
.endm

#.macro CPU_READ ADDR, DATA//, LABEL
.macro CPU_READ ADDR, DATA
  #backup regs
  addi	x2, x2, -16
  sd	x12,  (x2)
  sd	x13, 8(x2)

  #write 
  li	x12, \ADDR
  lwu   x12, (x12)
  li	x13, \DATA
 # bne   x12, x13, \LABEL 

  #restore regs
  ld    x13, 8(x2)
  ld    x12,  (x2)
  addi	x2, x2, 16
.endm

