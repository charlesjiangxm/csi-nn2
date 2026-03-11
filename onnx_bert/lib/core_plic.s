##########################################################################
#                Included Macro                                          #
#  1.  TUNR_OFF_CONTROL SET PLIC_CTRL 0                                  #
#  2.  TURN_ON_CONTROL        Set mmode exp's handler entry address      #
#  3.  SET_M_INT        SET INTID's Prio then enable INTID's IP & MIE    #
#  4.  SET_S_INT        SET INTID's Prio then enable INTID's IP & SIE    #
#  5.  CLR_M_INT        SET INTID's PRIO = 0 then clr INTID's IP&MIE bit #
#  6.  CLR_S_INT        SET INTID's PRIO = 0 then clr INTID's IP&SIE bit #
#  7.  SET_M_INT_EN     SET INTID's MIE bit as 1'b1                      #
##########################################################################


#plic memory
#.set PLICBASE_M    ,0x4000000000
##.set PLICBASE_S    ,0xffffffc000000000
#.set INTPRIO       ,0x0
#.set INTPEND       ,0x1000
#.set INTIE         ,0x2000
#.set INTIE_HART    ,0x80
#
#.set INT_S_PERM    ,0x1ffffc
#.set INTTH	   ,0x200000
#.set INTCLAIM      ,0x200004
#.set INTHC_HART    ,0x1000
#
#.set CORENUM       ,0x1
#.set INTNUM        ,128



####################################################################
#SET PLIC_CTRL 0
.macro TURN_OFF_CONTROL
  #backup regs
addi x2, x2, -24
sd x15, 0x0(x2)
sd x16, 0x8(x2)
sd x17, 0x10(x2)

li	x15,PLICBASE_M
li	x16,INT_S_PERM
add	x16,x15,x16  #locate to PLIC_CTRL register
li	x17,0x0
sw	x17,0x0(x16)

  #restore regs
ld x15, 0x0(x2)
ld x16, 0x8(x2)
ld x17, 0x10(x2)
addi x2, x2, 24
.endm
####################################################################



####################################################################
#SET PLIC_CTRL 1
.macro TURN_ON_CONTROL
  #backup regs
addi x2, x2, -24
sd x15, 0x0(x2)
sd x16, 0x8(x2)
sd x17, 0x10(x2)

li	x15,PLICBASE_M
li	x16,INT_S_PERM
add	x16,x15,x16  #locate to PLIC_CTRL register
li	x17,0x1
sw	x17,0x0(x16)

  #restore regs
ld x15, 0x0(x2)
ld x16, 0x8(x2)
ld x17, 0x10(x2)
addi x2, x2, 24
.endm
####################################################################



####################################################################
#SET INTID's Prio then enable INTID's IP & MIE
.macro SET_M_INT INTID,PRIO
#backup regs 
addi	x2, x2, -72
sd	x9, 0(x2)
sd	x10, 8(x2)
sd	x11, 16(x2)
sd	x12, 24(x2)
sd	x13, 32(x2)
sd	x14, 40(x2)
sd	x15, 48(x2)
sd	x16, 56(x2)
sd	x17, 64(x2)

#disable all int when set
csrr	x17,mstatus
csrw	mstatus,x0

#9  ID
#10 PRIO
#11 final addr

li	x9,\INTID
li	x10,\PRIO
li	x16,0x20

#set prio
slli	x14, x9,0x2
li	x15, PLICBASE_M
add	x11, x15,x14 #PLIC_PRIO = PLICBASE_M + INTID*4
sw	x10, 0x0(x11)# SET PRIO IN PLIC_PRIO		

#set ip
#ip addr
div	x12,x9,x16  #PLIC_IPx (x=N/32)
slli	x12,x12,0x2  

li	x13,PLICBASE_M
li	x14,INTPEND
add	x11,x12,x13
add	x11,x11,x14   #PLIC_IPx addr = PLICBASE_M + INTPEND + x*4

# ip bit 
remu	x12,x9,x16  #y = N mod 32
li	x13,0x1
sll	x13,x13,x12   # 0x1 << y
lw	x15,0x0(x11)  #Load PLIC_IPx value
or	x13,x13,x15   
sw	x13,0x0(x11)  #Set PLIC_IPx y bit as 1		    

#set ie
#ie addr
div	x12,x9,x16
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTIE
add	x11,x12,x13
add	x11,x11,x14  #X11 = PLIC_MIEx addr

