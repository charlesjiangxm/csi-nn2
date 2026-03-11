################################################################################################
#                                 Included Macro                                               #
#  1.  INST_CACHE_EN        SET MHCR.IE = 1'b1                                                 #
#  2.  INST_CACHE_DIS       SET MHCR.IE = 1'b0                                                 #
#  3.  INST_CACHE_INV       SET MCOR.CACHESEL = 2'b01 (ICACHE) & MCOR.INV = 1'b1               #
#  4.  BR_PREDICTION_EN     SET MHCR.BPE = 1'b1                                                #
#  5.  BR_PREDICTION_DIS    SET MHCR.BPE = 1'b0                                                #
#  6.  BHT_INV              SET MCOR.BHT_INV = 1'b1                                            #
#  7.  BTB_EN               SET MHCR.BTB = 1'b1                                                #
#  8.  BTB_DIS              SET MHCR.BTB = 1'b0                                                #
#  9.  BTB_INV              SET MCOR.BTB_INV = 1'b1                                            #
#  10. L0_BTB_EN            SET MHCR.L0BTB = 1'b1                                              #
#  11. L0_BTB_DIS           SET MHCR.L0BTB = 1'b0                                              #
#  12. RAS_EN               SET MHCR.RS = 1'b1                                                 #
#  13. RAS_DIS              SET MHCR.RS = 1'b0                                                 #
#  14. IND_BTB_EN           SET MHCR.IBPE = 1'b1                                               #
#  15. IND_BTB_DIS          SET MHCR.IBPE = 1'b0                                               #
#  16. IND_BTB_INV          SET MCOR.IBP_INV = 1'b1                                            #
#  17. INST_PREFETCH_EN     SET MHINT.IPLD = 1'b1                                              #
#  18. INST_PREFETCH_DIS    SET MHINT.IPLD = 1'b0                                              #
#  19. LOOP_BUFFER_EN       SET MHINT.LPE = 1'b1                                               #
#  20. LOOP_BUFFER_DIS      SET MHINT.LPE = 1'b0                                               #
#  21. WAY_PREDICTION_EN    SET MHINT.IWPE = 1'b1                                              #
#  22. WAY_PREDICTION_DIS   SET MHINT.IWPE = 1'b0                                              #
#  23. ID_CACHE_IV_ALL      SET MCOR.CACHESEL = 2'b11 & MCOR.INV = 1'b1                        #
#  24. JAL_IMM_SHIFT        SET ????                                                           #
#  25. CONDB_IMM_SHIFT      X31 BIT SHIFT X31[10:5] --> X31[30:25]                             #
#                             X31[12]-->X31[31] X31[11] --> X31[7]  X31[4:1] --> X31[11:8]     #
#  26. RET_TO_LOW           SET MSTATUS.MPP[1] = 1'b0                                          #
#  27. SPEC_PRED_EN         SET MHINT.NO_SPEC = 1'b1                                           #
#  28. SPEC_PRED_DIS        SET MHINT.NO_SPEC = 1'b0                                           #
#  29. MHINT_ECC            SET MHINT.ECC = IMM                                                #
################################################################################################



#I-cache operation

#SET MHCR.IE = 1'b1
.macro INST_CACHE_EN
  csrsi mhcr,0x1
.endm

#SET MHCR.IE = 1'b0
.macro INST_CACHE_DIS
  csrci mhcr,0x1
.endm

#SET MCOR.CACHESEL = 2'b01 (ICACHE) & MCOR.INV = 1'b1
.macro INST_CACHE_INV
  csrsi	mcor,0x1
  csrci	mcor,0x2
  csrsi	mcor,0x10
.endm

#.macro INST_CACHE_INV_ADDR ADDR_REG,IMM_REG

#.endm

#.macro INST_CACHE_INV_SETWAY SETWAY_REG,IMM_REG

#.endm


#BHT operation

#SET MHCR.BPE = 1'b1
.macro BR_PREDICTION_EN
  #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)

  #set mhcr.bpe = 1'b1
  csrr	x3,mhcr
  ori	x3,x3,0x20
  csrw	mhcr,x3

  #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHCR.BPE = 1'b0
.macro BR_PREDICTION_DIS
  #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  
  #set mhcr.bpe = 1'b0
  csrr	x3,mhcr
  andi	x3,x3,0xffffffffffffffdf
  csrw	mhcr,x3
  
  #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 16
