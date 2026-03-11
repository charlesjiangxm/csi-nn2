.text
  .global IPMC_BOOT
IPMC_BOOT:
  .set IPMC_BASE            ,0x26900000
  .set IPMC_CLUSTER_OFFSET  ,0x4000
  .set IPMC_CORE0_OFFSET    ,0x0000
  .set IPMC_CORE1_OFFSET    ,0x1000
  .set IPMC_CORE2_OFFSET    ,0x2000
  .set IPMC_CORE3_OFFSET    ,0x3000


#if defined(CORENUM_4)
  .set CORENUM              ,4
#elif defined(CORENUM_3)
  .set CORENUM              ,3
#elif defined(CORENUM_2)
  .set CORENUM              ,2
#else
  .set CORENUM              ,1
#endif

/*
 //##################################
 //##################################
 //#                                #
 //# CLUSTER CONFIGURATION BEGIN    #
 //#                                #
 //##################################
 //##################################
*/

  li x17, IPMC_BASE
  li x18, IPMC_CLUSTER_OFFSET
  add x17, x17, x18

 //config cluster pmc_blk_mode_config0 (BASIC)
 //support on/off/warm_rst/retention/emu
  addi x18, x17, 0x200
  li x19, 0x38f
  sw x19, 0(x18)

 //config cluster pmc_blk_mode_config1 (CACHE)
 //disable slice1 off
  addi x18, x17, 0x204
  li x19, 0x7002f
  sw x19, 0(x18)
  
 //config cluster pmc_irq_mask0 (BASIC)
 //mask all irq
  addi x18, x17, 0x400
  sw x0, 0(x18)
  
 //config cluster pmc_irq_mask1 (CACHE)
 //mask all irq
  addi x18, x17, 0x404
  sw x0, 0(x18)

 //config cluster pmc_pc_hs_config0 (BASIC)
 //supply rest and few in basic pmc
  addi x18, x17, 0x500
  li x19, 0xf000f
  sw x19, 0(x18)

 //config cluster pmc_pc_hs_config1 (CACHE)
 //supply rest and few on ram0 ram1 snp slice1 in cache pmc
  addi x18, x17, 0x504
  li x19, 0x1ef39def
  sw x19, 0(x18)

 //config cluster pmc_mode_entry_timer_config0_0 (BASIC)
 //set timer to 10
  addi x18, x17, 0x600
  li x19, 0xa000a
  sw x19, 0(x18)

 //config cluster pmc_mode_entry_timer_config0_1 (BASIC)
 //set timer to 10
  addi x18, x17, 0x604
  li x19, 0xa000a
  sw x19, 0(x18)


 //config cluster pmc_mode_entry_timer_config1_0 (CACHE)
 //set timer to 10
  addi x18, x17, 0x60c
  li x19, 0xa000a
  sw x19, 0(x18)

 //config cluster pmc_ctrl_delay_config_0 (BASIC)
 //set delay to 10
  addi x18, x17, 0x700
  li x19, 0xa0a0a01
  sw x19, 0(x18)

 //config cluster pmc_sw_mode_ctrl0 (BASIC)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x100
  li x19, 0x18
  sw x19, 0(x18)

 //config cluster pmc_sw_mode_ctrl1 (CACHE)
 //set trans mode to direct; set sw mode to on (actually follow blk0, this code is useless)
  addi x18, x17, 0x104
  li x19, 0x17
  sw x19, 0(x18)

/*
 //##################################
 //##################################
 //#                                #
 //#  CLUSTER CONFIGURATION END     #
 //#                                #
 //##################################
 //##################################
*/

/*
 //##################################
 //##################################
 //#                                #
 //#  CORE CONFIGURATION BEGIN      #
 //#                                #
 //##################################
 //##################################
*/
  li x16, CORENUM
  li x15, 0x0

