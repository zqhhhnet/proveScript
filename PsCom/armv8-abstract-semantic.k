require "armv8-configuration.k"

module ARMV8-ABSTRACT-SEMANTIC
  imports ARMV8-CONFIGURATION
  
  /*@
    Translate register to Regstate keys
  */
  
  rule convToRegKeys(R:S32) =>  convToRegKeysHelper(convSubRegsToRegs(R))
  rule convToRegKeys(R:R32) =>  convToRegKeysHelper(convSubRegsToRegs(R))
  rule convToRegKeys(R:VirtualReg) =>  convToRegKeysHelper(convSubRegsToRegs(R))
  rule convToRegKeys(R:D64) => convToRegKeysHelper(convSubRegsToRegs(R))
  
  // for check
  rule convToRegKeys(R:Q128) => convToRegKeysHelper(convSubRegsToRegs(R))
  
  rule convVecToRegKeys(R:Q128, I:Beat) => convToRegKeysHelper(convSubVecRegsToRegs(R, I))
  rule convVecToRegKeys(R:D64, I:Beat) => convToRegKeysHelper(convSubVecRegsToRegs(R, I))

  rule convToRegKeysHelper(d0)   => "D0"
  rule convToRegKeysHelper(d1)   => "D1"
  rule convToRegKeysHelper(d2)   => "D2"
  rule convToRegKeysHelper(d3)   => "D3"
  rule convToRegKeysHelper(d4)   => "D4"
  rule convToRegKeysHelper(d5)   => "D5"
  rule convToRegKeysHelper(d6)   => "D6"
  rule convToRegKeysHelper(d7)   => "D7"
  rule convToRegKeysHelper(d8)   => "D8"
  rule convToRegKeysHelper(d9)   => "D9"
  rule convToRegKeysHelper(d10)   => "D10"
  rule convToRegKeysHelper(d11)   => "D11"
  rule convToRegKeysHelper(d12)   => "D12"
  rule convToRegKeysHelper(d13)   => "D13"
  rule convToRegKeysHelper(d14)   => "D14"
  rule convToRegKeysHelper(d15)   => "D15"

  rule convToRegKeysHelper(q0)   => "Q0"
  rule convToRegKeysHelper(q1)   => "Q1"
  rule convToRegKeysHelper(q2)   => "Q2"
  rule convToRegKeysHelper(q3)   => "Q3"
  rule convToRegKeysHelper(q4)   => "Q4"
  rule convToRegKeysHelper(q5)   => "Q5"
  rule convToRegKeysHelper(q6)   => "Q6"
  rule convToRegKeysHelper(q7)   => "Q7"
  
  rule convToRegKeysHelper(r0)   => "R0"
  rule convToRegKeysHelper(r1)   => "R1"
  rule convToRegKeysHelper(r2)   => "R2"
  rule convToRegKeysHelper(r3)   => "R3"
  rule convToRegKeysHelper(r4)   => "R4"
  rule convToRegKeysHelper(r5)   => "R5"
  rule convToRegKeysHelper(r6)   => "R6"
  rule convToRegKeysHelper(r7)   => "R7"
  rule convToRegKeysHelper(r8)    => "R8"
  rule convToRegKeysHelper(r9)    => "R9"
  rule convToRegKeysHelper(r10)   => "R10"
  rule convToRegKeysHelper(r11)   => "R11"
  rule convToRegKeysHelper(r12)   => "R12"
  rule convToRegKeysHelper(r13)   => "R13"
  rule convToRegKeysHelper(r14)   => "R14"
  rule convToRegKeysHelper(r15)   => "R15"
  
  rule convToRegKeysHelper(s0)  => "S0"
  rule convToRegKeysHelper(s1)  => "S1"
  rule convToRegKeysHelper(s2)  => "S2"
  rule convToRegKeysHelper(s3)  => "S3"
  rule convToRegKeysHelper(s4)  => "S4"
  rule convToRegKeysHelper(s5)  => "S5"
  rule convToRegKeysHelper(s6)  => "S6"
  rule convToRegKeysHelper(s7)  => "S7"
  rule convToRegKeysHelper(s8)  => "S8"
  rule convToRegKeysHelper(s9)  => "S9"
  rule convToRegKeysHelper(s10)  => "S10"
  rule convToRegKeysHelper(s11)  => "S11"
  rule convToRegKeysHelper(s12)  => "S12"
  rule convToRegKeysHelper(s13)  => "S13"
  rule convToRegKeysHelper(s14)  => "S14"
  rule convToRegKeysHelper(s15)  => "S15"
  rule convToRegKeysHelper(s16)  => "S16"
  rule convToRegKeysHelper(s17)  => "S17"
  rule convToRegKeysHelper(s18)  => "S18"
  rule convToRegKeysHelper(s19)  => "S19"
  rule convToRegKeysHelper(s20)  => "S20"
  rule convToRegKeysHelper(s21)  => "S21"
  rule convToRegKeysHelper(s22)  => "S22"
  rule convToRegKeysHelper(s23)  => "S23"
  rule convToRegKeysHelper(s24)  => "S24"
  rule convToRegKeysHelper(s25)  => "S25"
  rule convToRegKeysHelper(s26)  => "S26"
  rule convToRegKeysHelper(s27)  => "S27"
  rule convToRegKeysHelper(s28)  => "S28"
  rule convToRegKeysHelper(s29)  => "S29"
  rule convToRegKeysHelper(s30)  => "S30"
  rule convToRegKeysHelper(s31)  => "S31"
  
  rule convToRegKeysHelper(result) => "RESULT"
  rule convToRegKeysHelper(result64) => "RESULT64"
  
  /*
  rule convToRegKeysHelper(control)  => "CONTROL"
  rule convToRegKeysHelper(control_s)  => "CONTROL_S"
  rule convToRegKeysHelper(control_ns)  => "CONTROL_NS"
  rule convToRegKeysHelper(cpacr)  => "CPACR"
  rule convToRegKeysHelper(cpacr_s)  => "CPACR_S"
  rule convToRegKeysHelper(cpacr_ns)  => "CPACR_NS"
  rule convToRegKeysHelper(nsacr)  => "NSACR"
  rule convToRegKeysHelper(cppwr)  => "CPPWR"
  rule convToRegKeysHelper(cppwr_s)  => "CPPWR_S"
  rule convToRegKeysHelper(cppwr_ns)  => "CPPWR_NS"
  rule convToRegKeysHelper(mvfr1)  => "MVFR1"
  rule convToRegKeysHelper(fpccr)  => "FPCCR"
  rule convToRegKeysHelper(fpccr_s)  => "FPCCR_S"
  rule convToRegKeysHelper(fpccr_ns)  => "FPCCR_NS"
  rule convToRegKeysHelper(vpr)  => "VPR"
  rule convToRegKeysHelper(epsr)  => "EPSR"
   */
   
  /*@
    Sub registers to Registers
  */
  
  rule convSubRegsToRegs(result) => result
  rule convSubRegsToRegs(result64) => result64
  
  rule convSubRegsToRegs(d0)  => d0
  rule convSubRegsToRegs(d1)  => d1
  rule convSubRegsToRegs(d2)  => d2
  rule convSubRegsToRegs(d3)  => d3
  rule convSubRegsToRegs(d4)  => d4
  rule convSubRegsToRegs(d5)  => d5
  rule convSubRegsToRegs(d6)  => d6
  rule convSubRegsToRegs(d7)  => d7
  rule convSubRegsToRegs(d8)  => d8
  rule convSubRegsToRegs(d9)  => d9
  rule convSubRegsToRegs(d10)  => d10
  rule convSubRegsToRegs(d11)  => d11
  rule convSubRegsToRegs(d12)  => d12
  rule convSubRegsToRegs(d13)  => d13
  rule convSubRegsToRegs(d14)  => d14
  rule convSubRegsToRegs(d15)  => d15
  
  rule convSubRegsToRegs(q0)  => q0
  rule convSubRegsToRegs(q1)  => q1
  rule convSubRegsToRegs(q2)  => q2
  rule convSubRegsToRegs(q3)  => q3
  rule convSubRegsToRegs(q4)  => q4
  rule convSubRegsToRegs(q5)  => q5
  rule convSubRegsToRegs(q6)  => q6
  rule convSubRegsToRegs(q7)  => q7
  
  rule convSubRegsToRegs(s0)  => s0
  rule convSubRegsToRegs(s1)  => s1
  rule convSubRegsToRegs(s2)  => s2
  rule convSubRegsToRegs(s3)  => s3
  rule convSubRegsToRegs(s4)  => s4
  rule convSubRegsToRegs(s5)  => s5
  rule convSubRegsToRegs(s6)  => s6
  rule convSubRegsToRegs(s7)  => s7
  rule convSubRegsToRegs(s8)  => s8
  rule convSubRegsToRegs(s9)  => s9
  rule convSubRegsToRegs(s10)  => s10
  rule convSubRegsToRegs(s11)  => s11
  rule convSubRegsToRegs(s12)  => s12
  rule convSubRegsToRegs(s13)  => s13
  rule convSubRegsToRegs(s14)  => s14
  rule convSubRegsToRegs(s15)  => s15
  rule convSubRegsToRegs(s16)  => s16
  rule convSubRegsToRegs(s17)  => s17
  rule convSubRegsToRegs(s18)  => s18
  rule convSubRegsToRegs(s19)  => s19
  rule convSubRegsToRegs(s20)  => s20
  rule convSubRegsToRegs(s21)  => s21
  rule convSubRegsToRegs(s22)  => s22
  rule convSubRegsToRegs(s23)  => s23
  rule convSubRegsToRegs(s24)  => s24
  rule convSubRegsToRegs(s25)  => s25
  rule convSubRegsToRegs(s26)  => s26
  rule convSubRegsToRegs(s27)  => s27
  rule convSubRegsToRegs(s28)  => s28
  rule convSubRegsToRegs(s29)  => s29
  rule convSubRegsToRegs(s30)  => s30
  rule convSubRegsToRegs(s31)  => s31
  
  rule convSubVecRegsToRegs(d0, 0)  => s0
  rule convSubVecRegsToRegs(d0, 1)  => s1

  rule convSubVecRegsToRegs(d1, 0)  => s2
  rule convSubVecRegsToRegs(d1, 1)  => s3
  
  rule convSubVecRegsToRegs(d2, 0)  => s4
  rule convSubVecRegsToRegs(d2, 1)  => s5
  
  rule convSubVecRegsToRegs(d3, 0)  => s6
  rule convSubVecRegsToRegs(d3, 1)  => s7
  
  rule convSubVecRegsToRegs(d4, 0)  => s8
  rule convSubVecRegsToRegs(d4, 1)  => s9
  
  rule convSubVecRegsToRegs(d5, 0)  => s10
  rule convSubVecRegsToRegs(d5, 1)  => s11
  
  rule convSubVecRegsToRegs(d6, 0)  => s12
  rule convSubVecRegsToRegs(d6, 1)  => s13
  
  rule convSubVecRegsToRegs(d7, 0)  => s14
  rule convSubVecRegsToRegs(d7, 1)  => s15

  rule convSubVecRegsToRegs(d8, 0)  => s16
  rule convSubVecRegsToRegs(d8, 1)  => s17
  
  rule convSubVecRegsToRegs(d9, 0)  => s18
  rule convSubVecRegsToRegs(d9, 1)  => s19
  
  rule convSubVecRegsToRegs(d10, 0)  => s20
  rule convSubVecRegsToRegs(d10, 1)  => s21
  
  rule convSubVecRegsToRegs(d11, 0)  => s22
  rule convSubVecRegsToRegs(d11, 1)  => s23
  
  rule convSubVecRegsToRegs(d12, 0)  => s24
  rule convSubVecRegsToRegs(d12, 1)  => s25
  
  rule convSubVecRegsToRegs(d13, 0)  => s26
  rule convSubVecRegsToRegs(d13, 1)  => s27
  
  rule convSubVecRegsToRegs(d14, 0)  => s28
  rule convSubVecRegsToRegs(d14, 1)  => s29
  
  rule convSubVecRegsToRegs(d15, 0)  => s30
  rule convSubVecRegsToRegs(d15, 1)  => s31
  
  rule convSubVecRegsToRegs(q0, 0) => s0
  rule convSubVecRegsToRegs(q0, 1) => s1
  rule convSubVecRegsToRegs(q0, 2) => s2
  rule convSubVecRegsToRegs(q0, 3) => s3
  
  rule convSubVecRegsToRegs(q1, 0) => s4
  rule convSubVecRegsToRegs(q1, 1) => s5
  rule convSubVecRegsToRegs(q1, 2) => s6
  rule convSubVecRegsToRegs(q1, 3) => s7
  
  rule convSubVecRegsToRegs(q2, 0) => s8
  rule convSubVecRegsToRegs(q2, 1) => s9
  rule convSubVecRegsToRegs(q2, 2) => s10
  rule convSubVecRegsToRegs(q2, 3) => s11
  
  rule convSubVecRegsToRegs(q3, 0) => s12
  rule convSubVecRegsToRegs(q3, 1) => s13
  rule convSubVecRegsToRegs(q3, 2) => s14
  rule convSubVecRegsToRegs(q3, 3) => s15
  
  rule convSubVecRegsToRegs(q4, 0) => s16
  rule convSubVecRegsToRegs(q4, 1) => s17
  rule convSubVecRegsToRegs(q4, 2) => s18
  rule convSubVecRegsToRegs(q4, 3) => s19
  
  rule convSubVecRegsToRegs(q5, 0) => s20
  rule convSubVecRegsToRegs(q5, 1) => s21
  rule convSubVecRegsToRegs(q5, 2) => s22
  rule convSubVecRegsToRegs(q5, 3) => s23
  
  rule convSubVecRegsToRegs(q6, 0) => s24
  rule convSubVecRegsToRegs(q6, 1) => s25
  rule convSubVecRegsToRegs(q6, 2) => s26
  rule convSubVecRegsToRegs(q6, 3) => s27
  
  rule convSubVecRegsToRegs(q7, 0) => s28
  rule convSubVecRegsToRegs(q7, 1) => s29
  rule convSubVecRegsToRegs(q7, 2) => s30
  rule convSubVecRegsToRegs(q7, 3) => s31
  
  rule convSubRegsToRegs(r0) => r0
  rule convSubRegsToRegs(r1) => r1
  rule convSubRegsToRegs(r2) => r2
  rule convSubRegsToRegs(r3) => r3
  rule convSubRegsToRegs(r4) => r4
  rule convSubRegsToRegs(r5) => r5
  rule convSubRegsToRegs(r6) => r6
  rule convSubRegsToRegs(r7) => r7
  rule convSubRegsToRegs(r8) => r8
  rule convSubRegsToRegs(r9) => r9
  rule convSubRegsToRegs(r10) => r10
  rule convSubRegsToRegs(r11) => r11
  rule convSubRegsToRegs(r12) => r12
  rule convSubRegsToRegs(r13) => r13
  rule convSubRegsToRegs(r14) => r14
  rule convSubRegsToRegs(r15) => r15
  
  /*
  rule convSubRegsToRegs(control) => control
  rule convSubRegsToRegs(control_s) => control_s
  rule convSubRegsToRegs(control_ns) => control_ns
  rule convSubRegsToRegs(cpacr) => cpacr
  rule convSubRegsToRegs(cpacr_s) => cpacr_s
  rule convSubRegsToRegs(cpacr_ns) => cpacr_ns
  rule convSubRegsToRegs(nsacr) => nsacr
  rule convSubRegsToRegs(cppwr) => cppwr
  rule convSubRegsToRegs(cppwr_s) => cppwr_s
  rule convSubRegsToRegs(cppwr_ns) => cppwr_ns
  rule convSubRegsToRegs(mvfr1) => mvfr1
  rule convSubRegsToRegs(fpccr) => fpccr
  rule convSubRegsToRegs(fpccr_ns) => fpccr_ns
  rule convSubRegsToRegs(fpccr_s) => fpccr_s
  rule convSubRegsToRegs(vpr) => vpr
  rule convSubRegsToRegs(epsr) => epsr
  */
  
  /*@
    Getting the registers values according to the register variants.
  */
  rule getRegisterValue(R:R32,  RSMap)  =>  extractMask({RSMap[convToRegKeys(R)]}:>MInt, 32, 0)
  rule getRegisterValue(R:S32, RSMap)  =>  extractMask({RSMap[convToRegKeys(R)]}:>MInt, 32, 0)
  // rule getRegisterValue(R:MRegs, RSMap) => extractMask({RSMap[convToRegKeys(R)]}:>MInt, 32, 0)
  rule getRegisterValue(R:VirtualReg, RSMap) => extractMask({RSMap[convToRegKeys(R)]}:>MInt, 32, 0)  requires (R ==K result)
  rule getRegisterValue(R:VirtualReg, RSMap) => extractMask({RSMap[convToRegKeys(R)]}:>MInt, 64, 0)  requires (R ==K result64)
  
  rule getRegisterValue(R:D64, RSMap) => extractMask({RSMap[convToRegKeys(R)]}:>MInt, 64, 0)
  
  rule getRegisterValue(R:Q128, RSMap) => extractMask({RSMap[convToRegKeys(R)]}:>MInt, 128, 0)
  
  rule getParentValue(R:Register, RSMap) => getRegisterValue(convSubRegsToRegs(R), RSMap)
  
  rule getVecParentValue(R:Q128, I:Beat, RSMap) => getRegisterValue(convSubVecRegsToRegs(R, I), RSMap)
  rule getVecParentValue(R:D64, I:Beat, RSMap) => getRegisterValue(convSubVecRegsToRegs(R, I), RSMap)
  
  /*@
    Imm convert to MInt
  */
  
  // let Imm < 32b
  rule modImm32((# I:Int):Imm) => I modInt (2 ^Int 32) requires I >=Int (2 ^Int 32)
  rule modImm32((# I:Int):Imm) => I modInt (-2 ^Int 31) requires I <Int (-2 ^Int 31)
  rule modImm32((# I:Int):Imm) => I requires ( (-2 ^Int 31) <=Int I  andBool I <Int (2 ^Int 32)) 
  
  // let Imm < 64b
  rule modImm64((# I:Int):Imm) => I modInt (2 ^Int 64) requires I >=Int (2 ^Int 64)
  rule modImm64((# I:Int):Imm) => I modInt (-2 ^Int 63) requires I <Int (-2 ^Int 63)
  rule modImm64((# I:Int):Imm) => I requires I <Int (2 ^Int 64) andBool I >=Int (-2 ^Int 63)
  
  //when imm is bigger than 2^128, mod imm
  rule modImm128((# I:Int):Imm) => I modInt (2 ^Int 128) requires I >=Int (2 ^Int 128)
  rule modImm128((# I:Int):Imm) => I modInt (-2 ^Int 127) requires I <Int (-2 ^Int 127)
  rule modImm128((# I:Int):Imm) => I requires I <Int (2 ^Int 128) andBool I >=Int (-2 ^Int 127)
  
  // Int
  rule Imm2MInt((# I:Int):Imm, M:Int, N:Int) => zeroExtend(mi(M, modImm128(# I)), N)
       requires I >=Int (2 ^Int 128)
  
  rule Imm2MInt((# I:Int):Imm, M:Int, N:Int) => zeroExtend(mi(M, I), N)
       requires I <Int (2 ^Int 128)
  // Hexconst                                       
  syntax String ::= HexConstant2String ( HexInt )    [function, hook(STRING.token2string)]
  rule Imm2MInt((H:HexInt):Imm, M:Int, N:Int) =>
    zeroExtend(mi(M, String2Base(substrString(HexConstant2String(H), 3, lengthString(HexConstant2String(H))), 16)), N)
    
  /*@ 
    Check if two registers are the same
  */
  /*  
  rule sameRegisters(R1:Register, R2:Register) =>  convToRegKeys(R1) ==String  convToRegKeys(R2)
  rule sameRegisters(R1:Register, S2:String)   =>  convToRegKeys(R1) ==String  S2
  */
  
  /*@ 
    Update Register's value at arbitrary position.
  */
  /*  
  rule <k> setRegisterBitsAtPositon(MInew, R, P) => . ...</k>
    <regstate>... convToRegKeys(R, I) |-> ( MIold => plugInMask(MIold, MInew, P)) ...</regstate>
  */
  
  /*@ 
    getRegisterBitsAtPositon(R, P, N) 
      Returns N bits of input register  R starting at 
    position P.
  */  
  rule getRegisterBitsAtPositon(R, N, P, RSMap) => extractMask(getRegisterValue(R, RSMap), N, P) 
  
  /*@ 
    Get Register size based on the variant used.
  */  
  rule getRegisterSize(R:R32)  => 32
  rule getRegisterSize(R:Q128)  => 128
  
  /*
  rule defaultRegs(S:Label) => setdRegs( S )
  
  rule <k> 
         setDefaultRegs(S:Label) => defaultRegs(S)
       </k>
  */
  
  rule getReg(RName, RSMap) => {RSMap[RName]}:>MInt
  
  rule getRegI(RName, RSMap) => {RSMap[RName]}:>Int
  
  /*@
    for the R and Q register fp command to get the minimum one
  */
  
  rule LeftMinMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (concatenateMInt(mi(8, 126), mi(8, 0))) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) orBool (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))))) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      ( MI2 ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      MI2 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI1) else (MI2) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (MI2) else (MI1) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI1) else (MI2) )
    // TODO: need to modify 
    else (ifMInt (MInt2Float(MI1, 11, 5) >=Float MInt2Float(MI2, 11, 5)) then 
      (MI2) 
    else (MI1) 
    ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule LeftMinMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) orBool (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) then 
      //( MI2 ) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1,1), mi(31,0)))) 
      else (MI2))
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0))))) then 
      //(MI1) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1,1), mi(31,0)))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) then 
      //MI2 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1,1), mi(31,0)))) 
      else (MI2))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) then 
      //(MI1) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1,1), mi(31,0)))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI1) else (MI2) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (MI2) else (MI1) )  
    // Denormalize
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1, 0), mi(31, 0))) )
    else ( ifMInt ( (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool (eqMInt(extractMInt(MI2, 0, 1), mi(1,0)))) then 
      ( concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0)) )
    else ( ifMInt ( (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool (eqMInt(extractMInt(MI1, 0, 1), mi(1,0)))) then 
      (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0)))
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 24, 8) >=Float MInt2Float(MI2, 24, 8)) then 
      (MI2)  
    else (MI1)  
    ) ) ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)
  
  /*@
    for the R and Q register fp command to get the maximum one, vmaxnmv
  */
  
  rule LeftMaxMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt /*S S*/ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(8, 126), mi(8, 0))) 
    else (ifMInt /* S Q */ ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) orBool (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))))) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt /* Q Q */ ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt /* S */ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      ( MI2 ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      MI2 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI2) else (MI1) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (MI1) else (MI2) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI2) else (MI1) ) 
    else (ifMInt (MInt2Float(MI1, 11, 5) <=Float MInt2Float(MI2, 11, 5)) then 
      (MI2) 
    else (MI1) 
      ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule LeftMaxMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) orBool (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) then 
      //( MI2 ) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI2))
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0))))) then 
      //(MI1) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) then 
      // MI2 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI2))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) then 
      // MI1
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI2) else (MI1) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (MI1) else (MI2) ) 
    // Denormalize
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (concatenateMInt(mi(1, 0), mi(31, 0))) )
    else ( ifMInt ( (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool (eqMInt(extractMInt(MI2, 0, 1), mi(1,1)))) then 
      ( concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0)) )
    else ( ifMInt ( (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool (eqMInt(extractMInt(MI1, 0, 1), mi(1,1)))) then 
      (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0)))
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 24, 8) <=Float MInt2Float(MI2, 24, 8)) then 
      (MI2) 
    else (MI1) 
      ) ) ) ) ) ) ) ) ) ) ) ) )
        requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)
  
  /*@
    maximum: for the one absolute and the other not absolute, like vmaxnmav
  */
  rule LeftAbsMaxMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (concatenateMInt(mi(8, 126), mi(8, 0))) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) orBool (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))))) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      ( MI2 ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      MI2 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI2) else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16)) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) then 
      (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 16)))
    // TODO: need to modify
    else (ifMInt (absFloat(MInt2Float(MI1, 11, 5)) <=Float MInt2Float(MI2, 11, 5)) then 
      (MI2) 
    else (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 16)) 
      ) ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule LeftAbsMaxMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) )
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) orBool (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) then 
      //( MI2 ) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (MI2))
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0))))) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) then 
      // MI2 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (MI2))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (MI2) else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) )  
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32)) ) 
    // Denormalize
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      (concatenateMInt(mi(1,0),mi(31,0)))
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool eqMInt(extractMInt(MI2, 0, 1), mi(1,1))) then
      (mi(32, 0))
    // TODO: need to modify 
    else (ifMInt (absFloat(MInt2Float(MI1, 24, 8)) <=Float MInt2Float(MI2, 24, 8)) then 
      (MI2) 
    else (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 32))) 
    ) ) ) ) ) ) ) ) ) ) ) )
    requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)
  
  
  /*@
    minimum: for the one absolute and the other not absolute, like vminnmav
    MI1 is source operand, MI2 is destination operand.
  */
  rule LeftAbsMinMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt /* two SNaN */(((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (concatenateMInt(mi(8, 126), mi(8, 0))) 
    else (ifMInt /* SNaN and QNaN */ ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) orBool (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))))) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt /* two QNaN */ ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt /* SNaN and not NaN */ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      ( MI2 ) 
    else (ifMInt /* SNaN and not NaN */ ((((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt /* QNaN and not NaN */ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      MI2 
    else ( ifMInt /* QNaN and not NaN */ (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt /* Infinity */ (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16)))  else (MI2) )
    else (ifMInt /* Infinity */ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI2) 
    else (ifMInt /* 0 and 0 */ (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) then 
      (MI2) 
    // need to be modify
    else (ifMInt /* normal */ (absFloat(MInt2Float(MI1, 11, 5)) >=Float MInt2Float(MI2, 11, 5)) then 
      (MI2) 
    else (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 16)) 
      ) ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule LeftAbsMinMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt /* two SNaN */ (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt /* SNaN and QNaN */ ((((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) orBool (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) andBool ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt /* two QNaN */ (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))))) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt /* SNaN and not NaN */ ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) then 
      //( MI2 ) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (MI2))
    else (ifMInt /* SNaN and not NaN */ (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0))))) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt /* QNaN and not NaN */ ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) then 
      //MI2 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (MI2))
    else ( ifMInt /* QNaN and not NaN */ ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (mi(32, 0))
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt /* Infinity */ ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) else (MI2) ) 
    else (ifMInt /* Infinity */ ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)))) then 
      (MI2) 
    // Denormalized
    else (ifMInt /* 0 and 0 */ (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0)))
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) andBool eqMInt(extractMInt(MI2, 0, 1), mi(1, 0)) ) then
      (mi(32, 0))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1)))) then
      concatenateMInt(extractMInt(MI2,0,1), mi(31,0))
    // need to be modify
    else (ifMInt (absFloat(MInt2Float(MI1, 24, 8)) >=Float MInt2Float(MI2, 24, 8)) then 
      (MI2) 
    else (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 32))
      ) ) ) ) ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)
  
  /*@
    get the maximum absolute MInt of float
  */
  rule AbsMaxMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt /*Q Q*/ ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 16))) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 16)) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool ugtMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (concatenateMInt(mi(1,0),extractMInt(MI2, 1, 16)))
    // need to modify
    else (ifMInt (absFloat(MInt2Float(MI1, 11, 5)) <=Float absFloat(MInt2Float(MI2, 11, 5))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 16))) 
    else (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 16)))
       ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule AbsMaxMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else ( ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1))) ) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        mi(32, 0)
      else (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32))))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))) ) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        mi(32, 0)
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32)) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
    // Denormalized
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) andBool ugtMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (concatenateMInt(mi(1, 0), mi(31, 0))) 
    // need to modify
    else (ifMInt (absFloat(MInt2Float(MI1, 24, 8)) <=Float absFloat(MInt2Float(MI2, 24, 8))) then 
      (concatenateMInt(mi(1, 0), extractMInt(MI2, 1, 32))) 
    else (concatenateMInt(mi(1, 0), extractMInt(MI1, 1, 32)))
     ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)

  /*@
    get the maximum MInt of float
  */
  rule MaxMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI2) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (MI1) else (MI2) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (MI2) else (MI1) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool ugtMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (MI2) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool uleMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (MI1) 
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 11, 5) <=Float MInt2Float(MI2, 11, 5)) then 
      (MI2) 
    else (MI1) 
      ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule MaxMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else ( ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1))) ) then 
      //(MI2) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI2))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))) ) then 
      //(MI1) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else (mi(32, 0))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (MI1) else (MI2) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0))) ) then 
      (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (MI2) else (MI1) ) 
    // Denormalized
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      (concatenateMInt(mi(1, uvalueMInt(extractMInt(MI1,0,1)) &Int uvalueMInt(extractMInt(MI2, 0, 1))), mi(31,0)))  
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool eqMInt(extractMInt(MI2, 0, 1), mi(1,1)) ) then 
      (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool eqMInt(extractMInt(MI1, 0, 1), mi(1,1)) ) then
      (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0)))
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 24, 8) <=Float MInt2Float(MI2, 24, 8)) then 
      (MI2) 
    else (MI1) 
      ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)
  
  /*@
    get the minimum absolute MInt of float
  */
  rule AbsMinMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 16))) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16)) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 16)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool ugtMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (concatenateMInt(mi(1,0),extractMInt(MI1, 1, 16))) 
    // TODO: need to modify
    else (ifMInt (absFloat(MInt2Float(MI1, 11, 5)) <=Float absFloat(MInt2Float(MI2, 11, 5))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 16))) 
    else (concatenateMInt(mi(1,0),extractMInt(MI2, 1, 16))) 
      ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule AbsMinMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else ( ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1))) ) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        mi(32, 0)
      else (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32))))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))) ) then 
      //(concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        mi(32, 0)
      else (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32))))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      (concatenateMInt(mi(1,0), extractMInt(MI1, 1, 32)) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0))) ) then 
      (concatenateMInt(mi(1,0), extractMInt(MI2, 1, 32))) 
    // Denormalized
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) orBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      (concatenateMInt(mi(1,0), mi(31,0))) 
    // TODO: need to modify
    else (ifMInt (absFloat(MInt2Float(MI1, 24, 8)) <=Float absFloat(MInt2Float(MI2, 24, 8))) then 
      (concatenateMInt(mi(1, 0), extractMInt(MI1, 1, 32))) 
    else (concatenateMInt(mi(1, 0), extractMInt(MI2, 1, 32)))
       ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)

  /*@
    get the minimum MInt of float
  */
  rule MinMIntOfFP(MI1:MInt, MI2:MInt, 16, RSMap:Map) => 
    (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI1, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI1, 6, 7), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(MI2, 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(MI2, 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( concatenateMInt(mi(8, 126), mi(8, 0)) ) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI2) 
    else ( ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 7), mi(1, 1)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (MI1) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (MI2) else (MI1) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int MaxExponentBits(5)) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0)))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then 
      (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (MI1) else (MI2) ) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool ugtMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (MI1) 
    else (ifMInt ((((uvalueMInt(extractMInt(MI1, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 6, 16), mi(10, 0))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 6)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 6, 16), mi(10, 0))) ) ) andBool uleMInt(extractMInt(MI1, 0, 1), extractMInt(MI2, 0, 1)) ) then 
      (MI2) 
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 11, 5) <=Float MInt2Float(MI2, 11, 5)) then 
      (MI1) 
    else (MI2)
     ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 16) andBool (bitwidthMInt(MI2) ==Int 16)
  
  /**
    modified
    */
  rule MinMIntOfFP(MI1:MInt, MI2:MInt, 32, RSMap:Map) => 
    (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI1, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI1, 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(MI2, 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(MI2, 9, 10), mi(1,0)))) ) then 
      ( concatenateMInt(mi(8, 127), concatenateMInt(mi(8, 192), concatenateMInt(mi(8, 0), mi(8, 0)))) ) 
    else ( ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 10), mi(1, 1))) ) then 
      //(MI2) 
      (ifMInt (uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI1, 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
      else (MI2))
    else ( ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 10), mi(1, 1))) ) then 
      //(MI1) 
      (ifMInt (uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) then 
        (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(MI2, 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
      else (MI1))
    else (ifMInt ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)))) then 
      ( ifMInt (eqMInt(extractMInt(MI2, 0, 1), mi(1, 1))) then (MI2) else (MI1) ) 
    else (ifMInt ((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int MaxExponentBits(8)) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0))) ) then 
      (ifMInt (eqMInt(extractMInt(MI1, 0, 1), mi(1, 1))) then (MI1) else (MI2) ) 
    // Denormalized
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool ((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
      (concatenateMInt(mi(1, uvalueMInt(extractMInt(MI1,0,1)) |Int uvalueMInt(extractMInt(MI2, 0, 1))), mi(31,0)))
    else (ifMInt (((uvalueMInt(extractMInt(MI1, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI1, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool eqMInt(extractMInt(MI2,0,1), mi(1,0)) ) then 
      (concatenateMInt(extractMInt(MI1,0,1), mi(31,0))) 
    else (ifMInt (((uvalueMInt(extractMInt(MI2, 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(MI2, 9, 32), mi(23, 0)) orBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) andBool eqMInt(extractMInt(MI1,0,1), mi(1,0)) ) then
      (concatenateMInt(extractMInt(MI2,0,1), mi(31,0)))
    // TODO: need to modify
    else (ifMInt (MInt2Float(MI1, 24, 8) <=Float MInt2Float(MI2, 24, 8)) then 
      (MI1) 
    else (MI2) 
      ) ) ) ) ) ) ) ) ) )
      requires (bitwidthMInt(MI1) ==Int 32) andBool (bitwidthMInt(MI2) ==Int 32)

  /*@
    Get the Maximum one of two Int of MInt
  */
  rule MaxMIntOfInt(MI1:MInt, MI2:MInt, I:Int, S:Label, RSMap:Map) => 
    ( ifMInt (((S ==K S8) orBool (S ==K S16)) orBool (S ==K S32)) then 
      ( ifMInt (svalueMInt(MI1) <=Int svalueMInt(MI2)) then (MI2) else (MI1) ) 
    else ( ifMInt (((S ==K U8) orBool (S ==K U16)) orBool (S ==K U32)) then 
      (ifMInt (uvalueMInt(MI1) <=Int uvalueMInt(MI2)) then (MI2) else (MI1) ) 
    else (mi(I, -1)) 
      ) )
      requires (bitwidthMInt(MI1) ==Int I) andBool (bitwidthMInt(MI2) ==Int I)
  
  rule LeftAbsMaxMIntOfInt(MI1:MInt, MI2:MInt, I:Int, RSMap:Map) => 
    ( ifMInt (absInt(svalueMInt(MI1)) <=Int uvalueMInt(MI2)) then 
      (MI2) 
    else (mi(I, absInt(svalueMInt(MI1)))) 
      )
      requires (bitwidthMInt(MI1) ==Int I) andBool (bitwidthMInt(MI2) ==Int I)
  
  /*@
    Get the Minimun one of two Int of MInt, MI1 is the source operand,
    MI2 is the destination operand.
  */
  rule MinMIntOfInt(MI1:MInt, MI2:MInt, I:Int, S:Label, RSMap:Map) => 
    ( ifMInt (((S ==K S8) orBool (S ==K S16)) orBool (S ==K S32)) then 
      ( ifMInt (svalueMInt(MI1) >=Int svalueMInt(MI2)) then (MI2) else (MI1) ) 
    else ( ifMInt (((S ==K U8) orBool (S ==K U16)) orBool (S ==K U32)) then 
      (ifMInt (uvalueMInt(MI1) >=Int uvalueMInt(MI2)) then (MI2) else (MI1) ) 
    else (mi(I, -1)) 
      ) )
      requires (bitwidthMInt(MI1) ==Int I) andBool (bitwidthMInt(MI2) ==Int I)
  
  rule LeftAbsMinMIntOfInt(MI1:MInt, MI2:MInt, I:Int, RSMap:Map) => 
    ( ifMInt (absInt(svalueMInt(MI1)) >=Int uvalueMInt(MI2)) then 
      (MI2) 
    else (mi(I, absInt(svalueMInt(MI1))))
     )
      requires (bitwidthMInt(MI1) ==Int I) andBool (bitwidthMInt(MI2) ==Int I)
  
  /*@
    get the multiply of MInt
  */
  /*
  rule uMulofInt8(MI1:MInt, MI2:MInt) => mi(64, ( (uvalueMInt(extractMInt(MI1, 24, 32)) *Int uvalueMInt(extractMInt(MI2, 24, 32))) +Int (uvalueMInt(extractMInt(MI1, 16, 24)) *Int uvalueMInt(extractMInt(MI2, 16, 24))) +Int (uvalueMInt(extractMInt(MI1, 8, 16)) *Int uvalueMInt(extractMInt(MI2, 8, 16))) +Int (uvalueMInt(extractMInt(MI1, 0, 8)) *Int uvalueMInt(extractMInt(MI2, 0, 8))) ) )
  
  rule uMulofInt16(MI1:MInt, MI2:MInt) => mi(64, ( (uvalueMInt(extractMInt(MI1, 0, 16)) *Int uvalueMInt(extractMInt(MI2, 0, 16))) +Int (uvalueMInt(extractMInt(MI1, 16, 32)) *Int uvalueMInt(extractMInt(MI2, 16, 32))) ) )
  
  rule uMulofInt32(MI1:MInt, MI2:MInt) => mi(64, ( (uvalueMInt(extractMInt(MI1, 0, 32)) *Int uvalueMInt(extractMInt(MI2, 0, 32))) ) )
  
  rule sMulofInt8(MI1:MInt, MI2:MInt) => mi(64, ( (svalueMInt(extractMInt(MI1, 24, 32)) *Int svalueMInt(extractMInt(MI2, 24, 32))) +Int (svalueMInt(extractMInt(MI1, 16, 24)) *Int svalueMInt(extractMInt(MI2, 16, 24))) +Int (svalueMInt(extractMInt(MI1, 8, 16)) *Int svalueMInt(extractMInt(MI2, 8, 16))) +Int (svalueMInt(extractMInt(MI1, 0, 8)) *Int svalueMInt(extractMInt(MI2, 0, 8))) ) )
  
  rule sMulofInt16(MI1:MInt, MI2:MInt) => mi(64, ( (svalueMInt(extractMInt(MI1, 0, 16)) *Int svalueMInt(extractMInt(MI2, 0, 16))) +Int (svalueMInt(extractMInt(MI1, 16, 32)) *Int svalueMInt(extractMInt(MI2, 16, 32))) ) )
  
  rule sMulofInt32(MI1:MInt, MI2:MInt) => mi(64, ( (svalueMInt(extractMInt(MI1, 0, 32)) *Int svalueMInt(extractMInt(MI2, 0, 32))) ) )
  */

  rule uMulofInt8(MI1:MInt, MI2:MInt) => ( (uvalueMInt(extractMInt(MI1, 24, 32)) *Int uvalueMInt(extractMInt(MI2, 24, 32))) +Int (uvalueMInt(extractMInt(MI1, 16, 24)) *Int uvalueMInt(extractMInt(MI2, 16, 24))) +Int (uvalueMInt(extractMInt(MI1, 8, 16)) *Int uvalueMInt(extractMInt(MI2, 8, 16))) +Int (uvalueMInt(extractMInt(MI1, 0, 8)) *Int uvalueMInt(extractMInt(MI2, 0, 8))) ) 
  
  rule uMulofInt16(MI1:MInt, MI2:MInt) => ( (uvalueMInt(extractMInt(MI1, 16, 32)) *Int uvalueMInt(extractMInt(MI2, 16, 32))) +Int (uvalueMInt(extractMInt(MI1, 0, 16)) *Int uvalueMInt(extractMInt(MI2, 0, 16))) )
  
  rule uMulofInt32(MI1:MInt, MI2:MInt) => ( (uvalueMInt(extractMInt(MI1, 0, 32)) *Int uvalueMInt(extractMInt(MI2, 0, 32))) )
  
  rule sMulofInt8(MI1:MInt, MI2:MInt) => ( (svalueMInt(extractMInt(MI1, 24, 32)) *Int svalueMInt(extractMInt(MI2, 24, 32))) +Int (svalueMInt(extractMInt(MI1, 16, 24)) *Int svalueMInt(extractMInt(MI2, 16, 24))) +Int (svalueMInt(extractMInt(MI1, 8, 16)) *Int svalueMInt(extractMInt(MI2, 8, 16))) +Int (svalueMInt(extractMInt(MI1, 0, 8)) *Int svalueMInt(extractMInt(MI2, 0, 8))) )
  
  rule sMulofInt16(MI1:MInt, MI2:MInt) => ( (svalueMInt(extractMInt(MI1, 16, 32)) *Int svalueMInt(extractMInt(MI2, 16, 32))) +Int (svalueMInt(extractMInt(MI1, 0, 16)) *Int svalueMInt(extractMInt(MI2, 0, 16))) ) 
  
  rule sMulofInt32(MI1:MInt, MI2:MInt) => ( (svalueMInt(extractMInt(MI1, 0, 32)) *Int svalueMInt(extractMInt(MI2, 0, 32))) )

  
endmodule
