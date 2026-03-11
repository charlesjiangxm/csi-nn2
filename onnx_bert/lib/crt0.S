//start from __start,
//(0)general configure
//(1)initialize gpr
//(2)initialize ppn & stack pointer
//(3)initialize some CSRs
//(4)jump to main
//(5)exit mechanism
//(6)trap handler & exception process
 .include "core_init.h"
    .SET CORENUM, 1
  #if defined(CORENUM_4)
    .set CORENUM, 4
  #elif defined(CORENUM_3)
    .set CORENUM, 3
  #elif defined(CORENUM_2)
    .set CORENUM, 2
  #endif

.macro THREADS_SYNC ADDR, NUM, SRC_LABEL
	addi x2, x2, -24
	sw   x14, 0(x2)
	sw   x15, 8(x2)
	sw   x16, 16(x2)

	li x14, \ADDR
	li x15, 1
	amoadd.w x0, x15, (x14)
	li x15, \NUM
WAIT_\SRC_LABEL:
	amoadd.w x16, x0, (x14)
	bne x16, x15, WAIT_\SRC_LABEL
	sync
	fence rw, rw

	lw   x16, 16(x2)
	lw   x15, 8(x2)
	lw   x14, 0(x2)
	addi x2, x2, 24
.endm

	.text
	.global	__start
__start:

  csrr x23, mhartid
  li   x13, 4
  bne  x23, x13, THREAD_MAIN

.global THREAD_COPROC
THREAD_COPROC:
  jal IPMC_BOOT
  jal SET_COPROC_INT
  wfi
  wfi

.global THREAD_MAIN
THREAD_MAIN:
//--------------------------PART 0: general configure-------------------------

////enable THEADISAEE
  li   x3, 0x400000                
  csrs mxstatus,x3


////enable fpu
  li   x3, 0x2000
csrs mstatus,x3
fmv.d.x f0,x0
fmv.d.x f1,x0
fmv.d.x f2,x0
fmv.d.x f3,x0
fmv.d.x f4,x0
fmv.d.x f5,x0
fmv.d.x f6,x0
fmv.d.x f7,x0
fmv.d.x f8,x0
fmv.d.x f9,x0
fmv.d.x f10,x0
fmv.d.x f11,x0
fmv.d.x f12,x0
fmv.d.x f13,x0
fmv.d.x f14,x0
fmv.d.x f15,x0
fmv.d.x f16,x0
fmv.d.x f17,x0
fmv.d.x f18,x0
fmv.d.x f19,x0
fmv.d.x f20,x0
fmv.d.x f21,x0
fmv.d.x f22,x0
fmv.d.x f23,x0
fmv.d.x f24,x0
fmv.d.x f25,x0
fmv.d.x f26,x0
fmv.d.x f27,x0
fmv.d.x f28,x0
fmv.d.x f29,x0
fmv.d.x f30,x0
fmv.d.x f31,x0



////enable vector
  li   x3, 0x200
csrs mstatus,x3   #set mstatus_VS=2'b01
vsetvli x3, x0, e64, m1
vmv.v.x v0, x0
vmv.v.x v1, x0
vmv.v.x v2, x0
vmv.v.x v3, x0
vmv.v.x v4, x0
vmv.v.x v5, x0
vmv.v.x v6, x0
vmv.v.x v7, x0
vmv.v.x v8, x0
vmv.v.x v9, x0
vmv.v.x v10, x0
vmv.v.x v11, x0
vmv.v.x v12, x0
vmv.v.x v13, x0
vmv.v.x v14, x0
vmv.v.x v15, x0
vmv.v.x v16, x0
vmv.v.x v17, x0
vmv.v.x v18, x0
vmv.v.x v19, x0
vmv.v.x v20, x0
vmv.v.x v21, x0
vmv.v.x v22, x0
vmv.v.x v23, x0
vmv.v.x v24, x0
vmv.v.x v25, x0
vmv.v.x v26, x0
vmv.v.x v27, x0
vmv.v.x v28, x0
vmv.v.x v29, x0
vmv.v.x v30, x0
vmv.v.x v31, x0



