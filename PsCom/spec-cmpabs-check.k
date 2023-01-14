require "armv8-semantics.k"

module SPEC-CMPABS-CHECK

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( cmpAbs . S32 r0 , q0, (# 0:Int):Imm , (# 1:Int):Imm, .Operands) )
       </instructiontext>
       <regstate>
         
         "Q0" |-> concatenateMInt(mi(32, X:Int), concatenateMInt( mi(32, Y:Int), concatenateMInt( mi(32, J:Int), mi(32, Z:Int))))
         "S0" |-> mi(32, Z)
         "S1" |-> mi(32, J)
         "S2" |-> mi(32, Y)
         "S3" |-> mi(32, X)

         "R0" |-> (mi(32, A) => ifMInt (absInt(svalueMInt(mi(32, J))) <=Int uvalueMInt(mi(32, A))) then
                                    mi(32, A)
                                else
                                    mi(32, absInt(svalueMInt(mi(32, J))))
                    )
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
          requires X >=Int (-1 *Int (2 ^Int 31)) andBool X <Int (2 ^Int 31) -Int 1
                  andBool Y >=Int (-1 *Int (2 ^Int 31)) andBool Y <Int (2 ^Int 31) -Int 1
                  andBool J >=Int (-1 *Int (2 ^Int 31)) andBool J <Int (2 ^Int 31) -Int 1
                  andBool Z >=Int (-1 *Int (2 ^Int 31)) andBool Z <Int (2 ^Int 31) -Int 1
                  andBool A >=Int (-1 *Int (2 ^Int 31)) andBool A <Int (2 ^Int 31) -Int 1
                  
           
endmodule