.endm

#SET MCOR.BHT_INV = 1'b1
.macro BHT_INV
  #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
  
  #1
  csrr	x3,mcor
  li	x4,0x10000
  or	x3,x3,x4
  csrw	mcor,x3
  
  
  #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm


#BTB operation
#SET MHCR.BTB = 1'b1
.macro BTB_EN
  #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)
  
  #1
  csrr	x3,mhcr
  ori	x3,x3,0x40
  csrw    mhcr,x3
  
  #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHCR.BTB = 1'b0
.macro BTB_DIS
  #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)
  
  #1
  csrr	x3,mhcr
  andi	x3,x3,0xffffffffffffffbf
  csrw    mhcr,x3
  
  
  #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MCOR.BTB_INV = 1'b1
.macro BTB_INV
  #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2) 
  
  #1
  csrr	x3,mcor
  li	x4,0x20000
  or      x3,x4,x3
  csrw    mcor,x3
  
  #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm

#SET MHCR.L0BTB = 1'b1
.macro L0_BTB_EN
  #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
  
  #1
  csrr	x3,mhcr
  li	x4,0x1000
  or	x3,x3,x4
  csrw    mhcr,x3
  
  #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm

#SET MHCR.L0BTB = 1'b0
.macro L0_BTB_DIS
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
  
  #1
  csrr	x3,mhcr
  li	x4,0xffffffffffffefff
  and	x3,x3,x4
  csrw    mhcr,x3
  
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 0x10
.endm


#RAS operation
#SET MHCR.RS = 1'b1
.macro RAS_EN
  csrsi	mhcr,0x10
.endm

#SET MHCR.RS = 1'b0
.macro RAS_DIS
  csrci	mhcr,0x10
.endm


#Ind-BTB operation
#SET MHCR.IBPE = 1'b1
.macro IND_BTB_EN
   #backup regs
  addi x2, x2, -8
  sd x3, 0x0(x2)
  
  #1
  csrr	x3, mhcr
  ori	x3, x3 ,0x80
  csrw    mhcr ,x3
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHCR.IBPE = 1'b0
.macro IND_BTB_DIS
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  
  #1
  csrr	x3,mhcr
  andi	x3, x3, 0xffffffffffffff7f
  csrw	mhcr,x3
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 16
.endm

#SET MCOR.IBP_INV = 1'b1
.macro IND_BTB_INV
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
   
  #1
  csrr	x3,mcor
  li	x4,0x40000
  or	x3,x3,x4
  csrw	mcor, x3
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm

#Prefetch operation
#SET MHINT.IPLD = 1'b1
.macro INST_PREFETCH_EN
   #backup regs
  addi x2, x2, -8
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  ori	x3, x3, 0x100
  csrw	mhint,x3
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHINT.IPLD = 1'b0
.macro INST_PREFETCH_DIS
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  andi	x3, x3, 0xfffffffffffffeff
  csrw	mhint,x3
  
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 16
.endm

#Loop Buffer operation
#SET MHINT.LPE = 1'b1
.macro LOOP_BUFFER_EN
   #backup regs
  addi x2, x2, -8
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  ori	x3, x3, 0x200
  csrw	mhint,x3
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHINT.LPE = 1'b0
.macro LOOP_BUFFER_DIS
   #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  andi	x3, x3, 0xfffffffffffffdff
  csrw	mhint,x3
  
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#way prediction operation
#SET MHINT.IWPE = 1'b1
.macro WAY_PREDICTION_EN
   #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  ori	x3, x3, 0x400
  csrw	mhint,x3
  
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MHINT.IWPE = 1'b0
.macro WAY_PREDICTION_DIS
   #backup regs
  addi x2, x2, 0xfffffffffffffff8
  sd x3, 0x0(x2)
   
  #1
  csrr	x3, mhint
  andi	x3, x3, 0xfffffffffffffbff
  csrw	mhint,x3
  
   #restore regs
  ld x3, 0x0(x2)
  addi x2, x2, 0x8
.endm

#SET MCOR.CACHESEL = 2'b11 & MCOR.INV = 1'b1
.macro ID_CACHE_IV_ALL
  csrsi	mcor, 0x3
  csrsi	mcor, 0x10
.endm

