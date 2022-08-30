require "armv8-semantics.k"

module TEST-SPEC-STO

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( sto r0 , .Operands)
         memloc(mi(32, 1)) |-> storedInstr ( end .Operands ) )
       </instructiontext>
       <regstate>
         
         "CONTROL" |-> mi(32, 1)
         "CONTROL_NS" |-> mi(32, 1)
         "CONTROL_S" |-> mi(32, 1)
         "CPACR" |-> mi(32, 3145728)
         "CPACR_NS" |-> mi(32, 3145728)
         "CPACR_S" |-> mi(32, 3145728)
         "CPPWR" |-> mi(32, 0)
         "CPPWR_NS" |-> mi(32, 0)
         "CPPWR_S" |-> mi(32, 0)
         "EPSR" |-> mi(32, 2048)
         "FPCCR" |-> mi(32, 0)
         "FPCCR_NS" |-> mi(32, 0)
         "FPCCR_S" |-> mi(32, 0)
         "MVFR1" |-> mi(32, 256)
         "NSACR" |-> mi(32, 1024)
         "VPR" |-> mi(32, 2048)
         /*
         "Q0" |-> mi(128, A:Int)
         "R0" |-> mi(32, B:Int)
         "TEMP1" |-> extractMInt(mi(128, A), 120, 128)
         "TEMP2" |-> extractMInt(mi(32, B) , 24, 32)
         "V_TEMP1" |-> svalueMInt(extractMInt(mi(128, A), 120, 128))
         "V_TEMP2" |-> svalueMInt(extractMInt(mi(32, B) , 24, 32))
         
         "V_TEMP1" |-> A
         "V_TEMP2" |-> B
         */
         
         "RESULT" |-> mi(32, A)
         "R0" |-> (mi(32, _:Int) => mi(32, A))
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 2)))
       </regstate>
          requires (A >=Int (-1 *Int (2 ^Int 31))) andBool (A <Int (2 ^Int 31 -Int 1))
                   andBool (B >=Int (-1 *Int (2 ^Int 31))) andBool (B <Int (2 ^Int 31 -Int 1))
           
endmodule