////enable matrix
  li     x28, 0x1
csrc mxstatus, x28
slli x28, x28, 25
csrs mstatus, x28



////enable unalign
  li   x3, 0x8000
  csrs mxstatus,x3  //set mxstatus_MM=1

////set MM=1, UCME=1, CLINTEE=1, THEADISAEE=1
  li   x3, 0x638000
  csrs mxstatus,x3

////set PMP
  li   x1, 0x1f00000000000000
  csrw pmpcfg0, x1             
  li   x1, 0xffffffffff
  csrw pmpaddr7, x1        
 
////enable snoop
  csrsi msmpr, 0x1

//----------------------PART 1: initialize gpr-------------------
  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0


//-------------------------PART 2: initialize ppn & stack pointer---------------------
 .global SP_INIT
SP_INIT:
  csrr x3,mhartid
  li x4,1
  beq x4, x3, cpu_1_sp
  li x4,2
  beq x4, x3, cpu_2_sp
  li x4,3
  beq x4, x3, cpu_3_sp


  .global cpu_0_sp	
cpu_0_sp:
  la x2, __kernel_stack_0
  j after_sp_init

  .global cpu_1_sp
cpu_1_sp:
  la x2, __kernel_stack_1
  j after_sp_init

  .global cpu_2_sp
cpu_2_sp:
  la x2, __kernel_stack_2
  j after_sp_init

  .global cpu_3_sp
cpu_3_sp:
  la x2, __kernel_stack_3
  j after_sp_init


  .global after_sp_init
after_sp_init:
.option push
.option norelax
  la x3, __global_pointer$
.option pop

//-----------------------------PART 3: initialize some CSRs-------------------------
////initialize mtvec value  
  la    x6,__mtrap_handler
  csrw  mtvec,x6

////initialize mtvec value  
  la    x6,__strap_handler
  csrw  stvec,x6


////enable MIE
  li   x6, 0x8
  csrs mstatus,x6

////config mcor: set CACHESEL=2'b11(sel icache & dcache), INV=1, BHT_INV=1, BTB_INV=1(invalid all)
  li x6, 0x70013
  csrs 0x7c2,x6  
 
////config mhcr: enable icache, dcache, WA, WB, RS, BPE, BTB, IBPE, WBR, LOBTB
  li x6, 0x11ff
  csrs mhcr,x6 
  
  .global after_l2en 
after_l2en:
////config mhcr: enable icache, dcache, WA, WB, RS, BPE, BTB, IBPE, WBR, LOBTB
  li x6, 0x10011bf
  csrs mhcr,x6 

////config mhint: enable dcache_prefetch,icache_prefetch,LPE,spec_fail_pred; set AMR=1, D_DIS=3
  li x6, 0x3a1aa10c
  csrs mhint,x6  

////enable L2Cache, L2Cache_prefetch; set IPRF=3; Actually RFE is fixed to 1
  li x6, 0xa0420002
  csrs mccr2,x6
 
  li x6,0xe0
  csrw satp,x6
 
  li x6,0 

//-------------------------PART 3.1: deassert reset signal of other core ------------
#if defined(CORENUM_4) || defined(CORENUM_3) || defined(CORENUM_2)

  li x21, 0xfb000
  li x22, 0x1

  csrr x20,mhartid
  bnez x20, WAIT_SYNC 

  sw x0, 0(x21)      //start sync addr
  sync

  li x23, 0x7
  li x24, 0x18030000 //CPR.sys_core_rst_reg
  sw x23, 0(x24)

WAIT_SYNC:
  THREADS_SYNC 0xfb000 CORENUM START_SYNC
  #if defined(FORCE_1CORE)
  csrr x31, mhartid
  bnez x31, __exit
  #endif
