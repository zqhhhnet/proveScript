require "armv8-semantics.k"

module TEST-SPEC-VMOV

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMOV q2 , q1 /*(B *Int (2 ^Int 96) +Int C *Int (2 ^Int 64) +Int D *Int (2 ^Int 32) +Int E)*/
, .Operands) )
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

         //"R0" |-> mi(32, 255)
         "Q1" |-> mi(128, A)
         "Q2" |-> (mi(128, 0) => mi(128, A/*(B *Int (2 ^Int 96) +Int (C *Int (2 ^Int 64) +Int (D *Int (2 ^Int 32) +Int E)))*/
) )//concatenateMInt(mi(32, B), concatenateMInt(mi(32, C), concatenateMInt(mi(32, D), mi(32, E)))))
	 "S4" |-> extractMInt(mi(128, A), 96, 128)
	 "S5" |-> extractMInt(mi(128, A), 64, 96)
	 "S6" |-> extractMInt(mi(128, A), 32, 64)
	 "S7" |-> extractMInt(mi(128, A), 0, 32)
         "S8" |-> extractMInt(mi(128, A), 96, 128)
//         "S8" |-> mi(32, E)
         "S9" |-> extractMInt(mi(128, A), 64, 96)
//	 "S9" |-> mi(32, D)
//	 "S10" |-> mi(32, C)
//	 "S11" |-> mi(32, B)
         "S10" |-> extractMInt(mi(128, A), 32, 64)
         "S11" |-> extractMInt(mi(128, A), 0, 32)
         "RESULT" |-> mi(32, 0)
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
/*	  requires A ==Int (B *Int (2 ^Int 96) +Int C *Int (2 ^Int 64) +Int D *Int (2 ^Int 32) +Int E)
		(B >=Int 0) andBool (B <Int 2 ^Int 32)
		andBool (C >=Int 0) andBool (C <Int 2 ^Int 32)
		andBool (D >=Int 0) andBool (D <Int 2 ^Int 32)
		andBool (E >=Int 0) andBool (E <Int 2 ^Int 32)  */
          requires (A >=Int (-2 ^Int 127)) andBool (A <Int (2 ^Int 128))
               // andBool (B >=Int 0) andBool (B <Int 2 ^Int 128) 
           
endmodule
