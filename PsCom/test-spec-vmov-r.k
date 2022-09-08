require "armv8-semantics.k"

module TEST-SPEC-VMOV-R

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMOV . $ 8 q2 [ 1 ] , r0 , .Operands) )
       </instructiontext>
       <regstate>
         /*
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
         */

         "R0" |-> mi(32, 255)
         "Q2" |-> (mi(128, 0) => mi(128, 65280) )
         "S8" |-> mi(32, 65280)
         "S9" |-> mi(32, 0)
         "S10" |-> mi(32, 0)
         "S11" |-> mi(32, 0)
         "RESULT" |-> mi(32, 0)
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
       /*
          requires (A >=Int 0) andBool (A <Int (2 ^Int 128))
                andBool (B >=Int 0) andBool (B <Int 2 ^Int 128) */
           
endmodule
