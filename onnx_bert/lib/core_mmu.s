######################################################################################
#                              Included Macro                                        #
#  1. MENVCFG_PBMTE                  SET MENVCFG.PBMTE = IMM                         #
#  2. MMU_EN                         ENABLE SV39                                     #
#  3. MMU_EN_SV_32                   ENABLE XTSV32                                   #
#  4. MMU_EN_SV_39                   ENABLE SV39 & SvPBMT                            #
#  5. MMU_EN_SV_48                   ENABLE SV48 & SvPBMT                            #
#  6. MMU_DIS                        SET SATP.MODE = 0                               #
#  7. MMU_MODE_SWITCH                NOT USE                                         #
#  8. SWITCH_TO_SV48                 NOT USE                                         #
#  9. SWITCH_TO_SV39                 NOT USE                                         #
#  10.SV32_MMU_PTW_4K                CONFIG A 4KB PAGE IN SV32                       #
#  11.MMU_PTW_4K                     CONFIG A 4KB PAGE IN SV39/SV48                  #
#  12.SV32_MMU_PTW_4M                CONFIG A 4MB PAGE IN SV32                       #
#  13.MMU_PTW_4M                     CONFIG A 2MB PAGE IN SV39/SV48                  #
#  14.MMU_PTW_1G                     CONFIG A 1GB PAGE IN SV39/SV48                  #
#  15.MMU_PTW_512G                   CONFIG A 512GB PAGE IN SV48                     #
#  16.L2C_TAG_SETUP                  SET MCCR2.ECCEN = 1'b0                          #
#  17.L2C_TAG_LTNCY                  SET MCCR2.TLTNCY = TAG_LTNCY_REG                #
#  18.L2C_DATA_SETUP                 SET MCCR2.DSETUP = DATA_SETUP_REG               #
#  19.L2C_DATA_LTNCY                 SET MCCR2.DLTNCY = DATA_LTNCY_REG               #
######################################################################################

.macro MMU_EN
  #backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #write MODE=8 to SATP
  csrr  x9,satp
  li    x10,0xfffffffffffffff
  and   x9,x9,x10
  li    x10,8
  slli  x10,x10,60
  or    x9,x9,x10
  csrw	satp, x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9, 0(x2)
  addi	x2, x2, 16

  MENVCFG_PBMTE 1
.endm

.macro MMU_EN_SV_32
  #write MODE=F to SATP
  li    x10,0x8000000000000000
  csrs  mxstatus,x10 
  li    x10,0xf000000000000000
  csrc	satp, x10
  li    x10,0xf000000000000000
  csrs	satp, x10
.endm

.macro MMU_EN_SV_39
  #backup regs
#  addi	x2, x2, -16
#  sd	x9, 0(x2)
#  sd	x10, 8(x2)

  #write MODE=8 to SATP
  li    x10,0xf000000000000000
  csrc	satp, x10
  li    x10,0x8000000000000000
  csrs	satp, x10
   

  MENVCFG_PBMTE 1
  #restore regs
#  ld	x10, 8(x2)
#  ld	x9, 0(x2)
#  addi	x2, x2, 16
.endm

.macro MMU_EN_SV_48
  #backup regs
#  addi	x2, x2, -16
#  sd	x9, 0(x2)
#  sd	x10, 8(x2)

  #write MODE=9 to SATP
  li    x10,0xf000000000000000
  csrc	satp, x10
  li    x10,0x9000000000000000
  csrs	satp, x10

  MENVCFG_PBMTE 1
  #restore regs
#  ld	x10, 8(x2)
#  ld	x9, 0(x2)
#  addi	x2, x2, 16
.endm



.macro MMU_DIS
  #backup regs
  addi	x2, x2, -16
  sd	x9, 0(x2)
  sd	x10, 8(x2)

  #write MODE=0 to SATP
  csrr  x9,satp
  li    x10,0xfffffffffffffff
  and   x9,x9,x10
  csrw	satp, x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9, 0(x2)
  addi	x2, x2, 16
.endm

.macro MMU_MODE_SWITCH MMU_MODE 
   addi	x2, x2, -24
   sd	x9, 0(x2)
   sd	x10, 8(x2)
   sd	x11, 16(x2)
 
  li x9, \MMU_MODE
  li x10,0x8
  beq x9, x10, 1f  #jump to switch to SV39
 

  li x10, 0x9 
  beq x9, x10, 2f  #jump to switch to SV48
  
  j 3f  #if current mode is not supported, then exit 

