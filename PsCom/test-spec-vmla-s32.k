require "armv8-semantics.k"

module TEST-SPEC-VMLA-S32

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMLA . S32 q2 , q0 , r1 , .Operands ) )
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
         "FPCCR" |-> (mi(32, _:Int) => mi(32, 0))
         "FPCCR_NS" |-> (mi(32, _:Int) => mi(32, 0))
         "FPCCR_S" |-> (mi(32, _:Int) => mi(32, 0))
         "MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
         "NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
         "Q0"  |-> concatenateMInt(mi(32, A), concatenateMInt(mi(32, B), concatenateMInt(mi(32, C), mi(32, D))))
         
         "Q2"  |-> ( concatenateMInt(mi(32, F), concatenateMInt(mi(32, G), concatenateMInt(mi(32, H), mi(32, J)))) => concatenateMInt(
                                            extractMInt(mi(64, svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, F))), 32, 64),
                                            concatenateMInt(
                                                extractMInt(mi(64, svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, G))), 32, 64),
                                                concatenateMInt(
                                                    extractMInt(mi(64, svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, H))), 32, 64),
                                                    extractMInt(mi(64, svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, J))), 32, 64)
                                                )
                                            )
                                        )
         )
         "S0" |-> mi(32, D)
         "S1" |-> mi(32, C)
         "S2" |-> mi(32, B)
         "S3" |-> mi(32, A)
         
         "R1" |-> mi(32, E)

         "S8" |-> (mi(32, J) => ifMInt notBool IsUndef (
                                        extractMInt(mi(64, svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, J))), 32, 64)
                                    ) then 
                                        extractMInt(mi(64, svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, J))), 32, 64)
                                    else 
                                        undefMInt32 )
         "S9" |-> (mi(32, H) => ifMInt notBool IsUndef (
                                        extractMInt(mi(64, svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, H))), 32, 64)
                                    ) then 
                                        extractMInt(mi(64, svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, H))), 32, 64)
                                    else 
                                        undefMInt32 )
         "S10" |-> (mi(32, G) => ifMInt notBool IsUndef (
                                        extractMInt(mi(64, svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, G))), 32, 64)
                                    ) then 
                                        extractMInt(mi(64, svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, G))), 32, 64)
                                    else 
                                        undefMInt32 )
         "S11" |-> (mi(32, F) => ifMInt notBool IsUndef (
                                        extractMInt(mi(64, svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, F))), 32, 64)
                                    ) then 
                                        extractMInt(mi(64, svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, F))), 32, 64)
                                    else 
                                        undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => extractMInt(mi(64, svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int svalueMInt(mi(32, F))), 32, 64))
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
         requires  A >=Int 0
           andBool A <Int (2 ^Int 32)
           andBool B >=Int 0
           andBool B <Int (2 ^Int 32)
           andBool C >=Int 0
           andBool C <Int (2 ^Int 32)
           andBool D >=Int 0
           andBool D <Int (2 ^Int 32)
           andBool E >=Int 0
           andBool E <Int (2 ^Int 32)
           andBool F >=Int 0
           andBool F <Int (2 ^Int 32)
           andBool G >=Int 0
           andBool G <Int (2 ^Int 32)
           andBool H >=Int 0
           andBool H <Int (2 ^Int 32)
           andBool J >=Int 0
           andBool J <Int (2 ^Int 32)

endmodule
