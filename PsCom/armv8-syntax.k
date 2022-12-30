/*
   ARMv8.1-M instruction syntax
*/

module ARMV8-SYNTAX-SORTS	// sorts of armv8.1-m
  syntax Opcode
  syntax Imm
  syntax Register
  syntax MRegs
  syntax R32
  syntax Q128
  syntax S32
  syntax D64
  syntax Label
  syntax Operand
  syntax Operands
  syntax Instruction
  syntax Instructions
  syntax Builtin
  syntax Start
  syntax Beginp
  syntax StepCommand
  //syntax Lane
  syntax Idx
endmodule

module ARMV8-SYNTAX
  imports ARMV8-SYNTAX-SORTS
  imports INT
  imports BOOL
  imports FLOAT
  imports STRING
  imports MINT
  imports ID
  
  /*
    Captures the Assembly syntax instructions of ARMv8.1-M, 
    example: VMAX<v>.<dt> Qd, Qn, Qm
    <v> dose not affect the encode
  */
  syntax Opcode ::= "VMAX"		[token]
                  | "VMAXA"		[token]
                  | "VMAXNM"		[token]
                  | "VMAXNMA"		[token]
                  | "VMAXNMV"		[token]
                  | "VMAXNMAV"	[token]
                  | "VMAXV"		[token]
                  | "VMAXAV"		[token]
                  | "VMIN"		[token]
                  | "VMINA"		[token]
                  | "VMINNM"		[token]
                  | "VMINNMA"		[token]
                  | "VMINNMV"		[token]
                  | "VMINNMAV"	[token]
                  | "VMINV"		[token]
                  | "VMINAV"		[token]
                  | "VMLAV"		[token]
                  // VMLAVA is VMLAV{A} format
                  | "VMLAVA"		[token]

  
  syntax Opcode ::= "end"
                  | "VMOV"		[token]
                  | "MOV"		[token]
                  | "ADD"		[token] //for test
                  | "MAX"		[token]
                  // add for prove
                  | "VADD"  [token]
                  | "VMUL"  [token]
                  | "VSUB"  [token]
                  | "VSHR"  [token]
                  | "VSHL"  [token]
                  | "VORR"  [token]
                  | "VAND"  [token]
                  | "VQADD" [token]       // fpscr
                  | "VDUP"  [token]
                  | "VNEG"  [token]
                  | "VMLA"  [token]       
                  | "VRSHL" [token]
                  | "VQRDMULH"  [token]   // fpscr

                 
  syntax Register ::= R32
                    | Q128
                    | S32
                    | D64
                    | MRegs
                    | VirtualReg
  
  syntax MRegs ::= "control"
                 | "control_s"
                 | "control_ns"
                 | "cpacr"
                 | "cpacr_s"
                 | "cpacr_ns"
                 | "nsacr"
                 | "cppwr"
                 | "cppwr_s"
                 | "cppwr_ns"
                 | "mvfr1"
                 | "fpccr"
                 | "fpccr_s"
                 | "fpccr_ns"
                 | "vpr"
                 | "epsr"
                 | "fpscr"
  
  syntax VirtualReg ::= "result"
  		       | "result64"

  syntax R32 ::= "r0"
               | "r1"
               | "r2"
               | "r3"
               | "r4"
               | "r5"
               | "r6"
               | "r7"
               | "r8"
               | "r9"
               | "r10"
               | "r11"
               | "r12"		// r0-r12 general
               | "r13"		// SP
               | "r14"		// LR
               | "r15"		// PC
               
  syntax Q128 ::= "q0"		// vector
                | "q1"
                | "q2"
                | "q3"
                | "q4"
                | "q5"
                | "q6"
                | "q7"
                
  syntax Idx ::= Int
  //syntax Lane ::= Q128 "[" Idx "]"
  //syntax Q128 ::= Lane
  syntax Q128 ::= Q128 "[" Idx "]"
  
  syntax S32 ::= "s0"
               | "s1"
               | "s2"
               | "s3"
               | "s4"
               | "s5"
               | "s6"
               | "s7"
               | "s8"
               | "s9"
               | "s10"
               | "s11"
               | "s12"
               | "s13"
               | "s14"
               | "s15"
               | "s16"
               | "s17"
               | "s18"
               | "s19"
               | "s20"
               | "s21"
               | "s22"
               | "s23"
               | "s24"
               | "s25"
               | "s26"
               | "s27"
               | "s28"
               | "s29"
               | "s30"
               | "s31"
  
  syntax D64 ::= "d0"
               | "d1"
               | "d2"
               | "d3"
               | "d4"
               | "d5"
               | "d6"
               | "d7"
               | "d8"
               | "d9"
               | "d10"
               | "d11"
               | "d12"
               | "d13"
               | "d14"
               | "d15"
  
  syntax HexInt ::= r"#0x[0-9a-fA-F]+"	[token]
  
  syntax Imm ::= "#" Int
               | HexInt
  
  // <dt>
  syntax String ::= Label
  syntax Label ::= "S8"
                 | "S16"
                 | "S32"
                 | "U8"
                 | "U16"
                 | "U32"
                 | "F16"
                 | "F32"
                 | "F64"
                 | "I8"
                 | "I16"
                 | "I32"
                 | Int
                 
  // for store to vector lane.
  syntax NLabel ::= "$" Int
  
                 
  syntax Start ::= "start" [token]
  syntax Beginp ::= Start ":"
  
  syntax Operand ::= Register
                   | Imm
  
  syntax Operands ::= List{Operand, ","}
  
  syntax Instruction ::= Opcode "." Label Operands
                       | Opcode Operands
                       | Beginp
                       | Opcode "." NLabel Operands
  
  syntax Instructions ::= List{Instruction, ""} [klabel(instructionlist)]
  
  // add for check
  syntax StepCommand ::= "sst"		[token]
                       | "ext"		[token]
                       | "dtc"		[token]
                       | "cmp"		[token]
                       | "sto"		[token]
                       | "conca"  [token]
                       | "sint"   [token]
                       | "uint"   [token]
                       | "maa"    [token]
                       | "cmpAbs" [token]
  
  syntax Opcode ::= StepCommand
  
endmodule