#set sv39
1:
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10
  li    x10, 0x100000   #sv39 ppn 
  li    x11, 0x8000000000000000 #sv39 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  j 3f 
 
#set sv48
2:
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10
  li    x10, 0x100000   #sv39 ppn 
  li    x11, 0x8000000000000000 #sv39 mode
  li    x10, 0x6000000   #sv48 ppn 
  li    x11, 0x9000000000000000 #sv48 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  j 3f
  
3:
  sfence.vma 
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm


.macro SWITCH_TO_SV48
  addi	x2, x2, -24
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)

#set sv48
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10
  li    x10, 0x6000000   #sv48 ppn 
  li    x11, 0x9000000000000000 #sv48 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  
  sfence.vma 
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm


.macro SWITCH_TO_SV39
  addi	x2, x2, -24
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)

#set sv39
  csrr  x9,  satp
  li	x10, 0x0ffff00000000000
  and   x9,x9,x10
  li    x10, 0x100000   #sv39 ppn 
  li    x11, 0x8000000000000000 #sv39 mode
  or    x10, x10,x11
  or    x9, x10,x9
  csrw	satp,x9
  
  sfence.vma 
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  addi	x2, x2, 24
  # fence 
.endm

.macro SV32_MMU_PTW_4K VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0x3fffff
  and   x9, x9, x10
  
  # get VPN1 in x10
  li    x10, \VPN
  li    x11, 0xffc00
  and   x10,x10,x11
  srli  x10, x10, 10    
   
  # cfig first-level page 
  # ptsize=4 so 2bit align
  # level-1 page, entry addr:{ppn,VPN1，2'b0} in x15
  # level-2 pte.ppn in x12
  slli  x14, x9, 12
  slli  x11, x10, 2  
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
 
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3ff
  and   x16, x11, x13
  # level-2 page, entry addr:{pte.ppn,VPN1,2'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 2
  add   x17, x17, x13
  # write pte into level-2 page
  li    x11, \PPN
  #get svpbmt but not used for sv32
  li    x12, \SVPBMT  
  li    x13, \FLAG
  slli  x11, x11, 10
  or    x11, x11, x13
  sd    x11, 0(x17)

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
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm

.macro MMU_PTW_4K VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f  #jump to SV48 PTW 4K 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn2,vpn1}
  li    x11, 0x7ffffff
  li    x10, \VPN
  and   x10, x11,x10
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 9
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0x01
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN0 in x12
  li    x11, \VPN
  li    x12, 0x1ff
  and   x12, x12, x11
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  # write pte into level-3 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f 

 
 
1:
  #SV48 MMU PTW 4K BEG
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10

  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11   #first page entry address
  # write pte into level-1 page
  # level-1 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9    # level2 ppn 
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13            #second page entry address
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}

  li    x10, \VPN
  li    x11, 0xfffffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10    #level 3 ppn
  slli  x19, x18, 10 
  li    x13, 0x01
  or    x19, x19, x13
  sd    x19, 0(x17)
  

  # cfig level-3 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-3 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x18, 12
  slli  x17, x16, 3
  add   x17, x17, x13  #third page entry address

  # write pte into level-3 page
  # level-4 base addr in x18: PPN+1+2^9 + 2^9 *2^9 +{vpn3,vpn2,vpn1}
  li    x11, 0x200
  li    x12, 0x40000
  add   x11,x12,x11
  addi  x11, x11,0x1
  add   x11, x11,x9
  li    x12, \VPN
  li    x13, 0xfffffffff
  and   x12, x13,x12
  srli  x12, x12, 9
  add   x12, x12, x11  #level 4 ppn
  slli  x16, x12,10
  li    x13, 0x01
  or    x13, x16,x13
  sd    x13, 0(x17)
  

  # get level-4 page addr x17
  li    x11, \VPN
  li    x13, 0x1ff
  and   x16, x11, x13
  slli  x15, x12, 12
  slli  x17, x16, 3
  add   x17,x17,x15

#write ppn and flag  
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)
   

2:
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
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm

.macro SV32_MMU_PTW_4M VPN, PPN, FLAG, SVPBMT
#for sv32， it is actually to be 4M
# just unify the macro name to as legacy sv39/48 
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  

  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0x3fffff
  and   x9, x9, x10
  
  # get VPN1 in x10
  li    x10, \VPN
  li    x11, 0xffc00
  and   x10,x10,x11
  srli  x10, x10, 10    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,2'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 2
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  li    x11, \PPN
  #get svpbmt but not used for sv32
  li    x12, \SVPBMT
  li    x13, \FLAG
  slli  x11, x11, 10
  or    x11, x11, x13
  sd    x11, 0(x15)

  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm

.macro MMU_PTW_2M VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  

  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f   #jump to SV48 PTW 2M 

   
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x3fe00
  and   x16, x11, x13
  srli  x16, x16, 9  
  # level-2 page, entry addr:{pte.ppn,VPN1,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)
  j 2f #to restore gpr
 

  #SV48 PTW 2M BEG
1:
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN2 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18  
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  # level-3 base addr in x18: PPN+1+2^9+{vpn3,vpn2}
  li    x10, \VPN
  li    x11, 0x7ffffff
  and   x10, x10,x11
  li    x11, 0x200
  addi  x11, x11, 1
  add   x11, x11, x9  
  srli  x10, x10, 18
  add   x18, x11, x10
  slli  x19, x18, 10 
  li    x13, 0x01
  or    x19, x19, x13
  sd    x19, 0(x17)
  
  # cfig level-3 page
  # get VPN1 in x12
  li    x11, \VPN
  li    x12, 0x3fe00
  and   x12, x12, x11
  srli  x12, x12, 9
  # get level-3 page addr x17
  slli  x18, x18, 12
  slli  x12, x12, 3
  add   x17, x18, x12
  # write pte into level-3 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)

  #restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
#endif  
.endm



.macro MMU_PTW_1G VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -88
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  sd	x16, 56(x2)
  sd	x17, 64(x2)
  sd	x18, 72(x2)
  sd	x19, 80(x2)
  
  #figure out sv 48 or sv39, default SV39
  csrr x9, satp
  li x10,0x1000000000000000
  and x9,x9,x10
  bnez x9, 1f   #jump to SV48 PTW 1G 
 
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
  j 2f #jump to restore

   
  # get PPN from satp in x9
1:
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  # level-2 base addr in x12
  addi  x12, x10, 1
  add   x12, x12, x9
  slli  x14, x12, 10
  li    x13, 0x01
  or    x13, x13, x14
  sd    x13, 0(x15)
  
  # cfig level-2 page
  # get VPN1 in x16
  li    x11, \VPN
  li    x13, 0x7fc0000
  and   x16, x11, x13
  srli  x16, x16, 18
  # level-2 page, entry addr:{pte.ppn,VPN2,3'b0} in x17
  slli  x13, x12, 12
  slli  x17, x16, 3
  add   x17, x17, x13
  # write pte into level-2 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x17)

  #restore regs
2:
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  ld	x16, 56(x2)
  ld	x17, 64(x2)
  ld	x18, 72(x2)
  ld	x19, 80(x2)
  addi	x2, x2, 88
  # fence 
  fence
.endm

.macro MMU_PTW_512G VPN, PPN, FLAG, SVPBMT
  #backup regs 
  addi	x2, x2, -56
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
  
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN3 in x10
  li    x10, \VPN
  li    x11, 0xff8000000
  and   x10,x10,x11
  srli  x10, x10, 27    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN3,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  li    x11, \PPN
  li    x12, \SVPBMT
  andi  x12, x12, 0x3
  li    x13, \FLAG
  slli  x11, x11, 10
  slli  x12, x12, 61
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
  
  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  addi	x2, x2, 56
  # fence 
  fence
.endm



.macro MMU_SATP_PPN PPN
  #backup regs
  addi	x2, x2, -16
  sd	x9,  0(x2)
  sd	x10, 8(x2)

  #write PPN
  csrr  x9, satp
  li	x10, 0xfffff00000000000
  and   x9,x9,x10
  li    x10, \PPN
  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9,  0(x2)
  addi	x2, x2, 16
.endm


