require "armv8-semantics.k"

module TEST-SPEC-MAA

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( maa . S32 r0, q0, q1, (# 1:Int):Imm, .Operands) )
       </instructiontext>
       <regstate>
         "Q0" |-> concatenateMInt(mi(32, I4:Int), concatenateMInt( mi(32, I3:Int), concatenateMInt( mi(32, I2:Int), mi(32, I1:Int))))
         "Q1" |-> concatenateMInt(mi(32, I8:Int), concatenateMInt( mi(32, I7:Int), concatenateMInt( mi(32, I6:Int), mi(32, I5:Int))))
         "S0" |-> mi(32, I1)
         "S1" |-> mi(32, I2)
         "S2" |-> mi(32, I3)
         "S3" |-> mi(32, I4)
         "S4" |-> mi(32, I5)
         "S5" |-> mi(32, I6)
         "S6" |-> mi(32, I7)
         "S7" |-> mi(32, I8)

         "R0" |->   (mi(32, B:Int) => ifMInt ((B +Int I2 *Int I6 <Int (2 ^Int 31)) andBool (B +Int I2 *Int I6 >=Int (-2 ^Int 31))) then extractMInt( mi ( 64 , B +Int I2 *Int I6/* svalueMInt(mi(32, B)) +Int svalueMInt ( mi ( 32 , I2 ) ) *Int svalueMInt ( mi ( 32 , I6 ) ) */), 32, 64) else (undefMInt32) /*mi(32, B +Int I2 *Int I6)*/ )

         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
          requires  B >=Int  -1 *Int (2 ^Int 15) andBool I2 >=Int  -1 *Int (2 ^Int 15)
                    andBool I6 >=Int  -1 *Int (2 ^Int 15)
                    andBool B <Int (2 ^Int 15)
                    andBool I2 <Int (2 ^Int 15)
                    andBool I6 <Int (2 ^Int 15)
//                    andBool svalueMInt(mi(32, B)) +Int svalueMInt(mi(32,I2)) *Int svalueMInt(mi(32,I6)) <Int (2 ^Int 31)  //B +Int I2 *Int I6 <Int (2 ^Int 31)
//                    andBool svalueMInt(mi(32,I2)) *Int svalueMInt(mi(32,I6)) <Int (2 ^Int 31)
//                    andBool svalueMInt(mi(32, B)) +Int svalueMInt(mi(32,I2)) *Int svalueMInt(mi(32, I6)) >=Int -1 *Int (2 ^Int 31)
//                    andBool svalueMInt(mi(32, I2)) *Int svalueMInt(mi(32, I6)) >=Int -1 *Int (2 ^Int 31)
          //A >=Int 0 andBool A <=Int 3 andBool
          /*
                    I1 >=Int 0 andBool I1 <Int 32768 andBool
                    I2 >=Int 0 andBool I2 <Int 32768 andBool
                    I3 >=Int 0 andBool I3 <Int 32768 andBool
                    I4 >=Int 0 andBool I4 <Int 32768 andBool
                    I5 >=Int 0 andBool I5 <Int 32768 andBool
                    I6 >=Int 0 andBool I6 <Int 32768 andBool
                    I7 >=Int 0 andBool I7 <Int 32768 andBool
                    I8 >=Int 0 andBool I8 <Int 32768 andBool
                    B >=Int 0 andBool B <Int 3221291007*/ //3221291008 sat //3221225472 unsat
                    /*
                    (
                        (A ==Int 0 andBool B >=Int 0 andBool B <Int 1073741824) orBool
                        (A ==Int 1 andBool B >=Int 0 andBool B <Int 2147483648) orBool
                        (A ==Int 2 andBool B >=Int 0 andBool B <Int 3221225472) orBool
                        (A ==Int 3 andBool B >=Int 0 andBool B <Int 4294967296)
                    )
                    */



endmodule