# ie bit 
remu	x12,x9,x16
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
or	x13,x13,x15
sw	x13,0x0(x11)	#Set PLIC_MIEx y bit as 1

csrw	mstatus,x17  #recover mstatus

#restore regs
ld	x9, 0(x2)
ld	x10, 8(x2)
ld	x11, 16(x2)
ld	x12, 24(x2)
ld	x13, 32(x2)
ld	x14, 40(x2)
ld	x15, 48(x2)
ld	x16, 56(x2)
ld	x17, 64(x2)
addi	x2, x2, 72
.endm
####################################################################



###################################################################
#SET INTID's Prio then enable INTID's IP & SIE 
.macro SET_S_INT INTID,PRIO
#backup regs 
addi	x2, x2, -72
sd	x9, 0(x2)
sd	x10, 8(x2)
sd	x11, 16(x2)
sd	x12, 24(x2)
sd	x13, 32(x2)
sd	x14, 40(x2)
sd	x15, 48(x2)
sd	x16, 56(x2)
sd	x17, 64(x2)
#disable all int when set

csrr	x17,mstatus
csrw	mstatus,x0

#9  ID
#10 PRIO
#11 final addr

li	x9,\INTID
li	x10,\PRIO
li	x16,0x20

#set prio
slli	x14, x9,0x2
li	x15, PLICBASE_M
add	x11, x15,x14 #PLIC_PRIO = PLICBASE_M + INTID*4
sw	x10, 0x0(x11)# SET PRIO IN PLIC_PRIO		

#set ip
#ip addr
div	x12,x9,x16  #PLIC_IPx (x=N/32)
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTPEND
add	x11,x12,x13
add	x11,x11,x14  #PLIC_IPx addr = PLICBASE_M + INTPEND + x*4

# ip bit 
remu	x12,x9,x16  #y = N mod 32
li	x13,0x1   # 0x1 << y
sll	x13,x13,x12  
lw	x15,0x0(x11)  #Load PLIC_IPx value
or	x13,x13,x15
sw	x13,0x0(x11)  #Set PLIC_IPx y bit as 1	    

#set ie
#ie addr
div	x12,x9,x16
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTIE
add	x11,x12,x13
add	x11,x11,x14

li	x13,INTIE_HART
add	x11,x11,x13  #PLIC_SIEx = PLICBASE_M + INTIE + INTIE_HART

# ie bit 
remu	x12,x9,x16
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
or	x13,x13,x15
sw	x13,0x0(x11)	#Set PLIC_SIEx y bit as 1

csrw	mstatus,x17

#restore regs
ld	x9, 0(x2)
ld	x10, 8(x2)
ld	x11, 16(x2)
ld	x12, 24(x2)
ld	x13, 32(x2)
ld	x14, 40(x2)
ld	x15, 48(x2)
ld	x16, 56(x2)
ld	x17, 64(x2)
addi	x2, x2, 72
.endm
######################################################################



######################################################################
#SET INTID's PRIO = 0 then clr INTID's IP&MIE bit
.macro CLR_M_INT INTID
#backup regs 
addi	x2, x2, -72
sd	x9, 0(x2)
sd	x10, 8(x2)
sd	x11, 16(x2)
sd	x12, 24(x2)
sd	x13, 32(x2)
sd	x14, 40(x2)
sd	x15, 48(x2)
sd	x16, 56(x2)
sd	x17, 64(x2)

#disable all int when set
csrr	x17,mstatus
csrw	mstatus,x0

#9  ID
#11 final addr

li	x9,\INTID
li	x16,0x20

#clr prio
slli	x14, x9,0x2
li	x15, PLICBASE_M
add	x11, x15,x14  #PLIC_PRIO address
sw	x0, 0x0(x11) #set prio_value = 0		

#clr ip
#ip addr
div	x12,x9,x16   # x = N/32
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTPEND
add	x11,x12,x13
add	x11,x11,x14  #PLIC_IPx = PLICBASE_M + INTPEND + x*4

# ip bit 
remu	x12,x9,x16 # y = mod(N/32)
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
not	x13,x13
and	x13,x13,x15
sw	x13,0x0(x11)  #clr INTID's IP

#set ie
#ie addr
div	x12,x9,x16
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTIE
add	x11,x12,x13
add	x11,x11,x14 #PLIC_MIE = PLICBASE_M + INTIE + x*4

# ie bit 
remu	x12,x9,x16
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
not	x13,x13
and	x13,x13,x15
sw	x13,0x0(x11) #clr INTID's MIE

csrw	mstatus,x17

