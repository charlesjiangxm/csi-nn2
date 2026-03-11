##// *****************************************************************************
##// *                                                                           *
##// * C-Sky Microsystems Confidential                                           *
##// * -------------------------------                                           *
##// * This file and all its contents are properties of C-Sky Microsystems. The  *
##// * information contained herein is confidential and proprietary and is not   *
##// * to be disclosed outside of C-Sky Microsystems except under a              *
##// * Non-Disclosure Agreement (NDA).                                           *
##// *                                                                           *
##// *****************************************************************************
##// FILE NAME       : fp_macro_inst.h
##// AUTHOR          : JiangPeng
##// ORIGINAL TIME   : 06/12/2012
##// FUNCTION        : specital macro instruction definition
##// METHOD          :
##// RELEASE HISTORY :
##// $Id: 
##// *****************************************************************************
##//set PSR
.macro SETFPU
  li x1,0x2000
  csrrs x0, mstatus,x1
##//  cpseti 1
.endm

.macro FPUBP16SET IMME2, IMM_REG0
   addi \IMM_REG0,x0,0x1
   slli \IMM_REG0,\IMM_REG0, 31
   csrrc x0, fxcr,\IMM_REG0
   li \IMM_REG0, \IMME2
   slli \IMM_REG0,\IMM_REG0, 31
   csrrs x0, fxcr,\IMM_REG0
.endm

.macro FPUBP16_REGSET IMM_REG1, IMM_REG0
   slli \IMM_REG1,\IMM_REG1, 31
   csrrc x0, fxcr,\IMM_REG0
   or \IMM_REG0,\IMM_REG0,\IMM_REG1
   csrrs x0, fxcr,\IMM_REG0
.endm





##//SET half precision number, 1
.macro FPUMOVH FDESREG, IMME16, IMM_REG
  li \IMM_REG, \IMME16
  li x3, 0xffff0000
  or \IMM_REG,\IMM_REG,x3
  fmv.w.x \FDESREG, \IMM_REG  
.endm

##//SET single precision number, 1
.macro FPUMOVS FDESREG, IMME32, IMM_REG
  li \IMM_REG, \IMME32
  fmv.w.x \FDESREG, \IMM_REG  
.endm

##//Send double format data to vrx  
.macro FPUMOVD FDESREG,IMME64,IMM_REG
  li \IMM_REG, \IMME64
  fmv.d.x \FDESREG, \IMM_REG
.endm

##//Check single 32 bits data of vrx with expect result imm, in RV64, the low 32 bits should be checked
.macro FPUSCHECKS FDESREG, EXPNUM, IMM_REG0, IMM_REG1     
  li \IMM_REG0,0xffffffff00000000
  li \IMM_REG1, \EXPNUM
  or \IMM_REG0,\IMM_REG1,\IMM_REG0
  fmv.x.d \IMM_REG1,\FDESREG
.endm

.macro FPUCHECKD FDESREG, EXPNUM, IMM_REG0, IMM_REG1
  li \IMM_REG0,\EXPNUM
  fmv.x.d \IMM_REG1,\FDESREG
 .endm




##//Check half 16 bits data of vrx with expect result imm, in RV64, the low 16 bits should be checked, xuwenjian add.
.macro FPUHCHECKH FDESREG, EXPNUM, IMM_REG0, IMM_REG1     
  li \IMM_REG0,0xffffffffffff0000
  li \IMM_REG1, \EXPNUM
  or \IMM_REG0,\IMM_REG1,\IMM_REG0
  fmv.x.d \IMM_REG1,\FDESREG
  bne \IMM_REG0, \IMM_REG1, RESULT_FAIL
.endm


.macro FPUSCHECKD_ALL FDESREG, EXPNUM, EXP_FLAG     
  li x3, 0x0000000000000000
  li x4, \EXPNUM
  or x3, x4,x3
  fmv.x.d x4,\FDESREG
  bne x3, x4, RESULTFAIL
  FPUEXCHECK \EXP_FLAG

.endm

