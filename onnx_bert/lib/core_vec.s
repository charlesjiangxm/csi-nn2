################################################################################################
# This file includes some macros which will be used to process vector.                         #
#                                 Included Macro                                               #
#  1.  INIT_VREG_REG        SET VREG = {REGH, REGL}                                            #
#  2.  VREG_IMM             SET VREG = {HIMM64, LIMM64}                                        #
#  3.  VREG_CMP             check if VREG1 == VREG2                                            #
################################################################################################



#SET VREG = {REGH, REGL}
.macro INIT_VREG_REG VREG, REGH, REGL
#backup regs 
addi x2, x2, -24
sd x15, 0x0(x2)
sd x16, 0x8(x2)
sd x17, 0x10(x2)

#backup vtype vl vstart
csrr	x15,vtype
csrr	x16,vl
csrr	x17,vstart

addi	x2, x2, -24
sd	x15,0x0(x2)
sd	x16,0x8(x2)
sd	x17,0x10(x2)

#modify vtype vl to lmul 1 sew 64b and keep vl
#reset vstart to 0
#li	x16,0x1
vsetvli	x0,x0,e64,m1

#recover initial reg val
ld	x15,24(x2)
ld	x16,32(x2)
ld	x17,40(x2)

#updt low 64 bit 
vslide1down.vx	\VREG,\VREG,\REGL
#updt high 64 bit 
vslide1down.vx	\VREG,\VREG,\REGH

#restore vtype vl vstart
#vtype
ld	x15,0x0(x2)
#vl
ld	x16,0x8(x2)
#start
ld	x17,0x10(x2)
addi	x2, x2, 24

vsetvl	x0,x16,x15
csrw	vstart,x17

#restore regs
ld x15, 0x0(x2)
ld x16, 0x8(x2)
ld x17, 0x10(x2)
addi x2, x2, 24
.endm

#set VERG = {HIMM64, LIMM64}
.macro VREG_IMM VREG, HIMM64, LIMM64
#sew = 64
#updt high 64 bit
vsetvli x0,x0,e64
li		x15, \LIMM64
vslide1down.vx	\VREG,\VREG,x15
#updt low 64 bit 
li		x15, \HIMM64
vslide1down.vx	\VREG,\VREG,x15
#sew = 32
vsetvli x0,x0,e32
.endm



.macro VREG_CMP VREG1, VREG2
# set i-th LSB in v4 = VERG1[i] != VREG2[i] for i = vstart : vl
vmsne.vv v4, \VREG1, \VREG2
# count the number of value 1 and write to x5
vmpopc.m  x5, v4
bnez x5, TEST_FAIL
.endm