#restore regs
ld	x9, 0(x2)
ld	x10, 8(x2)
ld	x11, 16(x2)
ld	x12, 24(x2)
ld	x13, 32(x2)
ld	x14, 40(x2)
ld	x15, 48(x2)
ld	x16, 56(x2)
ld	x17, 64(x2)
addi	x2, x2, 72
.endm
##################################################################



##################################################################
#SET INTID's PRIO = 0 then clr INTID's IP&SIE bit
.macro CLR_S_INT INTID
#backup regs 
addi	x2, x2, -72
sd	x9, 0(x2)
sd	x10, 8(x2)
sd	x11, 16(x2)
sd	x12, 24(x2)
sd	x13, 32(x2)
sd	x14, 40(x2)
sd	x15, 48(x2)
sd	x16, 56(x2)
sd	x17, 64(x2)
#disable all int when set

csrr	x17,mstatus
csrw	mstatus,x0

#9  ID
#10 PRIO
#11 final addr

li	x9,\INTID
#li	x10,\PRIO
li	x16,0x20

#clr prio
slli	x14, x9,0x2
li	x15, PLICBASE_M
add	x11, x15,x14   #x11 = PLIC_PRIO addr
sw	x0, 0x0(x11)		

#clr ip
#ip addr
div	x12,x9,x16  #x = INTID/32
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTPEND
add	x11,x12,x13
add	x11,x11,x14 #PLIC_IPx = PLICBASE_M + INTPEND + x*4

# ip bit 
remu	x12,x9,x16 #y = N mod 32
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
not	x13,x13
and	x13,x13,x15
sw	x13,0x0(x11)		    

#set ie
#ie addr
div	x12,x9,x16
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTIE
add	x11,x12,x13
add	x11,x11,x14  

li	x13,INTIE_HART
add	x11,x11,x13   #PLIC_SIE addr

# ie bit 
remu	x12,x9,x16
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
not	x13,x13
and	x13,x13,x15
sw	x13,0x0(x11)	#clr SIE bit

csrw	mstatus,x17

#restore regs
ld	x9, 0(x2)
ld	x10, 8(x2)
ld	x11, 16(x2)
ld	x12, 24(x2)
ld	x13, 32(x2)
ld	x14, 40(x2)
ld	x15, 48(x2)
ld	x16, 56(x2)
ld	x17, 64(x2)
addi	x2, x2, 72
.endm
#################################################################



################################################################
#SET INTID's MIE bit as 1'b1 
.macro SET_M_INT_EN INTID,PRIO
#backup regs 
addi	x2, x2, -72
sd	x9, 0(x2)
sd	x10, 8(x2)
sd	x11, 16(x2)
sd	x12, 24(x2)
sd	x13, 32(x2)
sd	x14, 40(x2)
sd	x15, 48(x2)
sd	x16, 56(x2)
sd	x17, 64(x2)

#disable all int when set
csrr	x17,mstatus
csrw	mstatus,x0

#9  ID
#10 PRIO
#11 final addr

li	x9,\INTID
li	x10,\PRIO
li	x16,0x20

#set prio
slli	x14, x9,0x2
li	x15, PLICBASE_M
add	x11, x15,x14
sw	x10, 0x0(x11)		

#set ip
#ip addr
#div	x12,x9,x16
#slli	x12,x12,0x2
#
#li	x13,PLICBASE_M
#li	x14,INTPEND
#add	x11,x12,x13
#add	x11,x11,x14
#
## ip bit 
#remu	x12,x9,x16
#li	x13,0x1
#sll	x13,x13,x12
#lw	x15,0x0(x11)
#or	x13,x13,x15
#sw	x13,0x0(x11)		    

#set ie
#ie addr
div	x12,x9,x16
slli	x12,x12,0x2

li	x13,PLICBASE_M
li	x14,INTIE
add	x11,x12,x13
add	x11,x11,x14

# ie bit 
remu	x12,x9,x16
li	x13,0x1
sll	x13,x13,x12
lw	x15,0x0(x11)
or	x13,x13,x15
sw	x13,0x0(x11)	

csrw	mstatus,x17

#restore regs
ld	x9, 0(x2)
ld	x10, 8(x2)
ld	x11, 16(x2)
ld	x12, 24(x2)
ld	x13, 32(x2)
ld	x14, 40(x2)
ld	x15, 48(x2)
ld	x16, 56(x2)
ld	x17, 64(x2)
addi	x2, x2, 72
.endm
#################################################################
