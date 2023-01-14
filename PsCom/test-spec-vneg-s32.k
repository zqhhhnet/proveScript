require "armv8-semantics.k"

module TEST-SPEC-VNEG-S32

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VNEG . S32 q2 , q0 , .Operands ) )
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
         "Q2"  |-> ( mi(128, _:Int) => concatenateMInt(
                                            mi(32, -1 *Int svalueMInt(mi(32, A))),
                                            concatenateMInt(
                                                mi(32, -1 *Int svalueMInt(mi(32, B))),
                                                concatenateMInt(
                                                    mi(32, -1 *Int svalueMInt(mi(32, C))),
                                                    mi(32, -1 *Int svalueMInt(mi(32, D)))
                                                )
                                            )
                                        )
         )
        
         "Q0" |-> concatenateMInt(mi(32, A), concatenateMInt(mi(32, B), concatenateMInt(mi(32, C), mi(32, D))))

         "S0" |-> mi(32, D)
         "S1" |-> mi(32, C)
         "S2" |-> mi(32, B)
         "S3" |-> mi(32, A)

         "S8" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        mi(32, -1 *Int svalueMInt(mi(32, D)))
                                    ) then 
                                        mi(32, -1 *Int svalueMInt(mi(32, D)))
                                        //concatenateMInt(extractMInt(subMInt(mi(32, D), mi(32, M)), 0, 24), subMInt(extractMInt(mi(32, D), 24, 32), extractMInt(mi(32, M), 24, 32)))
                                    else 
                                        undefMInt32 )
         "S9" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        mi(32, -1 *Int svalueMInt(mi(32, C)))
                                    ) then 
                                        mi(32, -1 *Int svalueMInt(mi(32, C)))
                                        //concatenateMInt(extractMInt(subMInt(mi(32, C), mi(32, M)), 0, 24), subMInt(extractMInt(mi(32, C), 24, 32), extractMInt(mi(32, M), 24, 32)))
                                    else 
                                        undefMInt32 )
         "S10" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        mi(32, -1 *Int svalueMInt(mi(32, B)))
                                    ) then 
                                        mi(32, -1 *Int svalueMInt(mi(32, B)))
                                        //concatenateMInt(extractMInt(subMInt(mi(32, B), mi(32, M)), 0, 24), subMInt(extractMInt(mi(32, B), 24, 32), extractMInt(mi(32, M), 24, 32)))
                                    else 
                                        undefMInt32 )
         "S11" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        mi(32, -1 *Int svalueMInt(mi(32, A)))
                                    ) then 
                                        mi(32, -1 *Int svalueMInt(mi(32, A)))
                                        //concatenateMInt(extractMInt(subMInt(mi(32, A), mi(32, M)), 0, 24), subMInt(extractMInt(mi(32, A), 24, 32), extractMInt(mi(32, M), 24, 32)))
                                    else 
                                        undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => mi(32, -1 *Int svalueMInt(mi(32, A))) )
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
           

endmodule