ipmc_core_cfg:  
  li x17, IPMC_BASE
  slli x18, x15, 12
  add x17, x17, x18

 //config core0 pmc_blk_mode_config0 (BASIC)
 //support on/off/warm_rst/retention/emu
  addi x18, x17, 0x200
  li x19, 0x323
  sw x19, 0(x18)
  
 //config core0 pmc_blk_mode_config1 (VFPU)
 //config low power mode as retention, config por
  addi x18, x17, 0x204
  li x19, 0x10001
  sw x19, 0(x18)

 //config core0 pmc_blk_mode_config2 (MPU)
 //config low power mode as off, config por
  addi x18, x17, 0x208
  li x19, 0x10000
  sw x19, 0(x18)

 //config core0 pmc_irq_mask0 (BASIC)
 //mask all irq
  addi x18, x17, 0x400
  sw x0, 0(x18)

 //config core0 pmc_irq_mask1 (VFPU)
 //mask all irq
  addi x18, x17, 0x404
  sw x0, 0(x18)

 //config core0 pmc_irq_mask2 (MPU)
 //mask all irq
  addi x18, x17, 0x408
  sw x0, 0(x18)

 //config core0 pmc_pc_hs_config0 (BASIC)
 //supply few and rest
  addi x18, x17, 0x500
  li x19, 0xf000f
  sw x19, 0(x18)


 //config core0 pmc_pc_hs_config1 (VFPU)
 //supply few and rest
  addi x18, x17, 0x504
  li x19, 0x7
  sw x19, 0(x18)

 //config core0 pmc_pc_hs_config2 (MPU)
 //supply few and rest
  addi x18, x17, 0x508
  li x19, 0x7
  sw x19, 0(x18)

 //config core0 pmc_mode_entry_timer_config0_0 (BASIC)
 //set off timer to 10
  addi x18, x17, 0x600
  li x19, 0xa000a
  sw x19, 0(x18)

 //config core0 pmc_mode_entry_timer_config0_1 (BASIC)
 //set off timer to 10
  addi x18, x17, 0x604
  li x19, 0xa000a
  sw x19, 0(x18)
  
 //config cluster pmc_ctrl_delay_config_0 (BASIC)
 //set delay to 10
  addi x18, x17, 0x700
  li x19, 0xa0a0a01
  sw x19, 0(x18)

 //config cluster pmc_mode_entry_timer_config1_0 (VFPU)
 //set off timer to 10
  addi x18, x17, 0x60c
  li x19, 0xa
  sw x19, 0(x18)
  
 //config cluster pmc_mode_entry_timer_config2_0 (MPU)
 //set off timer to 10
  addi x18, x17, 0x618
  li x19, 0xa
  sw x19, 0(x18)

 //config core0 pmc_sw_mode_ctrl0 (BASIC)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x100
  li x19, 0x18
  sw x19, 0(x18)

 //config core0 pmc_sw_mode_ctrl1 (VFPU)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x104
  li x19, 0x11
  sw x19, 0(x18)

 //config core0 pmc_sw_mode_ctrl2 (MPU)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x108
  li x19, 0x11
  sw x19, 0(x18)

  addi x15, x15, 1
  bne x15, x16, ipmc_core_cfg

/*
 //##################################
 //##################################
 //#                                #
 //#   CORE CONFIGURATION END       #
 //#                                #
 //##################################
 //##################################
*/
  ret

.global SET_COPROC_INT
SET_COPROC_INT:
  la x21, IPMC_CORE0_OFF2ON
  csrw mtvec, x21

  csrsi mstatus, 0x8
  csrs mie, 0x8
  ret

.align 4
.global IPMC_CORE0_OFF2ON
IPMC_CORE0_OFF2ON:

  li x16, CORENUM
  li x15, 0x0
  li x14, IPMC_BASE

IPMC_OPEN:
  slli x18, x15, 12
  add x17, x14, x18

 //config core0 pmc_sw_mode_ctrl0 (BASIC)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x100
  li x19, 0x18
  sw x19, 0(x18)

 //config core0 pmc_sw_mode_ctrl1 (VFPU)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x104
  li x19, 0x11
  sw x19, 0(x18)

 //config core0 pmc_sw_mode_ctrl2 (MPU)
 //set trans mode to direct; set sw mode to on
  addi x18, x17, 0x108
  li x19, 0x11
  sw x19, 0(x18)

  addi x15, x15, 1
  bne x15, x16, IPMC_OPEN

  csrw mie, x0
  mret

