require "armv8-semantics.k"

module SPEC-VMAXA-CHECK

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMAXA . S8 q0 , q1 , .Operands ) )
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
         

         "Q0"  |-> (concatenateMInt(mi(8, A16), concatenateMInt(mi(8, A15), concatenateMInt(mi(8, A14), concatenateMInt(mi(8, A13), concatenateMInt(mi(8, A12), concatenateMInt(mi(8, A11), concatenateMInt(mi(8, A10), concatenateMInt(mi(8, A9), concatenateMInt(mi(8, A8), concatenateMInt(mi(8, A7), concatenateMInt(mi(8, A6), concatenateMInt(mi(8, A5), concatenateMInt(mi(8, A4), concatenateMInt(mi(8, A3), concatenateMInt(mi(8, A2), mi(8, A1)))))))))))))))) =>
                        concatenateMInt( (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B16))) <=Int uvalueMInt(mi(8, A16))) then 
                                (mi(8, A16)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B16))))) )
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B15))) <=Int uvalueMInt(mi(8, A15))) then 
                                    (mi(8, A15)) 
                                else (mi(8, absInt(svalueMInt(mi(8, B15))))))
                                , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B14))) <=Int uvalueMInt(mi(8, A14))) then 
                                    (mi(8, A14)) 
                                else (mi(8, absInt(svalueMInt(mi(8, B14)))))), 
                                ( ifMInt (absInt(svalueMInt(mi(8, B13))) <=Int uvalueMInt(mi(8, A13))) then 
                                    (mi(8, A13)) 
                                else (mi(8, absInt(svalueMInt(mi(8, B13)))))))))), 
                        concatenateMInt( (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B12))) <=Int uvalueMInt(mi(8, A12))) then 
                            (mi(8, A12)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B12))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B11))) <=Int uvalueMInt(mi(8, A11))) then 
                                (mi(8, A11)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B11))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B10))) <=Int uvalueMInt(mi(8, A10))) then 
                                (mi(8, A10)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B10)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B9))) <=Int uvalueMInt(mi(8, A9))) then 
                                (mi(8, A9)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B9)))))))))), 
                        concatenateMInt( (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B8))) <=Int uvalueMInt(mi(8, A8))) then 
                            (mi(8, A8)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B8))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B7))) <=Int uvalueMInt(mi(8, A7))) then 
                                (mi(8, A7)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B7))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B6))) <=Int uvalueMInt(mi(8, A6))) then 
                                (mi(8, A6)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B6)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B5))) <=Int uvalueMInt(mi(8, A5))) then 
                                (mi(8, A5)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B5)))))))))) , 
                            (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B4))) <=Int uvalueMInt(mi(8, A4))) then 
                            (mi(8, A4)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B4))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B3))) <=Int uvalueMInt(mi(8, A3))) then 
                                (mi(8, A3)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B3))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B2))) <=Int uvalueMInt(mi(8, A2))) then 
                                (mi(8, A2)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B2)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B1))) <=Int uvalueMInt(mi(8, A1))) then 
                                (mi(8, A1)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B1))))))))))
                        )))
                    )
         "Q1"  |-> concatenateMInt(mi(8, B16), concatenateMInt(mi(8, B15), concatenateMInt(mi(8, B14), concatenateMInt(mi(8, B13), concatenateMInt(mi(8, B12), concatenateMInt(mi(8, B11), concatenateMInt(mi(8, B10), concatenateMInt(mi(8, B9), concatenateMInt(mi(8, B8), concatenateMInt(mi(8, B7), concatenateMInt(mi(8, B6), concatenateMInt(mi(8, B5), concatenateMInt(mi(8, B4), concatenateMInt(mi(8, B3), concatenateMInt(mi(8, B2), mi(8, B1))))))))))))))))
                                    
         "S0" |-> (concatenateMInt(mi(8, A4), concatenateMInt(mi(8, A3), concatenateMInt(mi(8, A2),mi(8, A1)))) =>
                    ifMInt notBool IsUndef (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B4))) <=Int uvalueMInt(mi(8, A4))) then 
                            (mi(8, A4)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B4))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B3))) <=Int uvalueMInt(mi(8, A3))) then 
                                (mi(8, A3)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B3))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B2))) <=Int uvalueMInt(mi(8, A2))) then 
                                (mi(8, A2)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B2)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B1))) <=Int uvalueMInt(mi(8, A1))) then 
                                (mi(8, A1)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B1)))))))))) then 
                        (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B4))) <=Int uvalueMInt(mi(8, A4))) then 
                            (mi(8, A4)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B4))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B3))) <=Int uvalueMInt(mi(8, A3))) then 
                                (mi(8, A3)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B3))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B2))) <=Int uvalueMInt(mi(8, A2))) then 
                                (mi(8, A2)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B2)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B1))) <=Int uvalueMInt(mi(8, A1))) then 
                                (mi(8, A1)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B1))))))))))
                    else
                        undefMInt32
                    )
         "S1" |-> (concatenateMInt(mi(8, A8), concatenateMInt(mi(8, A7), concatenateMInt(mi(8, A6),mi(8, A5)))) => 
                    ifMInt notBool IsUndef (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B8))) <=Int uvalueMInt(mi(8, A8))) then 
                            (mi(8, A8)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B8))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B7))) <=Int uvalueMInt(mi(8, A7))) then 
                                (mi(8, A7)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B7))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B6))) <=Int uvalueMInt(mi(8, A6))) then 
                                (mi(8, A6)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B6)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B5))) <=Int uvalueMInt(mi(8, A5))) then 
                                (mi(8, A5)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B5)))))))))) then
                        (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B8))) <=Int uvalueMInt(mi(8, A8))) then 
                            (mi(8, A8)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B8))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B7))) <=Int uvalueMInt(mi(8, A7))) then 
                                (mi(8, A7)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B7))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B6))) <=Int uvalueMInt(mi(8, A6))) then 
                                (mi(8, A6)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B6)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B5))) <=Int uvalueMInt(mi(8, A5))) then 
                                (mi(8, A5)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B5))))))))))
                    else
                        undefMInt32
                    )
         "S2" |-> (concatenateMInt(mi(8, A12), concatenateMInt(mi(8, A11), concatenateMInt(mi(8, A10),mi(8, A9)))) => 
                    ifMInt notBool IsUndef (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B12))) <=Int uvalueMInt(mi(8, A12))) then 
                            (mi(8, A12)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B12))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B11))) <=Int uvalueMInt(mi(8, A11))) then 
                                (mi(8, A11)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B11))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B10))) <=Int uvalueMInt(mi(8, A10))) then 
                                (mi(8, A10)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B10)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B9))) <=Int uvalueMInt(mi(8, A9))) then 
                                (mi(8, A9)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B9)))))))))) then
                        (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B12))) <=Int uvalueMInt(mi(8, A12))) then 
                            (mi(8, A12)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B12))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B11))) <=Int uvalueMInt(mi(8, A11))) then 
                                (mi(8, A11)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B11))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B10))) <=Int uvalueMInt(mi(8, A10))) then 
                                (mi(8, A10)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B10)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B9))) <=Int uvalueMInt(mi(8, A9))) then 
                                (mi(8, A9)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B9))))))))))
                    else
                        undefMInt32
                    )
         "S3" |-> (concatenateMInt(mi(8, A16), concatenateMInt(mi(8, A15), concatenateMInt(mi(8, A14),mi(8, A13)))) => 
                    ifMInt notBool IsUndef (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B16))) <=Int uvalueMInt(mi(8, A16))) then 
                            (mi(8, A16)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B16))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B15))) <=Int uvalueMInt(mi(8, A15))) then 
                                (mi(8, A15)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B15))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B14))) <=Int uvalueMInt(mi(8, A14))) then 
                                (mi(8, A14)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B14)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B13))) <=Int uvalueMInt(mi(8, A13))) then 
                                (mi(8, A13)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B13)))))))))) then
                        (concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B16))) <=Int uvalueMInt(mi(8, A16))) then 
                            (mi(8, A16)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B16))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B15))) <=Int uvalueMInt(mi(8, A15))) then 
                                (mi(8, A15)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B15))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B14))) <=Int uvalueMInt(mi(8, A14))) then 
                                (mi(8, A14)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B14)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B13))) <=Int uvalueMInt(mi(8, A13))) then 
                                (mi(8, A13)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B13))))))))))
                    else
                        undefMInt32
                    )
         "S4" |-> concatenateMInt(mi(8, B4), concatenateMInt(mi(8, B3), concatenateMInt(mi(8, B2),mi(8, B1))))
         "S5" |-> concatenateMInt(mi(8, B8), concatenateMInt(mi(8, B7), concatenateMInt(mi(8, B6),mi(8, B5))))
         "S6" |-> concatenateMInt(mi(8, B12), concatenateMInt(mi(8, B11), concatenateMInt(mi(8, B10),mi(8, B9))))
         "S7" |-> concatenateMInt(mi(8, B16), concatenateMInt(mi(8, B15), concatenateMInt(mi(8, B14),mi(8, B13))))
         "RESULT" |-> ( mi(32, _:Int) => concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B16))) <=Int uvalueMInt(mi(8, A16))) then 
                            (mi(8, A16)) 
                        else (mi(8, absInt(svalueMInt(mi(8, B16))))) )
                        , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B15))) <=Int uvalueMInt(mi(8, A15))) then 
                                (mi(8, A15)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B15))))))
                            , concatenateMInt(( ifMInt (absInt(svalueMInt(mi(8, B14))) <=Int uvalueMInt(mi(8, A14))) then 
                                (mi(8, A14)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B14)))))), 
                            ( ifMInt (absInt(svalueMInt(mi(8, B13))) <=Int uvalueMInt(mi(8, A13))) then 
                                (mi(8, A13)) 
                            else (mi(8, absInt(svalueMInt(mi(8, B13))))))))))
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
       </regstate>
       // Q:  when the destination element range either both bigger than 0 or both less than 0, it introduces the int_abs, and z3 cannot
       // resolve this function, and z3 crash and terminate error.
       // Solve : add attribute "--smt-prelude /home/hhh1/kkkk/old-ver/kframework-5.0.0/k-distribution/include/z3/basic.smt2"
       requires A1 >=Int -8 andBool A1 <=Int 63
			andBool A2 >=Int -5 andBool A2 <=Int 20
			andBool A3 >=Int -6 andBool A3 <=Int 24
			andBool A4 >=Int -4 andBool A4 <=Int -1 // when upper < 0, bug
            //andBool A4 >=Int (-1 *Int (2 ^Int 2)) andBool A4 <Int ((2 ^Int 1))
			andBool A5 >=Int -72 andBool A5 <=Int 50
			andBool A6 >=Int -1 andBool A6 <=Int 62
			andBool A7 >=Int -2 andBool A7 <=Int 9
			andBool A8 >=Int -22 andBool A8 <=Int 5
			//andBool A9 >=Int 1 andBool A9 <=Int 31
            andBool A9 >=Int (-1 *Int (2 ^Int 3)) andBool A9 <Int (2 ^Int 2)
			andBool A10 >=Int -32 andBool A10 <=Int 23
			//andBool A11 >=Int 3 andBool A11 <=Int 55
            andBool A11 >=Int (-1 *Int (2 ^Int 5)) andBool A11 <Int (2 ^Int 4)
			//andBool A12 >=Int 2 andBool A12 <=Int 89
            andBool A12 >=Int (-1 *Int (2 ^Int 4)) andBool A12 <Int (2 ^Int 5)
			andBool A13 >=Int -13 andBool A13 <=Int 88
			andBool A14 >=Int -15 andBool A14 <=Int 55
			//andBool A15 >=Int 2 andBool A15 <=Int 112
            andBool A15 >=Int (-1 *Int (2 ^Int 4)) andBool A15 <Int (2 ^Int 5)
			//andBool A16 >=Int 12 andBool A16 <=Int 111
            andBool A16 >=Int (-1 *Int (2 ^Int 7)) andBool A16 <Int (2 ^Int 7)
			andBool B1 >=Int -64 andBool B1 <=Int 7
			andBool B2 >=Int -25 andBool B2 <=Int 1
			andBool B3 >=Int -26 andBool B3 <=Int 22
			//andBool B4 >=Int -24 andBool B4 <=Int 19
            andBool B4 >=Int (-1 *Int (2 ^Int 7)) andBool B4 <Int (2 ^Int 7)
			andBool B5 >=Int -12 andBool B5 <=Int 4
			andBool B6 >=Int -11 andBool B6 <=Int 5
			andBool B7 >=Int -32 andBool B7 <=Int 0
			andBool B8 >=Int -12 andBool B8 <=Int 59
			//andBool B9 >=Int 0 andBool B9 <=Int 31
            andBool B9 >=Int (-1 *Int (2 ^Int 7)) andBool B9 <Int (2 ^Int 5)
			andBool B10 >=Int -2 andBool B10 <=Int 27
			//andBool B11 >=Int 23 andBool B11 <=Int 54
            andBool B11 >=Int (-1 *Int (2 ^Int 1)) andBool B11 <Int (2 ^Int 5)
			//andBool B12 >=Int 12 andBool B12 <=Int 89
            andBool B12 >=Int (-1 *Int (2 ^Int 3)) andBool B12 <Int (2 ^Int 3)
			andBool B13 >=Int 13 andBool B13 <=Int 88
			andBool B14 >=Int 15 andBool B14 <=Int 55
			//andBool B15 >=Int 20 andBool B15 <=Int 112
            andBool B15 >=Int (-1 *Int (2 ^Int 2)) andBool B15 <Int (2 ^Int 6)
			//andBool B16 >=Int 12 andBool B16 <=Int 111
            andBool B16 >=Int (-1 *Int (2 ^Int 7)) andBool B16 <Int (2 ^Int 7)
            
       /*
         requires  A1 >=Int (-1 *Int (2 ^Int 7)) andBool A1 <Int (2 ^Int 7)
           andBool A2 >=Int (-1 *Int (2 ^Int 7)) andBool A2 <Int (2 ^Int 7)
           andBool A3 >=Int (-1 *Int (2 ^Int 7)) andBool A3 <Int (2 ^Int 7)
           andBool A4 >=Int (-1 *Int (2 ^Int 7)) andBool A4 <Int (2 ^Int 7)
           andBool A5 >=Int (-1 *Int (2 ^Int 7)) andBool A5 <Int (2 ^Int 7)
           andBool A6 >=Int (-1 *Int (2 ^Int 7)) andBool A6 <Int (2 ^Int 7)
           andBool A7 >=Int (-1 *Int (2 ^Int 7)) andBool A7 <Int (2 ^Int 7)
           andBool A8 >=Int (-1 *Int (2 ^Int 7)) andBool A8 <Int (2 ^Int 7)
           andBool A9 >=Int (-1 *Int (2 ^Int 7)) andBool A9 <Int (2 ^Int 7)
           andBool A10 >=Int (-1 *Int (2 ^Int 7)) andBool A10 <Int (2 ^Int 7)
           andBool A11 >=Int (-1 *Int (2 ^Int 7)) andBool A11 <Int (2 ^Int 7)
           andBool A12 >=Int (-1 *Int (2 ^Int 7)) andBool A12 <Int (2 ^Int 7)
           andBool A13 >=Int (-1 *Int (2 ^Int 7)) andBool A13 <Int (2 ^Int 7)
           andBool A14 >=Int (-1 *Int (2 ^Int 7)) andBool A14 <Int (2 ^Int 7)
           andBool A15 >=Int (-1 *Int (2 ^Int 7)) andBool A15 <Int (2 ^Int 7)
           andBool A16 >=Int (-1 *Int (2 ^Int 7)) andBool A16 <Int (2 ^Int 7)
           andBool B1 >=Int (-1 *Int (2 ^Int 7)) andBool B1 <Int (2 ^Int 7)
           andBool B2 >=Int (-1 *Int (2 ^Int 7)) andBool B2 <Int (2 ^Int 7)
           andBool B3 >=Int (-1 *Int (2 ^Int 7)) andBool B3 <Int (2 ^Int 7)
           andBool B4 >=Int (-1 *Int (2 ^Int 7)) andBool B4 <Int (2 ^Int 7)
           andBool B5 >=Int (-1 *Int (2 ^Int 7)) andBool B5 <Int (2 ^Int 7)
           andBool B6 >=Int (-1 *Int (2 ^Int 7)) andBool B6 <Int (2 ^Int 7)
           andBool B7 >=Int (-1 *Int (2 ^Int 7)) andBool B7 <Int (2 ^Int 7)
           andBool B8 >=Int (-1 *Int (2 ^Int 7)) andBool B8 <Int (2 ^Int 7)
           andBool B9 >=Int (-1 *Int (2 ^Int 7)) andBool B9 <Int (2 ^Int 7)
           andBool B10 >=Int (-1 *Int (2 ^Int 7)) andBool B10 <Int (2 ^Int 7)
           andBool B11 >=Int (-1 *Int (2 ^Int 7)) andBool B11 <Int (2 ^Int 7)
           andBool B12 >=Int (-1 *Int (2 ^Int 7)) andBool B12 <Int (2 ^Int 7)
           andBool B13 >=Int (-1 *Int (2 ^Int 7)) andBool B13 <Int (2 ^Int 7)
           andBool B14 >=Int (-1 *Int (2 ^Int 7)) andBool B14 <Int (2 ^Int 7)
           andBool B15 >=Int (-1 *Int (2 ^Int 7)) andBool B15 <Int (2 ^Int 7)
           andBool B16 >=Int (-1 *Int (2 ^Int 7)) andBool B16 <Int (2 ^Int 7)
           */

endmodule