#endif

//-----------------------------PART 4: jump to main-------------------------
  jal	main

//--------------------------------------PART 5: exit mechanism------------------------------
////case success exit mechanism, load a specified imm(0x444333222) to a register
////tb.v can scan the special operation.
  .global __exit
__exit:
  sync
  li   x3, 0x444333222
  add x4,x0,x3
  wfi

////case fail exit mechanism, load a specified imm(0x2382348720) to a register
////tb.v can scan the special operation.
  .global __fail
__fail:
  addi x10,x0,0x0
  addi x1,x0,0x2c
  addi x2,x0,0x3b
  sync
  li x3,0x2382348720


//--------------------------------------PART6: trap_handler & exception process------------------------------
.section .text
__mtrap_handler:
  j __msynchronous_exception
  .align 2
  j __asychronous_int
  .align 2
  nop //reserved
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  nop //reserved
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  j __asychronous_int
  .align 2
  nop //reserved
  .align 2
  j __asychronous_int
  j __fail

__msynchronous_exception:
////push stack
  sd   x13,-8(sp)
  sd   x14,-16(sp)
  sd   x15,-24(sp)

////extract int information
  csrr x14,mcause   
  andi x15,x14,0x7ff  //get the exception code
  srli x14,x14,0x3b   //get the interrupt bit,{interrupt bit,4'b0000}
  andi x14,x14,0x10   //mask bit, x14 is interrupt bit
  add  x14,x14,x15    //{int,cause}

////calculate the exception entry addr
  slli x14,x14,0x3    //offset
  la   x15,vector_table
  add  x15,x14,x15    //target pc
  lw   x14, 0(x15)    //get exception entry addr

////pop stack
  ld   x13, -8(sp)    //recover x13
  ld   x15, -24(sp)   //recover x15
  addi x14,x14,-4
  jr   x14

__asychronous_int:
////push stack
  sd   x13,-8(sp)
  sd   x14,-16(sp)
  sd   x15,-24(sp)

////extract int information
  csrr x14,mcause   
  andi x15,x14,0x7ff  //get the exception code
  srli x14,x14,0x3b   //get the interrupt bit,{interrupt bit,4'b0000}
  andi x14,x14,0x10   //mask bit, x14 is interrupt bit
  add  x14,x14,x15    //{int,cause}

////calculate the exception entry addr
  slli x14,x14,0x3    //offset
  la   x15,vector_table
  add  x15,x14,x15    //target pc
  lw   x14, 0(x15)    //get exception entry addr

////pop stack
  lw   x13, -8(sp)    //recover x13
  lw   x15, -24(sp)   //recover x15
  addi x14,x14,-4
  jr   x14


__strap_handler:
  j __ssynchronous_exception

  j __fail

__ssynchronous_exception:
////push stack
  sd   x13,-8(sp)
  sd   x14,-16(sp)
  sd   x15,-24(sp)

////extract int information
  csrr x14,scause   
  andi x15,x14,0x7ff  //get the exception code
  srli x14,x14,0x3b   //get the interrupt bit,{interrupt bit,4'b0000}
  andi x14,x14,0x10   //mask bit, x14 is interrupt bit
  add  x14,x14,x15    //{int,cause}

////calculate the exception entry addr
  slli x14,x14,0x3    //offset
  la   x15,svector_table
  add  x15,x14,x15    //target pc
  lw   x14, 0(x15)    //get exception entry addr

////pop stack
  lw   x13, -8(sp)    //recover x13
  lw   x15, -24(sp)   //recover x15
  addi x14,x14,-4
  jr   x14


.global vector_table
 .align  10
  vector_table:   //totally 256 entries
  .rept   128
  .long   __fail
  .endr

  .global __dummy
__dummy:  
  
  .data
  nop
  nop
  nop

.global svector_table
 .align  10
  svector_table:
  .rept   128
  .long   __fail
  .endr