#SET ????
.macro JAL_IMM_SHIFT 
   #backup regs
  addi x2, x2, -24
  sd x3, 0(x2)
  sd x4, 8(x2)
  sd x5, 16(x2)
  sd x6, 24(x2)
  
  li	x6, 0x0
  
  #src x31
  #use x31 to transfer data
  #10:1 to 30:21
  li	x3, 0x7fe
  and	x4, x3, x31
  slli	x5, x4, 20	
  or	x6, x5, x6 # x6 = {x31[10:1],21'b0}
  
  #20 to 31
  li	x3, 0x10000
  and	x4, x3, x31
  slli	x5, x4, 11 #x5 = {x31[16],11'b0}	
  or	x6, x5, x6 # x6 = {x31[10:1],8'b0,x31[16],11'b0}
  
  #11 to 20
  li	x3, 0x800
  and	x4, x3, x31
  slli	x5, x4, 9	#x5 = {x31[11],9'b0}
  or	x6, x5, x6  #x6 = {x31[10:1], 8'b0, x31[16], 1'b0, x31[11],9'b0}
  
  #19: 12 
  li	x3, 0xff000  
  and	x4, x3, x31  
  #slli	x5, x4, 9	
  or	x6, x5, x6
  
  mv	x31, x6
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 8(x2)
  ld x5, 16(x2)
  ld x6, 24(x2)
  addi x2, x2, 24

.endm






#X31 BIT SHIFT X31[10:5] --> X31[30:25] X31[12]-->X31[31] X31[11] --> X31[7]
# X31[4:1] --> X31[11:8]
.macro CONDB_IMM_SHIFT 
   #backup regs
  addi x2, x2, -24
  sd x3, 0(x2)
  sd x4, 8(x2)
  sd x5, 16(x2)
  sd x6, 24(x2)
  
  li	x6, 0x0
  
  #src x31
  #use x31 to transfer data
  #10:5 to 30:25
  li	x3, 0x7e0
  and	x4, x3, x31
  slli	x5, x4, 20	#x5 = {x31[10:5],25'b0}
  or	x6, x5, x6
  
  #12 to 31
  li	x3, 0x1000
  and	x4, x3, x31
  slli	x5, x4, 19	
  or	x6, x5, x6
  
  #11 to 7
  li	x3, 0x800
  and	x4, x3, x31
  srli	x5, x4, 4	
  or	x6, x5, x6
  
  #4:1 to 11:8 
  li	x3, 0x1f
  and	x4, x3, x31
  slli	x5, x4, 7	
  or	x6, x5, x6
  
  mv	x31, x6
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 8(x2)
  ld x5, 16(x2)
  ld x6, 24(x2)
  addi x2, x2, 24
  
.endm

#SET MSTATUS.MPP[1] = 1'b0
.macro RET_TO_LOW
  addi	x2,x2,-8
  sd	x3, 0(x2)
  
  #clr 12th bit
  li	x3,0x1000
  csrc	mstatus,x3
  
  ld	x3, 0x0(x2)
  addi	x2,x2,0x8
     
  mret
.endm


#spec faill prediction operation

#SET MHINT.NO_SPEC = 1'b1
.macro SPEC_PRED_EN
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
   
  #1
  csrr	x3, mhint
  li	x4,0x40000
  or	x3, x3, x4
  csrw	mhint,x3
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm


#spec faill prediction operation

#SET MHINT.NO_SPEC = 1'b0
.macro SPEC_PRED_DIS
   #backup regs
  addi x2, x2, -16
  sd x3, 0x0(x2)
  sd x4, 0x8(x2)
   
  #1
  csrr	x3, mhint
  li	x4, 0xfffffffffffbffff
  and	x3, x3, x4
  csrw	mhint,x3
  
   #restore regs
  ld x3, 0x0(x2)
  ld x4, 0x8(x2)
  addi x2, x2, 16
.endm


#SET MHINT.ECC = IMM
.macro MHINT_ECC IMM
 #backup regs
  addi x2, x2, -16
  sd x9,  0x0(x2)
  sd x10, 0x8(x2)

  #write mhint ecc en
  li    x9,0x80000
  csrc  mhint,x9
  csrr  x9,mhint
  li    x10, \IMM
  slli  x10,x10,19
  or    x9,x9,x10
  csrw  mhint,x9

  ld x9, 0x0(x2)
  ld x10, 0x8(x2)
  addi x2, x2, 16
.endm

