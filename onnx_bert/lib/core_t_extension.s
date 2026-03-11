



.macro SET_T
  li    x9, 0xff
  csrw  mteecfg, x9
.endm

.macro SET_NT
  csrw  mteecfg, x0
.endm

.macro SNOOP_DIS
  csrci msmpr, 0x1
.endm

.macro SNOOP_EN
  csrsi msmpr, 0x1
.endm

.macro W_CORE0_PMP_CFG_ENTRY0 IMM
  # load cfg data 
  li   x10, 0x4004020000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY1 IMM
  # load cfg data 
  li   x10, 0x4004020000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY2 IMM
  # load cfg data 
  li   x10, 0x4004020000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY3 IMM
  # load cfg data 
  li   x10, 0x4004020000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY4 IMM
  # load cfg data 
  li   x10, 0x4004020004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY5 IMM
  # load cfg data 
  li   x10, 0x4004020004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY6 IMM
  # load cfg0 data 
  li   x10, 0x4004020004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY7 IMM
  # load cfg0 data 
  li   x10, 0x4004020004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY8 IMM
  # load cfg data 
  li   x10, 0x4004020008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY9 IMM
  # load cfg data 
  li   x10, 0x4004020008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY10 IMM
  # load cfg0 data 
  li   x10, 0x4004020008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY11 IMM
  # load cfg0 data 
  li   x10, 0x4004020008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY12 IMM
  # load cfg data 
  li   x10, 0x400402000c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY13 IMM
  # load cfg data 
  li   x10, 0x400402000c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY14 IMM
  # load cfg0 data 
  li   x10, 0x400402000c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY15 IMM
  # load cfg0 data 
  li   x10, 0x400402000c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY16 IMM
  # load cfg data 
  li   x10, 0x4004020010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY17 IMM
  # load cfg data 
  li   x10, 0x4004020010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY18 IMM
  # load cfg0 data 
  li   x10, 0x4004020010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY19 IMM
  # load cfg0 data 
  li   x10, 0x4004020010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY20 IMM
  # load cfg data 
  li   x10, 0x4004020014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY21 IMM
  # load cfg data 
  li   x10, 0x4004020014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY22 IMM
  # load cfg0 data 
  li   x10, 0x4004020014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY23 IMM
  # load cfg0 data 
  li   x10, 0x4004020014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY24 IMM
  # load cfg data 
  li   x10, 0x4004020018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY25 IMM
  # load cfg data 
  li   x10, 0x4004020018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY26 IMM
  # load cfg0 data 
  li   x10, 0x4004020018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY27 IMM
  # load cfg0 data 
  li   x10, 0x4004020018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY28 IMM
  # load cfg data 
  li   x10, 0x400402001c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY29 IMM
  # load cfg data 
  li   x10, 0x400402001c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY30 IMM
  # load cfg0 data 
  li   x10, 0x400402001c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY31 IMM
  # load cfg0 data 
  li   x10, 0x400402001c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG_ENTRY32 IMM
  # load cfg data 
  li   x10, 0x4004020020
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_ADDR_ENTRY0 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020100
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020104
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY1 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020108
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402010c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY2 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020110
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020114
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY3 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020118
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402011c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY4 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020120
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020124
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY5 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020128
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402012c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY6 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020130
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020134
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY7 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020138
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402013c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY8 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020140
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020144
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY9 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020148
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402014c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY10 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020150
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020154
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY11 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020158
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402015c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY12 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020160
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020164
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY13 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020168
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402016c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY14 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020170
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020174
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY15 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020178
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402017c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY16 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020180
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020184
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY17 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020188
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402018c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY18 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020190
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004020194
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY19 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004020198
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402019c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY20 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201a0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201a4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY21 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201a8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201ac
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY22 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201b0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201b4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY23 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201b8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201bc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY24 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201c0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201c4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY25 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201c8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201cc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY26 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201d0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201d4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY27 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201d8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201dc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY28 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201e0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201e4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY29 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201e8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201ec
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY30 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201f0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201f4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_ADDR_ENTRY31 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040201f8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040201fc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_CFG_ENTRY0 IMM
  # load cfg data 
  li   x10, 0x4004024000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY1 IMM
  # load cfg data 
  li   x10, 0x4004024000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY2 IMM
  # load cfg data 
  li   x10, 0x4004024000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY3 IMM
  # load cfg data 
  li   x10, 0x4004024000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY4 IMM
  # load cfg data 
  li   x10, 0x4004024004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY5 IMM
  # load cfg data 
  li   x10, 0x4004024004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY6 IMM
  # load cfg0 data 
  li   x10, 0x4004024004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY7 IMM
  # load cfg0 data 
  li   x10, 0x4004024004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY8 IMM
  # load cfg data 
  li   x10, 0x4004024008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY9 IMM
  # load cfg data 
  li   x10, 0x4004024008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY10 IMM
  # load cfg0 data 
  li   x10, 0x4004024008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY11 IMM
  # load cfg0 data 
  li   x10, 0x4004024008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY12 IMM
  # load cfg data 
  li   x10, 0x400402400c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY13 IMM
  # load cfg data 
  li   x10, 0x400402400c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY14 IMM
  # load cfg0 data 
  li   x10, 0x400402400c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY15 IMM
  # load cfg0 data 
  li   x10, 0x400402400c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY16 IMM
  # load cfg data 
  li   x10, 0x4004024010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY17 IMM
  # load cfg data 
  li   x10, 0x4004024010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY18 IMM
  # load cfg0 data 
  li   x10, 0x4004024010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY19 IMM
  # load cfg0 data 
  li   x10, 0x4004024010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY20 IMM
  # load cfg data 
  li   x10, 0x4004024014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY21 IMM
  # load cfg data 
  li   x10, 0x4004024014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY22 IMM
  # load cfg0 data 
  li   x10, 0x4004024014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY23 IMM
  # load cfg0 data 
  li   x10, 0x4004024014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY24 IMM
  # load cfg data 
  li   x10, 0x4004024018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY25 IMM
  # load cfg data 
  li   x10, 0x4004024018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY26 IMM
  # load cfg0 data 
  li   x10, 0x4004024018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY27 IMM
  # load cfg0 data 
  li   x10, 0x4004024018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY28 IMM
  # load cfg data 
  li   x10, 0x400402401c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY29 IMM
  # load cfg data 
  li   x10, 0x400402401c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY30 IMM
  # load cfg0 data 
  li   x10, 0x400402401c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY31 IMM
  # load cfg0 data 
  li   x10, 0x400402401c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG_ENTRY32 IMM
  # load cfg data 
  li   x10, 0x4004024020
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_ADDR_ENTRY0 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024100
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024104
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY1 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024108
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402410c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY2 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024110
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024114
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY3 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024118
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402411c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY4 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024120
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024124
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY5 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024128
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402412c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY6 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024130
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024134
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY7 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024138
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402413c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY8 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024140
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024144
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY9 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024148
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402414c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY10 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024150
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024154
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY11 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024158
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402415c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY12 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024160
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024164
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY13 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024168
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402416c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY14 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024170
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024174
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY15 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024178
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402417c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY16 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024180
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024184
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY17 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024188
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402418c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY18 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024190
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004024194
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY19 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004024198
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402419c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY20 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241a0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241a4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY21 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241a8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241ac
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY22 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241b0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241b4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY23 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241b8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241bc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY24 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241c0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241c4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY25 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241c8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241cc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY26 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241d0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241d4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY27 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241d8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241dc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY28 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241e0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241e4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY29 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241e8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241ec
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY30 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241f0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241f4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE1_PMP_ADDR_ENTRY31 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040241f8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040241fc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_CFG_ENTRY0 IMM
  # load cfg data 
  li   x10, 0x4004028000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY1 IMM
  # load cfg data 
  li   x10, 0x4004028000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY2 IMM
  # load cfg data 
  li   x10, 0x4004028000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY3 IMM
  # load cfg data 
  li   x10, 0x4004028000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY4 IMM
  # load cfg data 
  li   x10, 0x4004028004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY5 IMM
  # load cfg data 
  li   x10, 0x4004028004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY6 IMM
  # load cfg0 data 
  li   x10, 0x4004028004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY7 IMM
  # load cfg0 data 
  li   x10, 0x4004028004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY8 IMM
  # load cfg data 
  li   x10, 0x4004028008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY9 IMM
  # load cfg data 
  li   x10, 0x4004028008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY10 IMM
  # load cfg0 data 
  li   x10, 0x4004028008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY11 IMM
  # load cfg0 data 
  li   x10, 0x4004028008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY12 IMM
  # load cfg data 
  li   x10, 0x400402800c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY13 IMM
  # load cfg data 
  li   x10, 0x400402800c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY14 IMM
  # load cfg0 data 
  li   x10, 0x400402800c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY15 IMM
  # load cfg0 data 
  li   x10, 0x400402800c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY16 IMM
  # load cfg data 
  li   x10, 0x4004028010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY17 IMM
  # load cfg data 
  li   x10, 0x4004028010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY18 IMM
  # load cfg0 data 
  li   x10, 0x4004028010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY19 IMM
  # load cfg0 data 
  li   x10, 0x4004028010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY20 IMM
  # load cfg data 
  li   x10, 0x4004028014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY21 IMM
  # load cfg data 
  li   x10, 0x4004028014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY22 IMM
  # load cfg0 data 
  li   x10, 0x4004028014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY23 IMM
  # load cfg0 data 
  li   x10, 0x4004028014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY24 IMM
  # load cfg data 
  li   x10, 0x4004028018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY25 IMM
  # load cfg data 
  li   x10, 0x4004028018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY26 IMM
  # load cfg0 data 
  li   x10, 0x4004028018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY27 IMM
  # load cfg0 data 
  li   x10, 0x4004028018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY28 IMM
  # load cfg data 
  li   x10, 0x400402801c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY29 IMM
  # load cfg data 
  li   x10, 0x400402801c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY30 IMM
  # load cfg0 data 
  li   x10, 0x400402801c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY31 IMM
  # load cfg0 data 
  li   x10, 0x400402801c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG_ENTRY32 IMM
  # load cfg data 
  li   x10, 0x4004028020
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_ADDR_ENTRY0 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028100
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028104
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY1 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028108
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402810c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY2 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028110
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028114
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY3 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028118
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402811c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY4 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028120
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028124
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY5 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028128
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402812c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY6 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028130
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028134
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY7 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028138
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402813c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY8 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028140
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028144
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY9 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028148
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402814c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY10 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028150
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028154
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY11 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028158
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402815c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY12 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028160
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028164
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY13 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028168
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402816c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY14 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028170
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028174
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY15 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028178
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402817c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY16 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028180
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028184
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY17 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028188
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402818c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY18 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028190
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x4004028194
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY19 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x4004028198
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402819c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY20 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281a0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281a4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY21 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281a8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281ac
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY22 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281b0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281b4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY23 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281b8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281bc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY24 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281c0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281c4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY25 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281c8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281cc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY26 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281d0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281d4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY27 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281d8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281dc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY28 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281e0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281e4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY29 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281e8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281ec
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY30 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281f0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281f4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE2_PMP_ADDR_ENTRY31 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x40040281f8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x40040281fc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_CFG_ENTRY0 IMM
  # load cfg data 
  li   x10, 0x400402c000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY1 IMM
  # load cfg data 
  li   x10, 0x400402c000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY2 IMM
  # load cfg data 
  li   x10, 0x400402c000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY3 IMM
  # load cfg data 
  li   x10, 0x400402c000
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY4 IMM
  # load cfg data 
  li   x10, 0x400402c004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY5 IMM
  # load cfg data 
  li   x10, 0x400402c004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY6 IMM
  # load cfg0 data 
  li   x10, 0x400402c004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY7 IMM
  # load cfg0 data 
  li   x10, 0x400402c004
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY8 IMM
  # load cfg data 
  li   x10, 0x400402c008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY9 IMM
  # load cfg data 
  li   x10, 0x400402c008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY10 IMM
  # load cfg0 data 
  li   x10, 0x400402c008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY11 IMM
  # load cfg0 data 
  li   x10, 0x400402c008
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY12 IMM
  # load cfg data 
  li   x10, 0x400402c00c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY13 IMM
  # load cfg data 
  li   x10, 0x400402c00c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY14 IMM
  # load cfg0 data 
  li   x10, 0x400402c00c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY15 IMM
  # load cfg0 data 
  li   x10, 0x400402c00c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY16 IMM
  # load cfg data 
  li   x10, 0x400402c010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY17 IMM
  # load cfg data 
  li   x10, 0x400402c010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY18 IMM
  # load cfg0 data 
  li   x10, 0x400402c010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY19 IMM
  # load cfg0 data 
  li   x10, 0x400402c010
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY20 IMM
  # load cfg data 
  li   x10, 0x400402c014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY21 IMM
  # load cfg data 
  li   x10, 0x400402c014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY22 IMM
  # load cfg0 data 
  li   x10, 0x400402c014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY23 IMM
  # load cfg0 data 
  li   x10, 0x400402c014
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY24 IMM
  # load cfg data 
  li   x10, 0x400402c018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY25 IMM
  # load cfg data 
  li   x10, 0x400402c018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY26 IMM
  # load cfg0 data 
  li   x10, 0x400402c018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY27 IMM
  # load cfg0 data 
  li   x10, 0x400402c018
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY28 IMM
  # load cfg data 
  li   x10, 0x400402c01c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY29 IMM
  # load cfg data 
  li   x10, 0x400402c01c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffff00ff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 8
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY30 IMM
  # load cfg0 data 
  li   x10, 0x400402c01c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xff00ffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 16
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY31 IMM
  # load cfg0 data 
  li   x10, 0x400402c01c
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0x00ffffff
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11, x11, 24
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG_ENTRY32 IMM
  # load cfg data 
  li   x10, 0x400402c020
  lw   x9,  0(x10) 
  sync.is
  # clr low 8 bit
  li   x11, 0xffffff00 
  and  x9, x9, x11
  # set imm
  li   x11, \IMM
  slli x11,x11,0x0
  or   x9, x9, x11
  # write cfg0
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_ADDR_ENTRY0 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c100
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c104
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY1 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c108
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c10c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY2 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c110
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c114
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY3 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c118
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c11c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY4 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c120
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c124
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY5 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c128
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c12c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY6 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c130
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c134
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY7 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c138
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c13c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY8 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c140
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c144
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY9 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c148
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c14c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY10 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c150
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c154
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY11 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c158
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c15c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY12 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c160
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c164
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY13 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c168
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c16c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY14 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c170
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c174
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY15 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c178
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c17c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY16 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c180
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c184
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY17 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c188
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c18c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY18 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c190
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c194
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY19 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c198
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c19c
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY20 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1a0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1a4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY21 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1a8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1ac
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY22 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1b0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1b4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY23 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1b8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1bc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY24 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1c0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1c4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY25 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1c8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1cc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY26 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1d0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1d4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY27 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1d8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1dc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY28 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1e0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1e4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY29 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1e8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1ec
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY30 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1f0
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1f4
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE3_PMP_ADDR_ENTRY31 ADDR_BEG,ADD_END
  # cfg addr start
  li   x9,  \ADDR_BEG
  li   x10, 0x400402c1f8
  sw   x9,  0(x10) 
  sync.is
  # cfg addr end
  li   x9,  \ADD_END
  li   x10, 0x400402c1fc
  sw   x9,  0(x10) 
  sync.is
.endm

.macro W_CORE0_PMP_CFG0 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020000
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG1 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020004
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG2 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020008
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG3 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402000c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG4 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020010
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG5 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020014
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG6 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020018
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG7 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402001c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE0_PMP_CFG8 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004020020
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG0 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024000
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG1 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024004
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG2 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024008
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG3 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402400c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG4 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024010
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG5 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024014
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG6 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024018
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG7 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402401c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE1_PMP_CFG8 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004024020
  sw   x9, 0(x10)
  sync.is 
.endm

    .macro W_CORE2_PMP_CFG0 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028000
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG1 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028004
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG2 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028008
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG3 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402800c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG4 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028010
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG5 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028014
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG6 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028018
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG7 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402801c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE2_PMP_CFG8 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x4004028020
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG0 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c000
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG1 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c004
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG2 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c008
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG3 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c00c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG4 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c010
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG5 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c014
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG6 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c018
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG7 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c01c
  sw   x9, 0(x10)
  sync.is 
.endm

.macro W_CORE3_PMP_CFG8 IMM
  # write cfg
  li   x9, \IMM
  li   x10, 0x400402c020
  sw   x9, 0(x10)
  sync.is 
.endm