.macro FPUSCHECKS_ALL FDESREG, EXPNUM, EXP_FLAG     
  li x3, 0xffffffff00000000
  li x4, \EXPNUM
  or x3, x4,x3
  fmv.x.d x4,\FDESREG
  bne x3, x4, RESULTFAIL
  FPUEXCHECK \EXP_FLAG

.endm






##//Check double 
##//check low 32 bits of 64  bits data in vrx ---> flrw.32 and fcmpne.32 is recommended  
.macro FPUSCHECKD FDESREG,EXPNUML, IMM_REG0, IMM_REG1
  fmv.x.d \IMM_REG0, \FDESREG    
  li   \IMM_REG1, \EXPNUML
.endm

##//check VECOTR  ELEMENT 0 
.macro FPUVCHECK_ZER0 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm



##//check VECOTR  ELEMENT 0 
.macro FPUVCHECK_ZERO FDESVREG, EXPNUM IMM_REG0, IMM_REG1 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm


##//check VECOTR  ELEMENT 1       xuwj add, add element 1 check 
.macro FPUVCHECK_ELE1 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x10,0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x10 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check VECOTR  ELEMENT 2       xuwj add, add element 2 check 
.macro FPUVCHECK_ELE2 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x5,0x2
  vslidedown.vx \FDESVREG, \FDESVREG, x5 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check VECOTR  ELEMENT 3       xuwj add, add element 3 check 
.macro FPUVCHECK_ELE3 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x6,0x3
  vslidedown.vx \FDESVREG, \FDESVREG, x6 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check VECOTR  ELEMENT 4       xuwj add, add element 4 check 
.macro FPUVCHECK_ELE4 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x6,0x4
  vslidedown.vx \FDESVREG, \FDESVREG, x6 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check VECOTR  ELEMENT 5       xuwj add, add element 5 check 
.macro FPUVCHECK_ELE5 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x6,0x5
  vslidedown.vx \FDESVREG, \FDESVREG, x6 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check VECOTR  ELEMENT 6       xuwj add, add element 5 check 
.macro FPUVCHECK_ELE6 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x6,0x6
  vslidedown.vx \FDESVREG, \FDESVREG, x6 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm


##//check VECOTR  ELEMENT 7       xuwj add, add element 5 check 
.macro FPUVCHECK_ELE7 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  li x6,0x7
  vslidedown.vx \FDESVREG, \FDESVREG, x6 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm

##//check WIDEN  ELEMENT 2       xuwj add, add element 2 check 
.macro FPUWIDENCHECK_ELE2 FDESVREG, EXPNUM  IMM_REG0, IMM_REG1 
  vsetvli x5, x0, e64, m2
  li x5,0x2
  vslidedown.vx \FDESVREG, \FDESVREG, x5 
  vmv.x.s \IMM_REG0, \FDESVREG
  FPUCHKSIMD_MASK \IMM_REG0
  li   \IMM_REG1, \EXPNUM
.endm






##//check VECOTR  ELEMENT 0       xuwj modified, add bne instruction in macro,use x3x4 default
.macro FPUCHK_ELE0 FDESVREG, EXPNUM   
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 1       xuwj add, add element 1 check 
.macro FPUCHK_ELE1 FDESVREG, EXPNUM   
  li x7,0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 2       xuwj add, add element 2 check 
.macro FPUCHK_ELE2 FDESVREG, EXPNUM   
  li x7,0x2
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 3       xuwj add, add element 3 check 
.macro FPUCHK_ELE3 FDESVREG, EXPNUM   
  li x7,0x3
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 4       xuwj add, add element 4 check 
.macro FPUCHK_ELE4 FDESVREG, EXPNUM   
  li x7,0x4
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 5       xuwj add, add element 5 check 
.macro FPUCHK_ELE5 FDESVREG, EXPNUM   
  li x7,0x5
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm


##//check VECOTR  ELEMENT 6       xuwj add, add element 6 check 
.macro FPUCHK_ELE6 FDESVREG, EXPNUM   
  li x7,0x6
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//check VECOTR  ELEMENT 7       xuwj add, add element 7 check 
.macro FPUCHK_ELE7 FDESVREG, EXPNUM   
  li x7,0x7
  vslidedown.vx \FDESVREG, \FDESVREG, x7 
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  li   x4, \EXPNUM
  bne x3,x4,EXCEPTION_FAIL
