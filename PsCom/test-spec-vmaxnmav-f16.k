/*
  loop
*/

require "armv8-semantics.k"

module TEST-SPEC-VMAXNMAV-F16

  imports ARMV8-SEMANTICS

  rule <k>
         scan => End
       </k>
       <begin>
         .K
       </begin>
       <currentstate>
         "text"
       </currentstate>
       <nextloc>
         _:MInt
       </nextloc>
       <functarget>
         start |-> mi(32, 0)
       </functarget>
       <instructiontext>
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMOV q0 , (# N:Int):Imm , .Operands )
         memloc(mi(32, 1)) |-> storedInstr ( MOV r0 , (# 0):Imm , .Operands )
         memloc(mi(32, 2)) |-> storedInstr ( VMAXNMAV . F16 r0 , q0 , .Operands )
         memloc(mi(32, 3)) |-> storedInstr ( end .Operands ) )
       </instructiontext>
       <regstate>
         "CONTROL" |-> (mi(32, _:Int) => mi(32, 1))
         "CONTROL_NS" |-> (mi(32, _:Int) => mi(32, 1))
         "CONTROL_S" |-> (mi(32, _:Int) => mi(32, 1))
         "CPACR" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPACR_NS" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPACR_S" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPPWR" |-> (mi(32, _:Int) => mi(32, 0))
         "CPPWR_NS" |-> (mi(32, _:Int) => mi(32, 0))
         "CPPWR_S" |-> (mi(32, _:Int) => mi(32, 0))
         "EPSR" |-> (mi(32, _:Int) => mi(32, 2048))
         "FPCCR" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPCCR_NS" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPCCR_S" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPSCR" |-> ( mi(32, _:Int) => mi(32, _:Int) )
         "MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
         "NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
         "Q0" |-> mi(128, N)
         "S0" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 96, 128))
         "S1" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 64, 96))
         "S2" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 32, 64))
         "S3" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 0, 32))
         "R0" |-> /* (mi(32, _:Int) => mi(32, E:Int) ) */ (mi(32, _:Int) => mi(32, _:Int) )
         "RESULT" |-> ( mi(32, _:Int) => mi(32, _:Int) )
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 4)))
         "RESULT64" |-> mi(64, 0)
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
       </regstate>
         requires 0 <=Int N
           andBool (2 ^Int 128) >Int N 
           //andBool F >=Int 0
           //andBool F <Int (2 ^Int 32)
           //andBool E >=Int 0
           //andBool E <Int (2 ^Int 32)
           /*andBool 0 <=Int Z
           andBool (2 ^Int 32) >Int Z*/
          
           
endmodule