.macro MMU_SATP_PPN_r PPN
  #backup regs
  addi	x2, x2, -16
  sd	x9,  0(x2)
  sd	x10, 8(x2)

  #write PPN
  csrr  x9, satp
  li	x10, 0xfffff00000000000
  and   x9,x9,x10
  mv    x10, \PPN
  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9,  0(x2)
  addi	x2, x2, 16
.endm

.macro MMU_SATP_PPN_SV32 PPN
  #backup regs
  addi	x2, x2, -16
  sd	x9,  0(x2)
  sd	x10, 8(x2)

  #write PPN
  csrr  x9, satp
  li	x10, 0xfffff00000000000
  and   x9,x9,x10
  li    x10, \PPN
  or    x9,x9,x10
  li    x10, \PPN
  slli  x10,x10,22
  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  ld	x10, 8(x2)
  ld	x9,  0(x2)
  addi	x2, x2, 16
.endm

.macro MMU_SATP_ASID ASID
  #backup regs
 # addi	x2, x2, -16
 # sd	x9,  0(x2)
 # sd	x10, 8(x2)

  #write ASID
  csrr  x9, satp
  li	x10, 0xf0000fffffffffff
  and   x9,x9,x10
  li    x10, \ASID
  slli  x10,x10,44

  or    x9,x9,x10
  csrw	satp,x9

  #restore regs
  #ld	x10, 8(x2)
  #ld	x9,  0(x2)
  #addi	x2, x2, 16
.endm

.macro MMU_SATP_ASID_REG ASID_REG TMP_REG
  #backup regs
  addi	x2, x2, -16
  sd	\ASID_REG,  0(x2)
  sd	\TMP_REG, 8(x2)

  #write ASID
  csrr  \TMP_REG, satp
  li	\ASID_REG, 0xf0000fffffffffff
  and   \TMP_REG,\TMP_REG,\ASID_REG
  ld   \ASID_REG,0(x2)
  slli  \ASID_REG,\ASID_REG,44

  or    \ASID_REG,\ASID_REG,\TMP_REG
  csrw	satp,\ASID_REG

  #restore regs
  ld	\TMP_REG, 8(x2)
  ld	\ASID_REG,  0(x2)
  addi	x2, x2, 16
.endm




.macro RECOVER_MMU
  #flush tlb
  sfence.vma x0,x0

  #backup regs 
  addi	x2, x2, -56
  sd	x9, 0(x2)
  sd	x10, 8(x2)
  sd	x11, 16(x2)
  sd	x12, 24(x2)
  sd	x13, 32(x2)
  sd	x14, 40(x2)
  sd	x15, 48(x2)
   
  # get PPN from satp in x9
  csrr  x9, satp
  li    x10, 0xfffffffffff
  and   x9, x9, x10
  
  # get VPN2 in x10
  li    x10, 0
  li    x11, 0x7fc0000
  and   x10,x10,x11
  srli  x10, x10, 18    
   
  # cfig first-level page
  # level-1 page, entry addr:{ppn,VPN2,3'b0} in x15
  slli  x14, x9, 12
  slli  x11, x10, 3
  add   x15, x14, x11
  # write pte into level-1 page
  li    x11, 0
  li    x12, 0xf
  li    x13, 0xff
  slli  x11, x11, 10
  slli  x12, x12, 59
  or    x11, x11, x12
  or    x11, x11, x13
  sd    x11, 0(x15)
  
  li    x9,0x40000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, 1
  slli  x10,x10,18
  or    x9,x9,x10
  csrw  mstatus,x9

  #restore regs
  ld	x9, 0(x2)
  ld	x10, 8(x2)
  ld	x11, 16(x2)
  ld	x12, 24(x2)
  ld	x13, 32(x2)
  ld	x14, 40(x2)
  ld	x15, 48(x2)
  addi	x2, x2, 56
.endm

.macro MSTATUS_MPRV IMM
  #write mprv
#  addi  x2, x2, -16
#  sd    x9, 0(x2)
#  sd    x10, 8(x2)

  li    x9,0x20000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,17
  or    x9,x9,x10
  csrw  mstatus,x9
#  ld   x9,0(x2)
#  ld   x10,8(x2)
#  addi x2,x2,16
.endm