.endm

##//WRITE IN FLOAT ELE1       xuwj add, add FLOAT element1 INIT 
.macro INIT_ELE1 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  FPUMOVD f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN FLOAT ELE1       xuwj add, add FLOAT element1 INIT 
.macro INIT_SELE1 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN FLOAT ELE2       xuwj add, add FLOAT element2 INIT 
.macro INIT_SELE2 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \FDESVREG, v30, x19, v0.t
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN FLOAT ELE3       xuwj add, add FLOAT element3 INIT 
.macro INIT_SELE3 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN HALF ELE1       xuwj add, add HALF element1 INITk 
.macro INIT_HELE1 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN HALF ELE2       xuwj add, add HALF element2 INIT 
.macro INIT_HELE2 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \FDESVREG, v30, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN HALF ELE3       xuwj add, add HALF element3 INIT 
.macro INIT_HELE3 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN HALF ELE4       xuwj add, add HALF element4 INIT 
.macro INIT_HELE4 FDESVREG, IMM_REG0   
  li x10,0x1
  li x7,0x4
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslideup.vx \FDESVREG, v31, x7, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
  .endm

##//WRITE IN HALF ELE5       xuwj add, add HALF element5 INIT 
.macro INIT_HELE5 FDESVREG, IMM_REG0   
  li x10,0x1
  li x7,0x5
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslideup.vx \FDESVREG, v31, x7, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v0,  v2 , x0
.endm


##//WRITE IN HALF ELE6       xuwj add, add HALF element6 INIT 
.macro INIT_HELE6 FDESVREG, IMM_REG0   
  li x10,0x1
  li x7,0x6
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslideup.vx \FDESVREG, v31, x7, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm


##//WRITE IN HALF ELE7       xuwj add, add HALF element7 INIT 
.macro INIT_HELE7 FDESVREG, IMM_REG0   
  li x10,0x1
  li x7,0x7
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslideup.vx \FDESVREG, v31, x7, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
.endm


##//WRITE IN WIDEN FLOAT ELE1       xuwj add, add WIDEN FLOAT element1 INIT 
.macro INIT_WSELE1 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN FLOAT ELE2       xuwj add, add WIDEN FLOAT element2 INIT 
.macro INIT_WSELE2 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f \FDESVREG, \IMM_REG0
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN FLOAT ELE3       xuwj add, add WIDEN FLOAT element3 INIT 
.macro INIT_WSELE3 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE1       xuwj add, add WIDEN HALF element1 INIT 
.macro INIT_WHELE1 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE2       xuwj add, add WIDEN HALF element2 INIT 
.macro INIT_WHELE2 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \FDESVREG, v30, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vmv.v.x v0, x10
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE3       xuwj add, add WIDEN HALF element3 INIT 
.macro INIT_WHELE3 FDESVREG, IMM_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE4       xuwj add, add WIDEN HALF element4 INIT 
.macro INIT_WHELE4 FDESVREG, IMM_REG0   
  li x10,0x1
  li x7,0x4
  vmv.v.x v0, x10
  vfmv.s.f \FDESVREG, \IMM_REG0
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
  .endm

##//WRITE IN WIDEN HALF ELE5       xuwj add, add WIDEN HALF element5 INIT 
.macro INIT_WHELE5 FDESVREG, IMM_REG0   
   li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v0,  v2 , x0
.endm


##//WRITE IN WIDEN HALF ELE6       xuwj add, add WIDEN HALF element6 INIT 
.macro INIT_WHELE6 FDESVREG, IMM_REG0   
   li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \FDESVREG, v30, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm


##//WRITE IN WIDEN HALF ELE7       xuwj add, add WIDEN HALF element7 INIT 
.macro INIT_WHELE7 FDESVREG, IMM_REG0   
 li x10,0x1
  vmv.v.x v0, x10
  vfmv.s.f v31, \IMM_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \FDESVREG, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
.endm

