require "armv8-semantics.k"

module MAX-SPEC
  imports ARMV8-SEMANTICS
  
  rule <k> scan => End </k>
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
         .Map
       </functarget>
       <instructiontext>
         /*
         code ( mi(32, 0) |-> storedInstr ( MOV r0 , A:Imm , .Operands )
         mi(32, 1) |-> storedInstr ( MOV r1 , B:Imm , .Operands )
         mi(32, 2) |-> storedInstr ( ADD r2, r0 , r1 , .Operands )
         mi(32, 3) |-> storedInstr ( end .Operands ) )
         */
         code ( memloc(mi(32, 0)) |-> storedInstr ( MOV r0 , (# A:Int):Imm , .Operands )
         memloc(mi(32, 1)) |-> storedInstr ( MOV r1 , (# B:Int):Imm , .Operands )
         memloc(mi(32, 2)) |-> storedInstr ( MAX r2, r0 , r1 , .Operands )
         memloc(mi(32, 3)) |-> storedInstr ( end .Operands ) ) 
       </instructiontext>
       <regstate>
         //"R0" |-> (mi(32, _) => mi(32, modImm32(A))) 
         "R0" |-> (mi(32, _:Int) => mi(32, A):MInt) //(_:MInt => mi(32, A))
         //"R1" |-> (mi(32, _) => mi(32, modImm32(B))) 
         "R1" |-> (mi(32, _:Int) => mi(32, B):MInt) //(_:MInt => mi(32, B))
         //"R2" |-> (mi(32, _:Int):MInt =>  addMInt(mi(32, modImm32(A)), mi(32, modImm(B)))) 
         "R2" |-> (mi(32, _:Int):MInt => ifMInt (A >=Int B) then (mi(32, A)) else (mi(32, B)))
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 4)))
         //"RESULT64" |-> mi(64, 0)
         //"RESULT" |-> mi(32, 0)
       </regstate>
         requires //modImm32(A) >=Int 0 andBool modImm32(A) <Int (2 ^Int 31)
                  //andBool modImm32(B) >=Int 0 andBool modImm32(B) <Int (2 ^Int 31)
                  0 <=Int A andBool A <Int (2 ^Int 32)
                  andBool B >=Int 0 andBool B <Int (2 ^Int 32)
                  //andBool C >=Int 0 andBool C <=Int (A +Int B)
  /*
  rule <k> scan => scan </k>
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
         .Map
       </functarget>
       <instructiontext>
         code ( mi(32, 0) |-> storedInstr ( MOV r0 , (# A:Int):Imm , .Operands )
         mi(32, 1) |-> storedInstr ( MOV r1 , (# B:Int):Imm , .Operands )
         mi(32, 2) |-> storedInstr ( ADD r2, r0 , r1 , .Operands )
         mi(32, 3) |-> storedInstr ( end .Operands ) )
       </instructiontext>
       <regstate>
         "R0" |-> (_:MInt => _:MInt)
         "R1" |-> (_:MInt => _:MInt)
         "R2" |-> (_:MInt => mi(32, A +Int B):MInt)
         "R15" |-> mi(32, 3)
         "RESULT64" |-> mi(64, 0)
         "RESULT" |-> mi(32, 0)
       </regstate>
       */
endmodule