.macro MSTATUS_SUM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write sum
  li    x9,0x40000
  csrc  mstatus,x9
 #csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,18
 # or    x9,x9,x10
  csrs  mstatus,x10
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MSTATUS_MXR IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write mxr
  li    x9,0x80000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,19
  or    x9,x9,x10
  csrw  mstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MSTATUS_TVM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write tvm
  li    x9,0x100000
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,20
  or    x9,x9,x10
  csrw  mstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MSTATUS_MPP IMM
#  addi  x2, x2, -16
#  sd    x9, 0(x2)
#  sd    x10, 8(x2)
  #write mpp
  li    x9,0x1800
  csrc  mstatus,x9
  csrr  x9,mstatus
  li    x10, \IMM
  slli  x10,x10,11
  or    x9,x9,x10
  csrw  mstatus,x9
#  ld   x9,0(x2)
#  ld   x10,8(x2)
#  addi x2,x2,16
.endm

.macro MXSTATUS_MAEE IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write maee
  li    x9,0x200000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,21
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MXSTATUS_MHRD IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write mhrd
  li    x9,0x40000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,18
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MXSTATUS_CSKYISAEE IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write cskyisaee
  li    x9,0x400000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,22
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MXSTATUS_MM IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write misalign enable
  li    x9,0x8000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,15
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MXSTATUS_UCME IMM
  addi  x2, x2, -16
  sd    x9, 0(x2)
  sd    x10, 8(x2)
  #write ucme
  li    x9,0x10000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,16
  or    x9,x9,x10
  csrw  mxstatus,x9
  ld   x9,0(x2)
  ld   x10,8(x2)
  addi x2,x2,16
.endm

.macro MXSTATUS_INSDE IMM
  #write isnde
  li    x9,0x80000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,19
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm

.macro MXSTATUS_CLINTEE IMM
  #write CLINTaee
  li    x9,0x20000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,17
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm

.macro MXSTATUS_FCCEE IMM
  #write fccee
  li    x9,0x100000
  csrc  mxstatus,x9
  csrr  x9,mxstatus
  li    x10, \IMM
  slli  x10,x10,20
  or    x9,x9,x10
  csrw  mxstatus,x9
.endm

.macro FXCR_DQNaN IMM
  #write DQNaN
  li    x9,0x200000
  csrc  fxcr,x9
  csrr  x9,fxcr
  li    x10, \IMM
  slli  x10,x10,23
  or    x9,x9,x10
  csrw  fxcr,x9
.endm

.macro PMPCFG0_0 IMM
  #write pmpcfg0_0
  li    x9,0xff
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,0
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_1 IMM
  #write pmpcfg0_1
  li    x9,0xff00
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,8
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_2 IMM
  #write pmpcfg0_2
  li    x9,0xff0000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,16
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_3 IMM
  #write pmpcfg0_3
  li    x9,0xff000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,24
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_4 IMM
  #write pmpcfg0_4
  li    x9,0xff00000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,32
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_5 IMM
  #write pmpcfg0_5
  li    x9,0xff0000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,40
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_6 IMM
  #write pmpcfg0_6
  li    x9,0xff000000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,48
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro PMPCFG0_7 IMM
  #write pmpcfg0_7
  li    x9,0xff00000000000000
  csrc  pmpcfg0,x9
  csrr  x9,pmpcfg0
  li    x10, \IMM
  slli  x10,x10,56
  or    x9,x9,x10
  csrw  pmpcfg0,x9
  sfence.vma x0,x0
.endm

.macro MMU_MMODE_SMODE  SROUTINE
  #write mepc
  addi x2,x2,-16
  sd x1, 0(x2)
  sd x3, 8(x2)
  la x1,\SROUTINE
  csrw mepc,x1
  li x1,0x800
  csrrs x3,mstatus,x1
  li x1,0x1000
  csrrc x3,mstatus,x1
  ld x1, 0(x2)
  ld x3, 8(x2)
  addi x2,x2,16
  mret
.endm

.macro MMU_MMODE_SMODE_S  SROUTINE
  #write sepc
  la x1,\SROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrs x0,mstatus,x1
  sret
.endm

.macro MMU_SMODE_UMODE  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x3,sstatus,x1
  sret
.endm

.macro MMU_MMODE_UMODE  UROUTINE
  #write mepc
  la x1,\UROUTINE
  csrw mepc,x1
  li x1,0x1800
  csrrc x3,mstatus,x1
  mret