##//WRITE IN WIDEN HALF ELE1    xuwj add, move value from x reg to vreg ele1 
.macro INIT_WHELE1_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm


##//WRITE IN WIDEN HALF ELE2    xuwj add, move value from x reg to vreg ele2 
.macro INIT_WHELE2_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \V_REG0, v30, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vmv.v.x v0, x10
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE3    xuwj add, move value from x reg to vreg ele3 
.macro INIT_WHELE3_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN HALF ELE4    xuwj add, move value from x reg to vreg ele4 
.macro INIT_WHELE4_VX V_REG0, X_REG0   
  li x10,0x1
  li x7,0x4
  vmv.v.x v0, x10
  vmv.s.x \V_REG0, \X_REG0
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
  .endm

##//WRITE IN WIDEN HALF ELE5    xuwj add, move value from x reg to vreg ele5 
.macro INIT_WHELE5_VX V_REG0, X_REG0   
   li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v0,  v2 , x0
.endm

##//WRITE IN WIDEN HALF ELE6    xuwj add, move value from x reg to vreg ele6 
.macro INIT_WHELE6_VX V_REG0, X_REG0   
   li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx \V_REG0, v30, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm


##//WRITE IN WIDEN FLOAT ELE1    xuwj add, move value from x reg to vreg ele1 
.macro INIT_WSELE1_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v1,  f1       
  vslide1up.vx v0,  v1 , x0
.endm


##//WRITE IN WIDEN FLOAT ELE2    xuwj add, move value from x reg to vreg ele2 
.macro INIT_WSELE2_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x \V_REG0, \X_REG0
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v2,  f1       
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm

##//WRITE IN WIDEN FLOAT ELE3    xuwj add, move value from x reg to vreg ele3 
.macro INIT_WSELE3_VX V_REG0, X_REG0   
  li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e32, m1
  vmv.v.x v0, x10
  FPUMOVS f1 ,  0x1,   x1
  vfmv.s.f v3,  f1       
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v0,  v1 , x0
.endm





##//WRITE IN WIDEN HALF ELE7    xuwj add, move value from x reg to vreg ele7 
.macro INIT_WHELE7_VX V_REG0, X_REG0   
 li x10,0x1
  vmv.v.x v0, x10
  vmv.s.x v31, \X_REG0
  vslide1up.vx  v30, v31, x19, v0.t
  vslide1up.vx  v31, v30, x19, v0.t
  vslide1up.vx \V_REG0, v31, x19, v0.t
  vsetvli x1, x0, e16, m1
  FPUMOVH f3 ,  0x1,   x1
  vfmv.s.f v3,  f3       
  vmv.v.x v0, x10
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v2,  v3 , x0, v0.t
  vslide1up.vx v1,  v2 , x0, v0.t
  vslide1up.vx v3,  v1 , x0, v0.t
  vslide1up.vx v0,  v3 , x0
.endm







##//check all exceptions and then reset FESR all bit zero
##//to compatibale with RV and CSKY, here is a little bit ugly
##// for csky, check all bits for flag 
##// for rv, only check the flag  bits in fcsr
.macro FPUEXCHK EXPNUM32, IMM_REG0, IMM_REG1
  #//to see if fccee is enabled
  li   \IMM_REG0, 0x7f
  csrrs \IMM_REG1,fxcr,x0
  csrrc x0,fxcr, \IMM_REG0  #//clear flag bits
  and  \IMM_REG0, \IMM_REG0,\IMM_REG1
  li   \IMM_REG1, \EXPNUM32
.endm

.macro FPUEXCHK_REG IMM_REG0, IMM_REG1
  li   \IMM_REG0, 0x3f
  csrrs \IMM_REG1,fxcr,x0
  csrrc x0,fxcr, \IMM_REG0  #//clear flag bits
  and  \IMM_REG1, \IMM_REG0,\IMM_REG1
  mv   \IMM_REG0, \IMM_REG1
.endm


.macro FPUEXCHECK EXPNUM32   #//xuwj modified, add bne instruction in macro,use x3x4 default
  #//to see if fccee is enabled
  li   x3, 0x3f
  csrrs x4,fxcr,x0
  csrrc x0,fxcr, x3  #//clear flag bits
  and  x3, x3,x4
  li   x4, \EXPNUM32
  bne x3, x4,EXCEPTION_FAIL
