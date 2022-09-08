require "armv8-syntax.k"

module ARMV8-ABSTRACT-SYNTAX
  imports MAP
  imports MINT
  imports STRING
  imports ARMV8-SYNTAX-SORTS
  
  syntax Ptm ::= memloc(MInt)
  syntax MInt ::= Ptm
 
  
  syntax CodeInMemory ::= code(/*Memloc -> storeInstr(Instruction)*/ Map)
  
  syntax AbsCommand ::= storedInstr(Instruction)
  syntax AbsCommand ::= execinstrBeat(Instruction, Int)
  			/*
                      | execinstr1Beat(Instruction, Int)
                      | execinstr2Beat(Instruction)
                      | execinstr3Beat(Instruction)
                      | execinstr4Beat(Instruction)
                      */
                      | execinstr(Instruction)
  syntax AbsCommand ::= setDefaultRegs(Opcode)
  syntax AbsCommand ::= beatResult(Instruction, Int)
  			/*
                      | beat1Result(Instruction, Int)
                      | beat2Result(Instruction)
                      | beat3Result(Instruction)
                      | beat4Result(Instruction)
                      */
  
  syntax MInt ::= getReg(String, Map) [function]
  
  syntax Int ::= getRegI(String, Map) [function]
  
  syntax Beat ::= Int
  
  syntax KItem ::= "scan" [token]
                 | "loadBegin"
                 | "registersMessage" [token]
                 
  /*
  syntax KItem ::= setDefaultRegs(Label) [function]
                 | defaultRegs(Label) [strict]
  
  syntax SetdRegs ::= setdRegs ( Label )
  */
  
  /*@
    Sub registers to Registers
  */
  syntax Register ::= convSubRegsToRegs(Register) [function]
                    | convSubVecRegsToRegs(Register, Beat) [function]
  
  /*@
    Translate register to Regstate keys
  */
  syntax String ::= convToRegKeys(Register) [function]
                  | convToRegKeysHelper(Register) [function]
                  | convVecToRegKeys(Register, Beat) [function]
  
  syntax KItem ::= setRegisterValue(KItem, Register) [strict(1)]
  
  syntax KResult ::= MInt
  
  /*@
    Setting the Parent register's values.
      Ex. setParentValue(MI, s0) -> set MI to lowest 32bit of q0
  */  
  syntax MInt  ::= setParentValue(KItem, Register) [strict(1)]
  
  /*@
    Getting the registers values.
      Ex. getRegisterValue(s0) -> 0-31 bits of s0
      Ex. getRegisterValue(r0) -> 0-31 bits of r0
  */  
  syntax MInt  ::= getRegisterValue(Register, Map) [function]
  
  
  /*@
    Getting the Parent register's values.
      Ex. getParentValue(r0) -> 32 bits of r0
      Ex. getVecParentValue(q0, 0) -> 32 bits of s0
      Ex. getVecParentValue(q0, 1) -> 32 bits of s1
      Ex. getVecParentValue(q0, 2)-> 32 bits of s2
      Ex. getVecParentValue(q0, 3)-> 32 bits of s3
      Ex. getVecParentValue(d0, 1)-> 32 bits of s1
  */  

  syntax MInt  ::= getParentValue(Register, Map) [function]
                 | getVecParentValue(Register, Beat, Map) [function]
  /*@
    Imm convert to MInt
  */
  syntax MInt ::= Imm2MInt(Imm, Int, Int) [function]
  syntax Int  ::= modImm128(Imm)  [function]
                | modImm32(Imm)   [function]
                | modImm64(Imm)   [function]
  
  /*@ 
    Check if two registers are the same
  */  
  syntax Bool ::= sameRegisters(Register, Register) [function, klabel(registerargs)]
  syntax Bool ::= sameRegisters(Register, String) [function, klabel(nonregisterargs)]
  
  /*@ 
    setRegisterBitsAtPositon(MI, R, P) 
      Update bitwidthMInt(MI) bits of input register  R starting at 
    position P.
  */  
  syntax MInt ::= setRegisterBitsAtPositon(MInt, Register, Int)
  
  /*@ 
    getRegisterBitsAtPositon(R, P, N) 
      Returns N bits of input register  R starting at 
    position P.
  */  
  syntax MInt ::= getRegisterBitsAtPositon(Register, Int, Int, Map) [function]
  
  /*@ 
    Get Register size based on the variant used.
  */  
  syntax Int ::= getRegisterSize(Register) [function]
  
  /*@
    get the maximum MInt of 2 Float
  */
  syntax MInt ::= AbsMaxMIntOfFP(MInt, MInt, Int, Map)	[function]
                | MaxMIntOfFP(MInt, MInt, Int, Map)		[function]
                | AbsMinMIntOfFP(MInt, MInt, Int, Map)  [function]
                | MinMIntOfFP(MInt, MInt, Int, Map)   [function]
                | LeftAbsMaxMIntOfFP(MInt, MInt, Int, Map)	[function]
                | LeftAbsMinMIntOfFP(MInt, MInt, Int, Map)	[function]
                | LeftMaxMIntOfFP(MInt, MInt, Int, Map)	[function]
                | LeftMinMIntOfFP(MInt, MInt, Int, Map)	[function]
  
  /*@
    get the maximun MInt of 2 Int
  */
  syntax MInt ::= MaxMIntOfInt(MInt, MInt, Int, Label, Map)		[function]
               | LeftAbsMaxMIntOfInt(MInt, MInt, Int, Map)	[function]	// for R and Q
               | MinMIntOfInt(MInt, MInt, Int, Label, Map)	[function]
               | LeftAbsMinMIntOfInt(MInt, MInt, Int, Map)	[function]
  
  /*@
    get the multiply of MInt
  */
  syntax MInt ::= uMulofInt8(MInt, MInt)	[function]
                | uMulofInt16(MInt, MInt)	[function]
                | uMulofInt32(MInt, MInt)	[function]
                | sMulofInt8(MInt, MInt)	[function]
                | sMulofInt16(MInt, MInt)	[function]
                | sMulofInt32(MInt, MInt)	[function]
  
  
endmodule
