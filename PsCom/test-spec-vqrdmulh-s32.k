require "armv8-semantics.k"

module TEST-SPEC-VQRDMULH-S32

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VQRDMULH . S32 q2 , q0 , r0 , .Operands ) )
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
         // set fpscr
         "FPSCR" |-> (mi(32, 50331648) => ifMInt ((((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647)
                                    orBool (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648)) then
                                    plugInMask(mi(32, 50331648), mi(1, 1), 27)
                                else
                                    mi(32, 50331648))
         "Q0"  |-> concatenateMInt(mi(32, A), concatenateMInt(mi(32, B), concatenateMInt(mi(32, C), mi(32, D))))

         "Q2"  |-> ( mi(128, _:Int) => concatenateMInt(
                                            ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                                mi(32, 2147483647)
                                            else ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                                mi(32, -2147483648)
                                            else
                                                mi(32, ((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32)),
                                            concatenateMInt(
                                                ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                                    mi(32, 2147483647)
                                                else ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                                    mi(32, -2147483648)
                                                else
                                                    mi(32, ((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32)),
                                                concatenateMInt(
                                                    ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                                        mi(32, 2147483647)
                                                    else ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                                        mi(32, -2147483648)
                                                    else
                                                        mi(32, ((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32)),
                                                    ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                                        mi(32, 2147483647)
                                                    else ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                                        mi(32, -2147483648)
                                                    else
                                                        mi(32, ((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                                )
                                            )
                                        )
         )
         "S0" |-> mi(32, D)
         "S1" |-> mi(32, C)
         "S2" |-> mi(32, B)
         "S3" |-> mi(32, A)

         "R0" |-> mi(32, E)

         "S8" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    ) then 
                                        ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, D)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    else 
                                        undefMInt32 )
         "S9" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    ) then 
                                        ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, C)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    else 
                                        undefMInt32 )
         "S10" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    ) then 
                                        ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, B)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    else 
                                        undefMInt32 )
         "S11" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (
                                        ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    ) then 
                                        ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                            mi(32, 2147483647)
                                        else ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                            mi(32, -2147483648)
                                        else
                                            mi(32, ((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32))
                                    else 
                                        undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                        mi(32, 2147483647)
                                    else ifMInt (((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                        mi(32, -2147483648)
                                    else
                                        mi(32, ((2 *Int svalueMInt(mi(32, A)) *Int svalueMInt(mi(32, E)) +Int 2147483648) >>Int 32)) )
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

endmodule