.endm


##//#//Set qNaN of FCR and other bits don't change
##//0--- compatible with ck860  1----- compatible with IEEE-754 
.macro  FPUQNANCH IMME2, IMM_REG0   ##//imm_reg0 is a tmp reg 
  csrrs  x24, fxcr,x0        
  li   \IMM_REG0, 0xff7fffff
  and x24,\IMM_REG0,x24
  li  \IMM_REG0, \IMME2
  slli  \IMM_REG0,\IMM_REG0, 23             #//left shift 23  bits
  or    \IMM_REG0, \IMM_REG0,x24            #//set the current QNAN
  csrrw  x0, fxcr,\IMM_REG0        #//put in relative vcr
.endm

##//#//Set qNaN of FCR and other bits don't change 
##//   ---------------------xuwj add,use reg to set value
##//0--- compatible with ck860  1----- compatible with IEEE-754 
.macro  FPUQNANCFG IMM_REG0   ##//imm_reg0 is a tmp reg 
  csrrs  x24, fxcr,x0        
  li   x6, 0xff7fffff
  and x24,x6,x24
  slli  \IMM_REG0,\IMM_REG0, 23             #//left shift 23  bits
  or    \IMM_REG0, \IMM_REG0,x24            #//set the current QNAN
  csrrw  x0, fxcr,\IMM_REG0        #//put in relative vcr
.endm





##//
##//#//Set RM of FCR and other bits don't change
##//#//0--->nearest  1--->0  2--->+inf   3--->-inf 
##//imm_reg0 is a tmp reg
.macro  FPURMCH IMME2 , IMM_REG0   
  li x11, 0xf8ffffff
  csrrs \IMM_REG0, fxcr, x0
  and \IMM_REG0, \IMM_REG0,x11
  li x11,\IMME2
  slli x11, x11,24
  or x11, x11,\IMM_REG0
  csrrw x0, fxcr,x11
.endm

##//  xuwj modified
##//#//Set RM of FCR and other bits don't change
##//#//0--->nearest  1--->0  2--->+inf   3--->-inf  4--->+nearest Magnitude
##//imm_reg0 is a tmp reg
.macro  FPURMCF IMME2 , IMM_REG0   
  li x20, 0xf8ffffff
  csrrs \IMM_REG0, fxcr, x20
  and \IMM_REG0, \IMM_REG0,x24
  li x20,\IMME2
  slli x20, x20,24
  or x20, x20,\IMM_REG0
  csrrw x0, fxcr,x20
.endm



##//use scalar single inst,data as the input source,do selfcheck
.macro ADDS_SC SOURCE1, SOURCE2, RESULT, EXPNUM32
  FPUMOVS f1,\SOURCE1,x3
  FPUMOVS f2,\SOURCE2,x3
  fadd.s f12, f1 , f2
  #//CHECK
  FPUSCHECKS f12, \RESULT,x3,x4
  bne x4,x3, RESULTFAIL
  FPUEXCHK \EXPNUM32 , x3, x4
  bne x3,x4, FLAGCFAIL
.endm


##//use scalar single inst,data as the input source,no selfcheck
.macro ADDS_NOSC SOURCE1, SOURCE2, IMM1, IMM2  ##//NO USE
  FPUMOVS f1 , \SOURCE1, x3
  FPUMOVS f2 , \SOURCE2, x3
  fadd.s f12, f1 , f2
.endm


##//use scalar single inst,data as the input source,no selfcheck
.macro ADDS_NOSC_TWO_INPUT SOURCE1, SOURCE2
  FPUMOVS f1 , \SOURCE1, x3
  FPUMOVS f2 , \SOURCE2, x3
  fadd.s f12, f1 , f2
.endm