.endm

.macro MMU_MMODE_UMODE_S  UROUTINE
  #write sepc
  la x1,\UROUTINE
  csrw sepc,x1
  li x1,0x100
  csrrc x0,mstatus,x1
  sret
.endm

.macro MMU_RV32_DEFAULT_INIT
# initialize MMU, s mode instruction fetch cannot access u mode page
MMU_RV32_DEFAULT_INIT:
# VPN:0x0000_0000~0x3fff_ffff,
MMU_PTW_2M 0x0,0x0,0xcf,0x0
MMU_PTW_2M 0x200,0x200,0xcf,0x0
MMU_PTW_2M 0x400,0x400,0xcf,0x0
MMU_PTW_2M 0x600,0x600,0xcf,0x0
MMU_PTW_2M 0x800,0x800,0xcf,0x0
MMU_PTW_2M 0xa00,0xa00,0xcf,0x0
MMU_PTW_2M 0xc00,0xc00,0xcf,0x0
MMU_PTW_2M 0xe00,0xe00,0xcf,0x0
MMU_PTW_2M 0x1000,0x0,0xdf,0x0
MMU_PTW_2M 0x1200,0x200,0xdf,0x0
MMU_PTW_2M 0x1400,0x400,0xdf,0x0
MMU_PTW_2M 0x1600,0x600,0xdf,0x0
MMU_PTW_2M 0x1800,0x800,0xdf,0x0
MMU_PTW_2M 0x1a00,0xa00,0xdf,0x0
MMU_PTW_2M 0x1c00,0xc00,0xdf,0x0
MMU_PTW_2M 0x1e00,0xe00,0xdf,0x0

# lxf PA=0x3000 -> 0x2000.
MMU_PTW_2M 0x3000,0x2000,0xdf,0x0
MMU_PTW_2M 0x3200,0x2200,0xdf,0x0
MMU_PTW_2M 0x3400,0x2400,0xdf,0x0
MMU_PTW_2M 0x3600,0x2600,0xdf,0x0
MMU_PTW_2M 0x3800,0x2800,0xdf,0x0
MMU_PTW_2M 0x3a00,0x2a00,0xdf,0x0
MMU_PTW_2M 0x3c00,0x2c00,0xdf,0x0
MMU_PTW_2M 0x3e00,0x2e00,0xdf,0x0

# invalid all icache & TLB, lxf 20220810.
icache.ialls
sfence.vma x0, x0
#sfence.vmas x0, x0  # finally decide to do not support in C908, 20220811.

.endm

.macro MMU_RV32_DEFAULT_INIT_SV32
# VPN:0x0000_0000~0x3fff_ffff,
SV32_MMU_PTW_4M 0x0,0x0,0xcf,0x0
SV32_MMU_PTW_4M 0x400,0x400,0xcf,0x0
SV32_MMU_PTW_4M 0x800,0x800,0xcf,0x0
SV32_MMU_PTW_4M 0xc00,0xc00,0xcf,0x0
SV32_MMU_PTW_4M 0x1000,0x0,0xdf,0x0
SV32_MMU_PTW_4M 0x1400,0x400,0xdf,0x0
SV32_MMU_PTW_4M 0x1800,0x800,0xdf,0x0
SV32_MMU_PTW_4M 0x1c00,0xc00,0xdf,0x0

# lxf PA=0x3000 -> 0x2000.
SV32_MMU_PTW_4M 0x3000,0x2000,0xdf,0x0
SV32_MMU_PTW_4M 0x3400,0x2400,0xdf,0x0
SV32_MMU_PTW_4M 0x3800,0x2800,0xdf,0x0
SV32_MMU_PTW_4M 0x3c00,0x2c00,0xdf,0x0

# invalid all icache & TLB, lxf 20220810.
icache.ialls
sfence.vma x0, x0
#sfence.vmas x0, x0  # finally decide to do not support in C908, 20220811.

.endm


.macro MENVCFG_PBMTE IMM
  #write pbmte
  li    x9,0x1
  slli  x9, x9, 62
  csrc  menvcfg,x9
  csrr  x9,menvcfg
  li    x10, \IMM
  slli  x10,x10,62
  or    x9,x9,x10
  csrw  menvcfg,x9
.endm
