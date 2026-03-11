######################################################################################
#                              Included Macro                                        #
#  1. L2C_CACHE_EN                   SET MCCR2.L2EN = 1'b1                           #
#  2. L2C_CACHE_DIS                  SET MCCR2.L2EN = 1'b0                           #
#  3. L2C_CACHE_ALCT                 SET MCCR2.RFE = 1                               #
#  4. L2C_CACHE_NOALCT               SET MCCR2.RFE = 0                               #
#  5. L2C_CACHE_INV_ALL              L2_CACHE INV_ALL                                #
#  6. L2C_CACHE_CLN_ALL              L2_CACHE CLEAN ALL                              #
#  7. L2C_CACHE_CLIV_ALL             L2_CACHE CLEAN INVALID ALL                      #
#  8. L2C_TLB_PREFETCH_EN            SET MCCR2.TPRF = 1 Enable                       #
#  9. L2C_TLB_PREFETCH_DIS           SET MCCR2.TPRF = 0 Disable                      #
#  10.L2C_ICACHE_PREFETCH_EN_1       SET MCCR2.IPRF = 2'b01                          #
#  11.L2C_ICACHE_PREFETCH_EN_2       SET MCCR2.IPRF = 2'b10                          #
#  12.L2C_ICACHE_PREFETCH_EN_3       SET MCCR2.IPRF = 2'b11                          #
#  13.L2C_ICACHE_PREFETCH_DIS        SET MCCR2.IPRF = 2'b0                           #
#  14.L2C_ECC_EN                     SET MCCR2.ECCEN = 1'b1                          #
#  15.L2C_ECC_DIS                    SET MCCR2.ECCEN = 1'b0                          #
#  16.L2C_TAG_SETUP                  SET MCCR2.ECCEN = 1'b0                          #
#  17.L2C_TAG_LTNCY                  SET MCCR2.TLTNCY = TAG_LTNCY_REG                #
#  18.L2C_DATA_SETUP                 SET MCCR2.DSETUP = DATA_SETUP_REG               #
#  19.L2C_DATA_LTNCY                 SET MCCR2.DLTNCY = DATA_LTNCY_REG               #
######################################################################################

#SET MCCR2.L2EN = 1'b1
.macro L2C_CACHE_EN
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x8
  csrs mccr2, t1
 
  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.L2EN = 1'b0
.macro L2C_CACHE_DIS
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x8
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm


#SET MCCR2.RFE = 1
.macro L2C_CACHE_ALCT
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x1
  csrs mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.RFE = 0
.macro L2C_CACHE_NOALCT
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x1
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#L2_CACHE INV_ALL
.macro L2C_CACHE_INV_ALL
  L2cache.iall
.endm

#L2_CACHE CLEAN ALL
.macro L2C_CACHE_CLN_ALL
  L2cache.call
.endm

#L2_CACHE CLEAN INVALID ALL
.macro L2C_CACHE_CLIV_ALL
  L2cache.ciall
.endm

#SET MCCR2.TPRF = 1 Enable L2CACHE_TLB Prefetch
.macro L2C_TLB_PREFETCH_EN
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x80000000
  csrs mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.TPRF = 0 Disable L2CACHE_TLB Prefetch
.macro L2C_TLB_PREFETCH_DIS
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x80000000
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.IPRF = 2'b01
.macro L2C_ICACHE_PREFETCH_EN_1
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x40000000
  csrc mccr2, t1
  li t1, 0x20000000
  csrs mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.IPRF = 2'b10
.macro L2C_ICACHE_PREFETCH_EN_2
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x40000000
  csrs mccr2, t1
  li t1, 0x20000000
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.IPRF = 2'b11
.macro L2C_ICACHE_PREFETCH_EN_3
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x40000000
  csrs mccr2, t1
  li t1, 0x20000000
  csrs mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.IPRF = 2'b0
.macro L2C_ICACHE_PREFETCH_DIS
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x40000000
  csrc mccr2, t1
  li t1, 0x20000000
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm


#SET MCCR2.ECCEN = 1'b1
.macro L2C_ECC_EN
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x2
  csrs mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm

#SET MCCR2.ECCEN = 1'b0
.macro L2C_ECC_DIS
  addi sp,sp,-8
  sd   t1, 8(sp)

  li t1, 0x2
  csrc mccr2, t1

  ld   t1, 8(sp)
  addi sp,sp,8
.endm


#SET MCCR2.ECCEN = 1'b0
.macro L2C_TAG_SETUP TAG_SETUP_REG
  addi sp,sp,-16
  sd   t0, 8(sp)
  sd   t1, 16(sp)

  mv t1,\TAG_SETUP_REG
  slli t1,t1,25
  csrr t0, mccr2
  or t0,t0,t1
  csrw mccr2,t0 

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16
.endm


#SET MCCR2.TLTNCY = TAG_LTNCY_REG
.macro L2C_TAG_LTNCY TAG_LTNCY_REG
  addi sp,sp,-16
  sd   t0, 8(sp)
  sd   t1, 16(sp)

  mv t1,\TAG_LTNCY_REG
  slli t1,t1,22
  csrr t0, mccr2
  or t0,t0,t1
  csrw mccr2,t0

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16
.endm

#SET MCCR2.DSETUP = DATA_SETUP_REG
.macro L2C_DATA_SETUP DATA_SETUP_REG
  addi sp,sp,-16
  sd   t0, 8(sp)
  sd   t1, 16(sp)

  mv t1,\DATA_SETUP_REG
  slli t1,t1,19
  csrr t0, mccr2
  or t0,t0,t1
  csrw mccr2,t0

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16
.endm

#SET MCCR2.DLTNCY = DATA_LTNCY_REG
.macro L2C_DATA_LTNCY DATA_LTNCY_REG
  addi sp,sp,-16
  sd   t0, 8(sp)
  sd   t1, 16(sp)

  mv t1,\DATA_LTNCY_REG
  slli t1,t1,16
  csrr t0, mccr2
  or t0,t0,t1
  csrw mccr2,t0

  ld   t0, 8(sp)
  ld   t1, 16(sp)
  addi sp,sp,16
.endm