##//use scalar double inst,data as the input source,do selfcheck
.macro ADDD_SC SOURCE1, SOURCE2, RESULT,EXPNUM32
  FPUMOVD f1 , \SOURCE1, x3
  FPUMOVD f2 , \SOURCE2, x3
  fadd.d f12, f1 , f2
  FPUSCHECKD f12, \RESULT, x3,x4
  bne x3,x4, RESULTFAIL
  FPUEXCHK \EXPNUM32 , x3, x4
  bne x3,x4,  FLAGCFAIL
.endm
##//use scalar double inst,data as the input source,no selfcheck
.macro ADDD_NOSC SOURCE1, SOURCE2, IMM1, IMM2, IMM3
  FPUMOVD f1 , \SOURCE1, x3
  FPUMOVD f2 , \SOURCE2, x3
  fadd.d f12, f1 , f2
.endm
##//use scalar single inst,vreg as the input source,do selfcheck
.macro ADDS_VR FDESREG0, FDESREG1, RESULT, EXPNUM32
  FPUMOVS f12, SpZero  , x3#//PUT CASE TOP
  fadd.s f12, \FDESREG0 , \FDESREG1
 #//CHECK
  FPUSCHECKS f12, \RESULT, x3,x4
  bne x3, x4, RESULTFAIL
  FPUEXCHK \EXPNUM32 , x3, x4  #//close self check
  bne x3,x4, FLAGCFAIL
.endm
##//just delate self_check
##//use scalar single inst,vreg as the input source,no selfcheck
.macro ADDS_VR_NOSC FDESREG0, FDESREG1, RESULT, EXPNUM32
  FPUMOVS f12, SpZero  , x3#//PUT CASE TOP
  fadd.s f12, \FDESREG0 , \FDESREG1
.endm

##//use macro to add ,do self check and exception check xuwj add 
.macro ADDS_H FDESREG0, FDESREG1, RESULT, EXPNUM32
  FPUMOVH f12, HpZero  , x3#//PUT CASE TOP
  fadd.h f12, \FDESREG0 , \FDESREG1
 #//CHECK
  FPUSCHECKH f12, \RESULT, \EXPNUM32
.endm

##//Check single 16 bits data of vrx with expect result imm and exp flag.xuwj add
.macro FPUSCHECKH FDESREG, EXPNUM, EXP_FLAG     
  li x3, 0xffffffffffff0000
  li x4, \EXPNUM
  or x3, x4,x3
  fmv.x.d x4,\FDESREG
  bne x3, x4, RESULTFAIL
  FPUEXCHECK \EXP_FLAG

.endm

##//Check single 16 bits data of vrx with expect result imm and exp flag.xuwj add
.macro FPUSCHECKH_RESULT FDESREG, EXPNUM  
  li x3, 0xffffffffffff0000
  li x4, \EXPNUM
  or x3, x4,x3
  fmv.x.d x4,\FDESREG
  bne x3, x4, RESULTFAIL

.endm

##//Check FLT/FEQ/FLE result .xuwj add
.macro FPUCHECK_CMP_INT FDESREG, EXPNUM EXPFLAG 
  li x4, \EXPNUM
  bne \FDESREG, x4, RESULTFAIL
  FPUEXCHECK \EXPFLAG
.endm


##//use sigle sub inst
.macro SUBS_SC IMM1, IMM2, IMM3, EXPNUM32
  FPUMOVS f1 , \IMM1, x3
  FPUMOVS f2 , \IMM2, x3
  fsub.s f12, f1 , f2
  #//CHECK
  FPUSCHECKS f12,\IMM3,x3,x4
  bne x3,x4, RESULTFAIL
  FPUEXCHK \EXPNUM32 , x4, x3
  bne x3,x4,  FLAGCFAIL
.endm
##//use sigle sub inst NOSC
.macro SUBS_NOSC  IMM1, IMM2, IMM3, EXPNUM32
  FPUMOVS f1 , \IMM1, x3
  FPUMOVS f2 , \IMM2, x3
  fsub.s f12, f1 , f2
.endm
##//use sigle sub inst NOSC
.macro SUBS_NOSC_TWO_INPUT  IMM1, IMM2
  FPUMOVS f1 , \IMM1, x3
  FPUMOVS f2 , \IMM2, x3
  fsub.s f12, f1 , f2
