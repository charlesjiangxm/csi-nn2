########################################################################################
#                Included Macro                                                        #
#  1.  MSTATUS_FS           SET MSTATUS.FS = IMM                                       #
#  2.  MSTATUS_VS           SET MSTATUS.VS = IMM                                       #
#  3.  MMODE_SMODE          SET MEPC = SROUTINE, MPP = 2'b01 SMODE                     #
#  4.  MMODE_SMODE_S        SET SEPC = SROUTINE, SPP = 1'b1 SMODE                      #
#  5.  SMODE_UMODE          SET SEPC = UROUTINE, SPP = 1'b0 UMODE                      #
#  6.  MMODE_UMODE          SET MEPC = UROUTINE, MPP = 2'b00 UMODE                     #
#  7.  MMODE_UMODE_S        SET SEPC = UROUTINE, SPP = 1'b0 UMODE                      #
########################################################################################




# SET MSTATUS.FS = IMM
.macro MSTATUS_FS IMM
  #write fs
  li    x9,0x6000
  csrc  mstatus,x9    #set fs 2'b00
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,13
  or    x9,x9,x10
  csrw  mstatus,x9    #set fs \IMM
.endm

#SET MSTATUS.VS = IMM
.macro MSTATUS_VS IMM
  #write vs
  #li    x9,0x1800000
  li    x9,0x600
  csrc  mstatus,x9   #set vs 2'b00
  csrr  x9,mstatus
  li    x10, \IMM
  #slli  x10,x10,23
  slli  x10,x10,9
  or    x9,x9,x10
  csrw  mstatus,x9    #set vs \IMM
.endm

#SET MEPC = SROUTINE, MPP = 2'b01 SMODE
.macro MMODE_SMODE  SROUTINE
  #disable sie/mie
  li   x29, 0x2
  csrc mstatus,x29
  li   x29, 0x8
  csrc mstatus,x29
  #write mepc
  la x1,\SROUTINE
  csrw mepc,x1
  li x1,0x800
  csrrs x3,mstatus,x1
  li x1,0x1000
  csrrc x3,mstatus,x1
  mret
.endm

#SET SEPC = SROUTINE, SPP = 1'b1 SMODE
.macro MMODE_SMODE_S  SROUTINE
  #disable sie/mie
  li   x29, 0x2
  csrc mstatus,x29
  li   x29, 0x8
  csrc mstatus,x29
  #write sepc
  la x1,\SROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrs x0,mstatus,x1
  sret
.endm

#SET SEPC = UROUTINE, SPP = 1'b0 UMODE
.macro SMODE_UMODE  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x3,sstatus,x1
  sret
.endm

#SET MEPC = UROUTINE, MPP = 2'b00 UMODE
.macro MMODE_UMODE  UROUTINE
  #write mepc
  la x1,\UROUTINE
  csrw mepc,x1
  li x1,0x1800
  csrrc x3,mstatus,x1
  mret
.endm

#SET SEPC = UROUTINE, SPP = 1'b0 UMODE
.macro MMODE_UMODE_S  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x0,mstatus,x1
  sret
.endm




