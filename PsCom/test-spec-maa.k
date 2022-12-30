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
         code ( memloc(mi(32, 0)) |-> storedInstr ( maa . S8 r0, q0, q1, (# 3:Int):Imm, .Operands) )
       </instructiontext>
       <regstate>
       /*  32
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
        */
       /* 16 
         "Q0" |-> concatenateMInt(mi(16, I8), concatenateMInt(mi(16, I7), concatenateMInt(mi(16, I6), concatenateMInt(mi(16, I5), concatenateMInt(mi(16, I4:Int), concatenateMInt( mi(16, I3:Int), concatenateMInt( mi(16, I2:Int), mi(16, I1:Int))))))))
         "Q1" |-> concatenateMInt(mi(16, I16), concatenateMInt(mi(16, I15), concatenateMInt(mi(16, I14), concatenateMInt(mi(16, I13), concatenateMInt(mi(16, I12:Int), concatenateMInt( mi(16, I11:Int), concatenateMInt( mi(16, I10:Int), mi(16, I9:Int))))))))
         "S0" |-> concatenateMInt(mi(16, I2), mi(16, I1))
         "S1" |-> concatenateMInt(mi(16, I4), mi(16, I3))
         "S2" |-> concatenateMInt(mi(16, I6), mi(16, I5))
         "S3" |-> concatenateMInt(mi(16, I8), mi(16, I7))
         "S4" |-> concatenateMInt(mi(16, I10), mi(16, I9))
         "S5" |-> concatenateMInt(mi(16, I12), mi(16, I11))
         "S6" |-> concatenateMInt(mi(16, I14), mi(16, I13))
         "S7" |-> concatenateMInt(mi(16, I16), mi(16, I15))
         */

        //"Q0" |-> concatenateMInt(mi(8, I16), concatenateMInt(mi(8, I15), concatenateMInt(mi(8, I14), concatenateMInt(mi(8, I13), concatenateMInt(mi(8, I12), concatenateMInt(mi(8, I11), concatenateMInt(mi(8, I10), concatenateMInt(mi(8, I9), concatenateMInt(mi(8, I8), concatenateMInt(mi(8, I7), concatenateMInt(mi(8, I6), concatenateMInt(mi(8, I5), concatenateMInt(mi(8, I4:Int), concatenateMInt( mi(8, I3:Int), concatenateMInt( mi(8, I2:Int), mi(8, I1:Int))))))))))))))))
        //"Q1" |-> concatenateMInt(mi(8, I32), concatenateMInt(mi(8, I31), concatenateMInt(mi(8, I30), concatenateMInt(mi(8, I29), concatenateMInt(mi(8, I28), concatenateMInt(mi(8, I27), concatenateMInt(mi(8, I26), concatenateMInt(mi(8, I25), concatenateMInt(mi(8, I24), concatenateMInt(mi(8, I23), concatenateMInt(mi(8, I22), concatenateMInt(mi(8, I21), concatenateMInt(mi(8, I20:Int), concatenateMInt( mi(8, I19:Int), concatenateMInt( mi(8, I18:Int), mi(8, I17:Int))))))))))))))))
        "Q0" |-> concatenateMInt(mi(8, I16), concatenateMInt(mi(8, I15), concatenateMInt(mi(8, I14), concatenateMInt(mi(8, I13), concatenateMInt(mi(32, I12), concatenateMInt(mi(32, I11), mi(32, I10)))))))
        "Q1" |-> concatenateMInt(mi(8, I32), concatenateMInt(mi(8, I31), concatenateMInt(mi(8, I30), concatenateMInt(mi(8, I29), concatenateMInt(mi(32, I28), concatenateMInt(mi(32, I27), mi(32, I26)))))))
        //"S0" |-> concatenateMInt(mi(8, I4), concatenateMInt(mi(8, I3), concatenateMInt(mi(8, I2), mi(8, I1))))
        //"S1" |-> concatenateMInt(mi(8, I8), concatenateMInt(mi(8, I7), concatenateMInt(mi(8, I6), mi(8, I5))))
        //"S2" |-> concatenateMInt(mi(8, I12), concatenateMInt(mi(8, I11), concatenateMInt(mi(8, I10), mi(8, I9))))
        "S0" |-> mi(32, I10)
        "S1" |-> mi(32, I11)
        "S2" |-> mi(32, I12)
        "S3" |-> concatenateMInt(mi(8, I16), concatenateMInt(mi(8, I15), concatenateMInt(mi(8, I14), mi(8, I13))))
        //"S4" |-> concatenateMInt(mi(8, I20), concatenateMInt(mi(8, I19), concatenateMInt(mi(8, I18), mi(8, I17))))
        //"S5" |-> concatenateMInt(mi(8, I24), concatenateMInt(mi(8, I23), concatenateMInt(mi(8, I22), mi(8, I21))))
        //"S6" |-> concatenateMInt(mi(8, I28), concatenateMInt(mi(8, I27), concatenateMInt(mi(8, I26), mi(8, I25))))
        "S4" |-> mi(32, I26)
        "S5" |-> mi(32, I27)
        "S6" |-> mi(32, I28)
        "S7" |-> concatenateMInt(mi(8, I32), concatenateMInt(mi(8, I31), concatenateMInt(mi(8, I30), mi(8, I29))))

         //"R0" |->   (mi(32, B:Int) => ifMInt (((uvalueMInt(extractMInt(mi(32,B), 16, 32)) +Int (I3 *Int I11)) <Int (2 ^Int 32) ) andBool ((uvalueMInt(extractMInt(mi(32,B), 16, 32)) +Int (I3 *Int I11)) >=Int 0)) then extractMInt ( mi ( 64 , uvalueMInt ( extractMInt ( mi ( 32 , B ) , 16 , 32 ) ) +Int I3 *Int I11 ) , 32 , 64 ) /*extractMInt( mi ( 64 , uvalueMInt(extractMInt(mi(32,B), 16, 32)) +Int (I3 *Int I11) */ /* svalueMInt(mi(32, B)) +Int svalueMInt ( mi ( 32 , I2 ) ) *Int svalueMInt ( mi ( 32 , I6 ) ) */ /*), 32, 64)*/ else (undefMInt32) /*mi(32, B +Int I2 *Int I6)*/ )
         //"R0" |-> (mi(32, B:Int) => extractMInt ( mi ( 64 , uvalueMInt ( extractMInt ( mi ( 32 , B ) , 16 , 32 ) ) +Int I3 *Int I11 ) , 32 , 64 ) )
         // 32
         //"R0" |-> (mi(32, B:Int) => ifMInt ((svalueMInt(mi(32, B)) +Int svalueMInt(mi(32, I3)) *Int svalueMInt(mi(32, I7))) <Int (2 ^Int 31)) andBool ((svalueMInt(mi(32, B)) +Int svalueMInt(mi(32, I3)) *Int svalueMInt(mi(32, I7))) >=Int (-2 ^Int 31)) then extractMInt ( mi ( 64 , I3 *Int I7 +Int B /*svalueMInt(mi(32, B)) +Int svalueMInt(mi(32, I3)) *Int svalueMInt(mi(32, I7))*/ ) , 32 , 64 ) else undefMInt32 )
         // U 16
         //"R0" |-> (mi(32, B:Int) => ifMInt ((uvalueMInt(mi(32, B)) +Int uvalueMInt(mi(16, I5)) *Int uvalueMInt(mi(16, I13)) +Int uvalueMInt(mi(16, I6)) *Int uvalueMInt(mi(16, I14))) <Int (2 ^Int 32)) andBool ((uvalueMInt(mi(32, B)) +Int uvalueMInt(mi(16, I5)) *Int uvalueMInt(mi(16, I13)) +Int uvalueMInt(mi(16, I6)) *Int uvalueMInt(mi(16, I14))) >=Int 0) then /*mi(32, I6 *Int I14 +Int I5 *Int I13 +Int B)*/ extractMInt ( mi ( 64 , ((I6 *Int I14) +Int (I5 *Int I13) +Int B) /*svalueMInt(mi(32, B)) +Int svalueMInt(mi(32, I3)) *Int svalueMInt(mi(32, I7))*/ ) , 32 , 64 ) else undefMInt32 )
         // S 16
         //"R0" |-> (mi(32, B:Int) => ifMInt ((svalueMInt(mi(32, B)) +Int svalueMInt(mi(16, I5)) *Int svalueMInt(mi(16, I13)) +Int svalueMInt(mi(16, I6)) *Int svalueMInt(mi(16, I14))) <Int (2 ^Int 31)) andBool ((svalueMInt(mi(32, B)) +Int svalueMInt(mi(16, I5)) *Int svalueMInt(mi(16, I13)) +Int svalueMInt(mi(16, I6)) *Int svalueMInt(mi(16, I14))) >=Int (-2 ^Int 31)) then /*mi(32, I6 *Int I14 +Int I5 *Int I13 +Int B)*/ extractMInt ( mi ( 64 , ((I6 *Int I14) +Int (I5 *Int I13) +Int B) ) , 32 , 64 ) else undefMInt32 )
         // S 8
         //"R0" |-> (mi(32, B:Int) => ifMInt ((svalueMInt(mi(8, I28)) *Int svalueMInt(mi(8, I12)) +Int svalueMInt(mi(8, I27)) *Int svalueMInt(mi(8, I11)) +Int svalueMInt(mi(8, I26)) *Int svalueMInt(mi(8, I10)) +Int svalueMInt(mi(8, I25)) *Int svalueMInt(mi(8, I9))/*((I9 *Int I25) +Int (I10 *Int I26) +Int (I11 *Int I27) +Int (I12 *Int I28)*/ +Int B) <Int (2 ^Int 31)) andBool ((svalueMInt(mi(8, I28)) *Int svalueMInt(mi(8, I12)) +Int svalueMInt(mi(8, I27)) *Int svalueMInt(mi(8, I11)) +Int svalueMInt(mi(8, I26)) *Int svalueMInt(mi(8, I10)) +Int svalueMInt(mi(8, I25)) *Int svalueMInt(mi(8, I9)))/*((I9 *Int I25) +Int (I10 *Int I26) +Int (I11 *Int I27) +Int (I12 *Int I28) +Int B)*/ >=Int (-2 ^Int 31)) then /*mi(32, I6 *Int I14 +Int I5 *Int I13 +Int B)*/ extractMInt ( mi ( 64 , ((I9 *Int I25) +Int (I10 *Int I26) +Int (I11 *Int I27) +Int (I12 *Int I28) +Int B) ) , 32 , 64 ) else undefMInt32 )
         //"R0" |-> (mi(32, B:Int) => ifMInt (/*(svalueMInt(mi(32, B)) +Int svalueMInt(mi(8, I28)) *Int svalueMInt(mi(8, I12)) +Int svalueMInt(mi(8, I27)) *Int svalueMInt(mi(8, I11)) +Int svalueMInt(mi(8, I26)) *Int svalueMInt(mi(8, I10)) +Int svalueMInt(mi(8, I25)) *Int svalueMInt(mi(8, I9))*/((I1 *Int I17) +Int (I2 *Int I18) +Int (I3 *Int I19) +Int (I4 *Int I20) +Int B) <Int (2 ^Int 31)) andBool (/*(svalueMInt(mi(32, B)) +Int svalueMInt(mi(8, I28)) *Int svalueMInt(mi(8, I12)) +Int svalueMInt(mi(8, I27)) *Int svalueMInt(mi(8, I11)) +Int svalueMInt(mi(8, I26)) *Int svalueMInt(mi(8, I10)) +Int svalueMInt(mi(8, I25)) *Int svalueMInt(mi(8, I9)))*/((I1 *Int I17) +Int (I2 *Int I18) +Int (I3 *Int I19) +Int (I4 *Int I20) +Int B) >=Int (-2 ^Int 31)) then /*mi(32, I6 *Int I14 +Int I5 *Int I13 +Int B)*/ extractMInt ( mi ( 64 , ((I1 *Int I17) +Int (I2 *Int I18) +Int (I3 *Int I19) +Int (I4 *Int I20) +Int B) ) , 32 , 64 ) else undefMInt32 )
         //"R0" |-> (mi(32, B:Int) => ifMInt ((svalueMInt(mi(8, I32)) *Int svalueMInt(mi(8, I16)) +Int svalueMInt(mi(8, I31)) *Int svalueMInt(mi(8, I15)) +Int svalueMInt(mi(8, I30)) *Int svalueMInt(mi(8, I14)) +Int svalueMInt(mi(8, I29)) *Int svalueMInt(mi(8, I13))/*((I9 *Int I25) +Int (I10 *Int I26) +Int (I11 *Int I27) +Int (I12 *Int I28)*/ +Int B) <Int (2 ^Int 31)) andBool ((svalueMInt(mi(8, I32)) *Int svalueMInt(mi(8, I16)) +Int svalueMInt(mi(8, I31)) *Int svalueMInt(mi(8, I15)) +Int svalueMInt(mi(8, I30)) *Int svalueMInt(mi(8, I14)) +Int svalueMInt(mi(8, I29)) *Int svalueMInt(mi(8, I13)))/*((I9 *Int I25) +Int (I10 *Int I26) +Int (I11 *Int I27) +Int (I12 *Int I28) +Int B)*/ >=Int (-2 ^Int 31)) then /*mi(32, I6 *Int I14 +Int I5 *Int I13 +Int B)*/ extractMInt ( mi ( 64 , ((I13 *Int I29) +Int (I14 *Int I30) +Int (I15 *Int I31) +Int (I16 *Int I32) +Int B) ) , 32 , 64 ) else undefMInt32 )
         "R0" |-> (mi(32, B:Int) => /*ifMInt sltMInt( addMInt(mi(32, B), zeroExtend(addMInt(mulMInt(mi(8, I32), mi(8, I16)), addMInt(mulMInt(mi(8, I31), mi(8, I15)), addMInt(mulMInt(mi(8, I30), mi(8, I14)), mulMInt(mi(8, I29), mi(8, I13))))), 32)), mi(32, 2147483648)) 
                                            andBool 
                                            sgeMInt( addMInt(mi(32, B), zeroExtend(addMInt(mulMInt(mi(8, I32), mi(8, I16)), addMInt(mulMInt(mi(8, I31), mi(8, I15)), addMInt(mulMInt(mi(8, I30), mi(8, I14)), mulMInt(mi(8, I29), mi(8, I13))))), 32)), mi(32, -2147483648)) then*/
                                          extractMInt ( mi ( 64 , ((I13 *Int I29) +Int (I14 *Int I30) +Int (I15 *Int I31) +Int (I16 *Int I32) +Int B) ) , 32 , 64 ) /*else undefMInt32*/ )
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
       </regstate>
          //requires  B >=Int -3836 /*(-2 ^Int 31 +Int 2 ^Int 16 -Int 2 ^Int 9)*/ andBool B <Int 23333/*(2 ^Int 31 -Int 2 ^Int 16)*/
            /*        andBool I1 >=Int (-2 ^Int 7) andBool I1 <Int (2 ^Int 7)
                    andBool I2 <Int (2 ^Int 7) andBool I2 >=Int (-2 ^Int 7)
                    andBool I3 >=Int (-2 ^Int 7) andBool I3 <Int (2 ^Int 7)
                    andBool I4 >=Int (-2 ^Int 7) andBool I4 <Int (2 ^Int 7)
                    andBool I5 >=Int (-2 ^Int 7) andBool I5 <Int (2 ^Int 7)
                    andBool I6 >=Int (-2 ^Int 7) andBool I6 <Int (2 ^Int 7)
                    andBool I7 >=Int (-2 ^Int 7) andBool I7 <Int (2 ^Int 7)
                    andBool I8 >=Int (-2 ^Int 7) andBool I8 <Int (2 ^Int 7)
                    andBool I9 >=Int (-2 ^Int 7) andBool I9 <Int (2 ^Int 7)
                    andBool I10 >=Int (-2 ^Int 7) andBool I10 <Int (2 ^Int 7)
                    andBool I11 >=Int (-2 ^Int 7) andBool I11 <Int (2 ^Int 7)
                    andBool I12 >=Int (-2 ^Int 7) andBool I12 <Int (2 ^Int 7)
                    andBool I13 >=Int (-2 ^Int 7) andBool I13 <Int (2 ^Int 7)
                    andBool I14 >=Int (-2 ^Int 7) andBool I14 <Int (2 ^Int 7)
                    andBool I15 >=Int (-2 ^Int 7) andBool I15 <Int (2 ^Int 7)
                    andBool I16 >=Int (-2 ^Int 7) andBool I16 <Int (2 ^Int 7)
                    andBool I17 >=Int (-2 ^Int 7) andBool I17 <Int (2 ^Int 7)
                    andBool I18 <Int (2 ^Int 7) andBool I18 >=Int (-2 ^Int 7)
                    andBool I19 >=Int (-2 ^Int 7) andBool I19 <Int (2 ^Int 7)
                    andBool I20 >=Int (-2 ^Int 7) andBool I20 <Int (2 ^Int 7)
                    andBool I21 >=Int (-2 ^Int 7) andBool I21 <Int (2 ^Int 7)
                    andBool I22 >=Int (-2 ^Int 7) andBool I22 <Int (2 ^Int 7)
                    andBool I23 >=Int (-2 ^Int 7) andBool I23 <Int (2 ^Int 7)
                    andBool I24 >=Int (-2 ^Int 7) andBool I24 <Int (2 ^Int 7)
                    andBool I25 >=Int (-2 ^Int 7) andBool I25 <Int (2 ^Int 7)
                    andBool I26 >=Int (-2 ^Int 7) andBool I26 <Int (2 ^Int 7)
                    andBool I27 >=Int (-2 ^Int 7) andBool I27 <Int (2 ^Int 7)
                    andBool I28 >=Int (-2 ^Int 7) andBool I28 <Int (2 ^Int 7)
                    andBool I29 >=Int (-2 ^Int 7) andBool I29 <Int (2 ^Int 7)
                    andBool I30 >=Int (-2 ^Int 7) andBool I30 <Int (2 ^Int 7)
                    andBool I31 >=Int (-2 ^Int 7) andBool I31 <Int (2 ^Int 7)
                    andBool I32 >=Int (-2 ^Int 7) andBool I32 <Int (2 ^Int 7)*/
          requires /*I1 >=Int -64 andBool I1 <=Int 31
              andBool I2 >=Int -25 andBool I2 <=Int 24
              andBool I3 >=Int -26 andBool I3 <=Int 22
              andBool I4 >=Int -24 andBool I4 <=Int 19
              andBool I5 >=Int -12 andBool I5 <=Int 4
              andBool I6 >=Int -11 andBool I6 <=Int 5
              andBool I7 >=Int -32 andBool I7 <=Int 0
              andBool I8 >=Int -12 andBool I8 <=Int 59

              andBool I9 >=Int -37 andBool I9 <=Int 31 //(2 ^Int 7 -Int 1) //31
              andBool I10 >=Int -2 andBool I10 <=Int 27 //(2 ^Int 7 -Int 1) //27
              andBool I11 >=Int 23 andBool I11 <=Int 54
              andBool I12 >=Int 12 andBool I12 <=Int 89 // (2 ^Int 7 -Int 1) */

              I13 >=Int 13 andBool I13 <=Int 88
              andBool I14 >=Int -15 andBool I14 <=Int 55
              andBool I15 >=Int 20 andBool I15 <=Int 112
              andBool I16 >=Int 12 andBool I16 <=Int 111
              /*andBool I17 >=Int -64 andBool I17 <=Int 31
              andBool I18 >=Int -25 andBool I18 <=Int 24
              andBool I19 >=Int -26 andBool I19 <=Int 22
              andBool I20 >=Int -24 andBool I20 <=Int 19
              andBool I21 >=Int -12 andBool I21 <=Int 4
              andBool I22 >=Int -11 andBool I22 <=Int 5
              andBool I23 >=Int -32 andBool I23 <=Int 0
              andBool I24 >=Int -12 andBool I24 <=Int 59

              andBool I25 >=Int 0 andBool I25 <=Int 31
              andBool I26 >=Int -2 andBool I26 <=Int 27
              andBool I27 >=Int 23 andBool I27 <=Int 54
              andBool I28 >=Int 12 andBool I28 <=Int 89*/
              
              andBool I29 >=Int -13 andBool I29 <=Int 88
              andBool I30 >=Int 15 andBool I30 <=Int 55
              andBool I31 >=Int -20 andBool I31 <=Int 112
              andBool I32 >=Int 12 andBool I32 <=Int 111
              andBool B >=Int -3836 andBool B <=Int 2147448013
          ensures ((I13 *Int I29) +Int (I14 *Int I30) +Int (I15 *Int I31) +Int (I16 *Int I32) +Int B) <Int (2 ^Int 31)
            andBool ((I13 *Int I29) +Int (I14 *Int I30) +Int (I15 *Int I31) +Int (I16 *Int I32) +Int B) >=Int -1 *Int (2 ^Int 31)


          // U16 B >=Int 0 /*(-2 ^Int 16)*/ andBool B <Int (2 ^Int 17 +Int 2 ^Int 16 -Int 2)
                    // andBool I2 <Int (2 ^Int 16) andBool I2 >=Int 0 /*(-2 ^Int 15)*/ U16
                    //andBool I10 <Int (2 ^Int 15) andBool I10 >=Int  0
                    //andBool I1 >=Int 0 /*(-2 ^Int 15)*/ andBool I1 <Int (2 ^Int 15)
                    //andBool I3 >=Int 0 /*(-2 ^Int 15)*/ andBool I3 <Int (2 ^Int 15)
                    //andBool I4 >=Int 0 /*(-2 ^Int 15)*/ andBool I4 <Int (2 ^Int 15)
                    //andBool I5 >=Int 0 /*(-2 ^Int 15)*/ andBool I5 <Int (2 ^Int 16)
                    //andBool I6 >=Int 0 /*(-2 ^Int 15)*/ andBool I6 <Int (2 ^Int 16)
                    //andBool I9 >=Int 0 andBool I9 <Int (2 ^Int 16)
                    // andBool I12 >=Int 0 andBool I12 <Int (2 ^Int 16)
                    //andBool I13 >=Int 0 andBool I13 <Int (2 ^Int 15)
                    //andBool I14 >=Int 0 andBool I14 <Int (2 ^Int 15)
                    //andBool I15 >=Int 0 andBool I15 <Int (2 ^Int 16)
                    //andBool I16 >=Int 0 andBool I16 <Int (2 ^Int 16)
/*        // S16          B >=Int (-2 ^Int 15) andBool B <Int (2 ^Int 17 -Int 2)
                    andBool I2 <Int (2 ^Int 15) andBool I2 >=Int (-2 ^Int 15)
                    andBool I1 >=Int (-2 ^Int 15) andBool I1 <Int (2 ^Int 15)
                    andBool I3 >=Int (-2 ^Int 15) andBool I3 <Int (2 ^Int 15)
                    andBool I4 >=Int (-2 ^Int 15) andBool I4 <Int (2 ^Int 15)
                    andBool I5 >=Int (-2 ^Int 14) andBool I5 <Int (2 ^Int 15)
                    andBool I6 >=Int (-2 ^Int 14) andBool I6 <Int (2 ^Int 15)
                    andBool I7 >=Int (-2 ^Int 15) andBool I7 <Int (2 ^Int 15)
                    andBool I8 >=Int (-2 ^Int 15) andBool I8 <Int (2 ^Int 15)
                    andBool I9 >=Int (-2 ^Int 15) andBool I9 <Int (2 ^Int 15)
                    andBool I10 >=Int (-2 ^Int 15) andBool I10 <Int (2 ^Int 15)
                    andBool I11 >=Int 0 andBool I11 <Int (2 ^Int 15)
                    andBool I12 >=Int (-2 ^Int 15) andBool I12 <Int (2 ^Int 15)
                    andBool I13 >=Int (-2 ^Int 14) andBool I13 <Int (2 ^Int 15)
                    andBool I14 >=Int (-2 ^Int 14) andBool I14 <Int (2 ^Int 15)
                    andBool I15 >=Int (-2 ^Int 15) andBool I15 <Int (2 ^Int 15)
                    andBool I16 >=Int (-2 ^Int 15) andBool I16 <Int (2 ^Int 15)
*/
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