.endm
##//use double sub inst
.macro SUBD_SC SOURCE1, SOURCE2, RESULT,EXPNUM32
  FPUMOVD f1 , \SOURCE1 ,x3
  FPUMOVD f2 , \SOURCE2, x3
  fsub.d f12, f1 , f2

  FPUSCHECKD f12, \RESULT, x3, x4
  bne x3,x4, RESULTFAIL
  FPUEXCHK \EXPNUM32 , x3, x4
  bne x3,x4, FLAGCFAIL
.endm
##//for nosc
.macro SUBD_NOSC SOURCE1, SOURCE2, RESULTH, RESULTL,EXPNUM32
  
  li x3, \SOURCE1
  li x4, \SOURCE2
  fmv.d.x f1,x3
  fmv.d.x f2,x4
  fsub.d f12, f1 , f2
.endm





##///////////////////////////////////////////////////////////////////////////////////
##///                           from Jiwei Ma                          
##////////////////////////////////////////////////////////////////////////////////////
.macro FPURMCH_REG IMM_REG0, IMM_REG1
  li \IMM_REG1, 0x7000000
  csrrc x0, fxcr, \IMM_REG1
  slli \IMM_REG0, \IMM_REG0,24
  csrrs x0, fxcr,\IMM_REG0
#  //restore \IMM_REG0
  srli \IMM_REG0, \IMM_REG0,24

.endm


#//for ibm/ucb case
.macro FPUMOVSIMD DST_VREG, VALUE
  li x6, \VALUE
  vmv.v.x \DST_VREG, x6
.endm


.macro FPUCHKSIMD_S FDESVREG, EXP_NUM, REG1,REG2, LABEL  
  li \REG2, \EXP_NUM
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  addi x1, x0, 0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
.endm

.macro FPUCHKSIMD_D FDESVREG, EXP_NUM,  REG1, REG2, LABEL  
  li \REG2, \EXP_NUM
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  addi x1, x0, 0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
.endm

.macro FPUCHKSIMD_WIDENS FDESVREG, EXP_NUM,  REG1, REG2, LABEL  
  vsetvli x1,x0,e64
  li \REG2, \EXP_NUM
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  addi x1, x0, 0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  vmv.x.s \REG1, v21
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  addi x1, x0, 0x1
  vslidedown.vx v21, v21, x1
  vmv.x.s \REG1, v21
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL
  vsetvli x1,x0,e32
.endm

#//-------------------------------------------------------
#//  xuwj add for half check
#//-------------------------------------------------------

.macro FPUCHKSIMD_H FDESVREG, EXP_NUM, REG1,REG2, LABEL  
  li \REG2, \EXP_NUM
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele0
  addi x1, x0, 0x1
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele1
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele2
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele3
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele4
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele5
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele6
  vslidedown.vx \FDESVREG, \FDESVREG, x1
  vmv.x.s \REG1, \FDESVREG
  FPUCHKSIMD_MASK \REG1
  bne \REG1, \REG2, \LABEL          #//cmp ele7
.endm



.macro FPUCHKSIMD_WIDENH FDESVREG, EXP_NUM
  vsetvli x4,x0,e32,m1
#//CHECK V28
  li x4, \EXP_NUM
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3, \FDESVREG
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
#//CHECK V29
  vmv.x.s x3, v29
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3,v29
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3,v29
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL
  addi x1, x0, 0x1
  vmv.x.s x3, v29
  FPUCHKSIMD_MASK x3
  bne x4, x3, RESULT_FAIL

  vsetvli x1,x0,e16,m1
.endm



.macro FPUCHKSIMD_MASK REG 
  addi x2,x2,-32
  sd x5,0x0(x2)
  sd x6,0x8(x2)
  csrr x5,vtype
  srli x5,x5,3
  andi x5,x5,7
  li   x6,8
  sll  x6,x6,x5
  li   x5,64
  sub  x5,x5,x6
  li   x6,-1
  srl  x5,x6,x5
  and  \REG,\REG,x5
  ld   x5,0x0(x2)
  ld   x6,0x8(x2)
  addi x2,x2,32
.endm






