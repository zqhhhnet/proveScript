require "armv8-semantics.k"

module SPEC-VMAX-CHECK

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMAX . S8 q2 , q0 , q1 , .Operands ) )
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
         

         "Q0"  |-> concatenateMInt(mi(8, A16), concatenateMInt(mi(8, A15), concatenateMInt(mi(8, A14), concatenateMInt(mi(8, A13), concatenateMInt(mi(8, A12), concatenateMInt(mi(8, A11), concatenateMInt(mi(8, A10), concatenateMInt(mi(8, A9), concatenateMInt(mi(8, A8), concatenateMInt(mi(8, A7), concatenateMInt(mi(8, A6), concatenateMInt(mi(8, A5), concatenateMInt(mi(8, A4), concatenateMInt(mi(8, A3), concatenateMInt(mi(8, A2), mi(8, A1))))))))))))))))
         "Q1"  |-> concatenateMInt(mi(8, B16), concatenateMInt(mi(8, B15), concatenateMInt(mi(8, B14), concatenateMInt(mi(8, B13), concatenateMInt(mi(8, B12), concatenateMInt(mi(8, B11), concatenateMInt(mi(8, B10), concatenateMInt(mi(8, B9), concatenateMInt(mi(8, B8), concatenateMInt(mi(8, B7), concatenateMInt(mi(8, B6), concatenateMInt(mi(8, B5), concatenateMInt(mi(8, B4), concatenateMInt(mi(8, B3), concatenateMInt(mi(8, B2), mi(8, B1))))))))))))))))
         "Q2"  |-> ( mi(128, _:Int) => concatenateMInt( concatenateMInt(ifMInt (B16 <=Int A16) then (mi(8, A16)) else (mi(8, B16)) , 
                                    concatenateMInt( ifMInt (B15 <=Int A15) then mi(8, A15) else mi(8, B15) , 
                                    concatenateMInt(ifMInt (B14 <=Int A14) then mi(8, A14) else mi(8, B14), ifMInt (B13 <=Int A13) then mi(8, A13) else mi(8, B13)))),
                                    concatenateMInt( concatenateMInt(ifMInt (B12 <=Int A12) then (mi(8, A12)) else (mi(8, B12)) , 
                                    concatenateMInt( ifMInt (B11 <=Int A11) then mi(8, A11) else mi(8, B11) , 
                                    concatenateMInt(ifMInt (B10 <=Int A10) then mi(8, A10) else mi(8, B10), ifMInt (B9 <=Int A9) then mi(8, A9) else mi(8, B9)))),
                                    concatenateMInt( concatenateMInt(ifMInt (B8 <=Int A8) then (mi(8, A8)) else (mi(8, B8)) , 
                                    concatenateMInt( ifMInt (B7 <=Int A7) then mi(8, A7) else mi(8, B7) , 
                                    concatenateMInt(ifMInt (B6 <=Int A6) then mi(8, A6) else mi(8, B6), ifMInt (B5 <=Int A5) then mi(8, A5) else mi(8, B5)))),
                                    concatenateMInt(ifMInt (B4 <=Int A4) then (mi(8, A4)) else (mi(8, B4)) , 
                                    concatenateMInt( ifMInt (B3 <=Int A3) then mi(8, A3) else mi(8, B3) , 
                                    concatenateMInt(ifMInt (B2 <=Int A2) then mi(8, A2) else mi(8, B2), ifMInt (B1 <=Int A1) then mi(8, A1) else mi(8, B1))))
                                    ))))
                                    
         "S0" |-> concatenateMInt(mi(8, A4), concatenateMInt(mi(8, A3), concatenateMInt(mi(8, A2),mi(8, A1))))
         "S1" |-> concatenateMInt(mi(8, A8), concatenateMInt(mi(8, A7), concatenateMInt(mi(8, A6),mi(8, A5))))
         "S2" |-> concatenateMInt(mi(8, A12), concatenateMInt(mi(8, A11), concatenateMInt(mi(8, A10),mi(8, A9))))
         "S3" |-> concatenateMInt(mi(8, A16), concatenateMInt(mi(8, A15), concatenateMInt(mi(8, A14),mi(8, A13))))
         "S4" |-> concatenateMInt(mi(8, B4), concatenateMInt(mi(8, B3), concatenateMInt(mi(8, B2),mi(8, B1))))
         "S5" |-> concatenateMInt(mi(8, B8), concatenateMInt(mi(8, B7), concatenateMInt(mi(8, B6),mi(8, B5))))
         "S6" |-> concatenateMInt(mi(8, B12), concatenateMInt(mi(8, B11), concatenateMInt(mi(8, B10),mi(8, B9))))
         "S7" |-> concatenateMInt(mi(8, B16), concatenateMInt(mi(8, B15), concatenateMInt(mi(8, B14),mi(8, B13))))
         "S8" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (concatenateMInt(ifMInt (B4 <=Int A4) then (mi(8, A4)) else (mi(8, B4)) , 
                                    concatenateMInt( ifMInt (B3 <=Int A3) then mi(8, A3) else mi(8, B3) , 
                                    concatenateMInt(ifMInt (B2 <=Int A2) then mi(8, A2) else mi(8, B2), ifMInt (B1 <=Int A1) then mi(8, A1) else mi(8, B1))))) then
                                        (concatenateMInt(ifMInt (B4 <=Int A4) then (mi(8, A4)) else (mi(8, B4)) , 
                                    concatenateMInt( ifMInt (B3 <=Int A3) then mi(8, A3) else mi(8, B3) , 
                                    concatenateMInt(ifMInt (B2 <=Int A2) then mi(8, A2) else mi(8, B2), ifMInt (B1 <=Int A1) then mi(8, A1) else mi(8, B1)))) )
                                    else undefMInt32 )
         "S9" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (concatenateMInt(ifMInt (B8 <=Int A8) then (mi(8, A8)) else (mi(8, B8)) , 
                                    concatenateMInt( ifMInt (B7 <=Int A7) then mi(8, A7) else mi(8, B7) , 
                                    concatenateMInt(ifMInt (B6 <=Int A6) then mi(8, A6) else mi(8, B6), ifMInt (B5 <=Int A5) then mi(8, A5) else mi(8, B5))))) then
                                        concatenateMInt(ifMInt (B8 <=Int A8) then (mi(8, A8)) else (mi(8, B8)) , 
                                    concatenateMInt( ifMInt (B7 <=Int A7) then mi(8, A7) else mi(8, B7) , 
                                    concatenateMInt(ifMInt (B6 <=Int A6) then mi(8, A6) else mi(8, B6), ifMInt (B5 <=Int A5) then mi(8, A5) else mi(8, B5))))
                                    else undefMInt32)
         "S10" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (concatenateMInt(ifMInt (B12 <=Int A12) then (mi(8, A12)) else (mi(8, B12)) , 
                                    concatenateMInt( ifMInt (B11 <=Int A11) then mi(8, A11) else mi(8, B11) , 
                                    concatenateMInt(ifMInt (B10 <=Int A10) then mi(8, A10) else mi(8, B10), ifMInt (B9 <=Int A9) then mi(8, A9) else mi(8, B9))))) then
                                        concatenateMInt(ifMInt (B12 <=Int A12) then (mi(8, A12)) else (mi(8, B12)) , 
                                    concatenateMInt( ifMInt (B11 <=Int A11) then mi(8, A11) else mi(8, B11) , 
                                    concatenateMInt(ifMInt (B10 <=Int A10) then mi(8, A10) else mi(8, B10), ifMInt (B9 <=Int A9) then mi(8, A9) else mi(8, B9))))
                                    else undefMInt32)
         "S11" |-> (mi(32, _:Int) => ifMInt notBool IsUndef (concatenateMInt(ifMInt (B16 <=Int A16) then (mi(8, A16)) else (mi(8, B16)) , 
                                    concatenateMInt( ifMInt (B15 <=Int A15) then mi(8, A15) else mi(8, B15) , 
                                    concatenateMInt(ifMInt (B14 <=Int A14) then mi(8, A14) else mi(8, B14), ifMInt (B13 <=Int A13) then mi(8, A13) else mi(8, B13))))) then
                                        concatenateMInt(ifMInt (B16 <=Int A16) then (mi(8, A16)) else (mi(8, B16)) , 
                                    concatenateMInt( ifMInt (B15 <=Int A15) then mi(8, A15) else mi(8, B15) , 
                                    concatenateMInt(ifMInt (B14 <=Int A14) then mi(8, A14) else mi(8, B14), ifMInt (B13 <=Int A13) then mi(8, A13) else mi(8, B13))))
                                    else undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => concatenateMInt(ifMInt (B16 <=Int A16) then (mi(8, A16)) else (mi(8, B16)) , 
                                    concatenateMInt( ifMInt (B15 <=Int A15) then mi(8, A15) else mi(8, B15) , 
                                    concatenateMInt(ifMInt (B14 <=Int A14) then mi(8, A14) else mi(8, B14), ifMInt (B13 <=Int A13) then mi(8, A13) else mi(8, B13)))))
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
       </regstate>
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

endmodule
