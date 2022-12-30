require "armv8-semantics.k"

module TEST-SPEC-VADD-I8

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VADD . I8 q2 , q0 , r1 , .Operands ) )
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
         "Q0"  |-> concatenateMInt(mi(8, A), 
                        concatenateMInt(mi(8, B), 
                            concatenateMInt(mi(8, C), 
                                concatenateMInt(mi(8, D), 
                                    concatenateMInt(mi(8, E), 
                                        concatenateMInt(mi(8, F), 
                                            concatenateMInt(mi(8, G), 
                                                concatenateMInt(mi(8, H), 
                                                    concatenateMInt(mi(8, J), 
                                                        concatenateMInt(mi(8, L), 
                                                            concatenateMInt(mi(8, M), 
                                                                concatenateMInt(mi(8, N), 
                                                                    concatenateMInt(mi(8, O), 
                                                                        concatenateMInt(mi(8, P), 
                                                                            concatenateMInt(mi(8, Q), mi(8, R))))))))))))))))
         "R1"  |-> mi(32, T)
         // destination need to set element every one beat
         "Q2"  |-> ( mi(128, _:Int) => concatenateMInt(
                concatenateMInt(addMInt(mi(8, A), extractMInt(mi(32, T), 24, 32)),
                    concatenateMInt(addMInt(mi(8, B), extractMInt(mi(32, T), 24, 32)), 
                        concatenateMInt(addMInt(mi(8, C), extractMInt(mi(32, T), 24, 32)), addMInt(mi(8, D), extractMInt(mi(32, T), 24, 32)))
                    )
                ),
                concatenateMInt(
                    concatenateMInt(
                        addMInt(mi(8, E), extractMInt(mi(32, T), 24, 32)),
                        concatenateMInt(
                            addMInt(mi(8, F), extractMInt(mi(32, T), 24, 32)),
                            concatenateMInt(
                                addMInt(mi(8, G), extractMInt(mi(32, T), 24 ,32)),
                                addMInt(mi(8, H), extractMInt(mi(32, T), 24, 32))
                            )
                        )
                    ),
                    concatenateMInt(
                        concatenateMInt(
                            addMInt(mi(8, J), extractMInt(mi(32, T), 24, 32)),
                            concatenateMInt(
                                addMInt(mi(8, L), extractMInt(mi(32, T), 24, 32)),
                                concatenateMInt(
                                    addMInt(mi(8, M), extractMInt(mi(32, T), 24, 32)),
                                    addMInt(mi(8, N), extractMInt(mi(32, T), 24, 32))
                                )
                            )
                        ), 
                        concatenateMInt(
                            addMInt(mi(8, O), extractMInt(mi(32, T), 24, 32)),
                            concatenateMInt(
                                addMInt(mi(8, P), extractMInt(mi(32, T), 24, 32)),
                                concatenateMInt(
                                    addMInt(mi(8, Q), extractMInt(mi(32, T), 24, 32)),
                                    addMInt(mi(8, R), extractMInt(mi(32, T), 24, 32))
                                )
                            )
                        )
                    )
                )
            )
         )
         "S0" |-> concatenateMInt(mi(8, O), concatenateMInt(mi(8, P), concatenateMInt(mi(8, Q), mi(8, R))))
         "S1" |-> concatenateMInt(mi(8, J), concatenateMInt(mi(8, L), concatenateMInt(mi(8, M), mi(8, N))))
         "S2" |-> concatenateMInt(mi(8, E), concatenateMInt(mi(8, F), concatenateMInt(mi(8, G), mi(8, H))))
         "S3" |-> concatenateMInt(mi(8, A), concatenateMInt(mi(8, B), concatenateMInt(mi(8, C), mi(8, D))))

         "S8" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        concatenateMInt(
                                                            addMInt(mi(8, O), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, P), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, Q), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, R), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    ) then 
                                        concatenateMInt(
                                                            addMInt(mi(8, O), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, P), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, Q), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, R), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    else 
                                        undefMInt32 )
         "S9" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        concatenateMInt(
                                                            addMInt(mi(8, J), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, L), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, M), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, N), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    ) then 
                                        concatenateMInt(
                                                            addMInt(mi(8, J), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, L), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, M), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, N), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    else 
                                        undefMInt32 )
         "S10" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        concatenateMInt(
                                                            addMInt(mi(8, E), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, F), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, G), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, H), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    ) then 
                                        concatenateMInt(
                                                            addMInt(mi(8, E), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, F), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, G), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, H), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    else 
                                        undefMInt32 )
         "S11" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        concatenateMInt(
                                                            addMInt(mi(8, A), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, B), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, C), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, D), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    ) then 
                                        concatenateMInt(
                                                            addMInt(mi(8, A), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, B), extractMInt(mi(32, T), 24, 32)),
                                                                concatenateMInt(
                                                                    addMInt(mi(8, C), extractMInt(mi(32, T), 24, 32)),
                                                                    addMInt(mi(8, D), extractMInt(mi(32, T), 24, 32))
                                                                )
                                                            )
                                                        )
                                    else 
                                        undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => concatenateMInt(
                                                        addMInt(mi(8, A), extractMInt(mi(32, T), 24, 32)),
                                                        concatenateMInt(
                                                            addMInt(mi(8, B), extractMInt(mi(32, T), 24, 32)),
                                                            concatenateMInt(
                                                                addMInt(mi(8, C), extractMInt(mi(32, T), 24, 32)),
                                                                addMInt(mi(8, D), extractMInt(mi(32, T), 24, 32))
                                                            )
                                                        )
                                                    ))
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
         requires  A >=Int 0
           andBool A <Int (2 ^Int 8)
           andBool B >=Int 0
           andBool B <Int (2 ^Int 8)
           andBool C >=Int 0
           andBool C <Int (2 ^Int 8)
           andBool D >=Int 0
           andBool D <Int (2 ^Int 8)
           andBool E >=Int 0
           andBool E <Int (2 ^Int 8)
           andBool F >=Int 0
           andBool F <Int (2 ^Int 8)
           andBool G >=Int 0
           andBool G <Int (2 ^Int 8)
           andBool H >=Int 0
           andBool H <Int (2 ^Int 8)
           andBool J >=Int 0
           andBool J <Int (2 ^Int 8)
           andBool L >=Int 0
           andBool L <Int (2 ^Int 8)
           andBool M >=Int 0
           andBool M <Int (2 ^Int 8)
           andBool N >=Int 0
           andBool N <Int (2 ^Int 8)
           andBool O >=Int 0
           andBool O <Int (2 ^Int 8)
           andBool P >=Int 0
           andBool P <Int (2 ^Int 8)
           andBool Q >=Int 0
           andBool Q <Int (2 ^Int 8)
           andBool R >=Int 0
           andBool R <Int (2 ^Int 8)

           andBool T >=Int 0
           andBool T <Int (2 ^Int 32)

endmodule
