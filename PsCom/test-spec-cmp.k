require "armv8-semantics.k"

module TEST-SPEC-CMP

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( cmp . U32 r0 , q0, (# C):Imm , (# D:Int):Imm, (# E):Imm, .Operands) //storedInstr ( cmp . U32 r0 , q0, (# C:Int):Imm , (# D:Int):Imm, (# E:Int):Imm, .Operands)
         memloc(mi(32, 1)) |-> storedInstr ( end .Operands ) )
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
         /*
         "Q0" |-> mi(128, A:Int)
         "R0" |-> mi(32, B:Int)
         "TEMP1" |-> extractMInt(mi(128, A), 120, 128)
         "TEMP2" |-> extractMInt(mi(32, B) , 24, 32)
         "V_TEMP1" |-> svalueMInt(extractMInt(mi(128, A), 120, 128))
         "V_TEMP2" |-> svalueMInt(extractMInt(mi(32, B) , 24, 32))
         */
         /*
         "V_TEMP1" |-> A
         "V_TEMP2" |-> B
         */

         
         "Q0" |-> concatenateMInt(mi(32, X:Int), concatenateMInt( mi(32, Y:Int), concatenateMInt( mi(32, J:Int), mi(32, Z:Int))))
         "S0" |-> mi(32, Z)
         "S1" |-> mi(32, J)
         "S2" |-> mi(32, Y)
         "S3" |-> mi(32, X)
         /*
         "R0" |-> (mi(32, A) =>  (ifMInt (C ==Int 0) then ( ifMInt (E ==Int 0) then (signExtend( ifMInt ( A <Int (ifInt (D ==Int 0) then (Z) else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) ) ) then ( mi(32, (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) )) ) else ( mi(32, A) ), 32)) else (zeroExtend( ifMInt ( A <Int (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) ) ) then ( mi(32, (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) )) ) else ( mi(32, A) ), 32)) ) else ( ifMInt (E ==Int 0) then (signExtend( ifMInt ( A >Int (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) ) ) then ( mi(32, (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) )) ) else ( mi(32, A) ), 32)) else (zeroExtend( ifMInt ( A >Int (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) ) ) then ( mi(32, (ifInt (D ==Int 0)  then (Z)  else ( ifInt (D ==Int 1) then (J) else ( ifInt (D ==Int 2) then (Y) else (X) ) ) )) ) else ( mi(32, A) ), 32)) ) ) )
         //"RESULT" |-> ifMInt (C ==Int 0) then ( ifMInt (A <=Int B) then (signExtend(mi(32, B), 32)) else (signExtend(mi(32, A), 32)) ) else ( ifMInt (A <=Int B) then (signExtend(mi(32, A), 32)) else (signExtend(mi(32, B), 32)) )
         */
         "R0" |-> (mi(32, A) => ifMInt C ==K 0 then ifMInt E ==K 0 then ifMInt A >Int uvalueMInt ( getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) ) then mi ( 32 , A ) else getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) else ifMInt A >Int uvalueMInt ( getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) ) then mi ( 32 , A ) else getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) else ifMInt E ==K 0 then ifMInt A <Int uvalueMInt ( getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) ) then mi ( 32 , A ) else getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) else ifMInt A <Int uvalueMInt ( getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ) ) then mi ( 32 , A ) else getRegisterValue ( convSubVecRegsToRegs ( q0 , D ) , "Q0" |-> concatenateMInt ( mi ( 32 , X ) , concatenateMInt ( mi ( 32 , Y ) , concatenateMInt ( mi ( 32 , J ) , mi ( 32 , Z ) ) ) )
              "R0" |-> mi ( 32 , A )
              "R15" |-> memloc ( mi(32, 1) )
              "S0" |-> mi ( 32 , Z )
              "S1" |-> mi ( 32 , J )
              "S2" |-> mi ( 32 , Y )
              "S3" |-> mi ( 32 , X ) ))
/*
         "Q0" |-> mi(128, 4294967296)
         "S0" |-> mi(32, 0)
         "S1" |-> mi(32, 1)
         "R0" |-> (mi(32, 0) => mi(32, 1))
        */
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 2)))
       </regstate>
          requires X >=Int 0 andBool X <Int (2 ^Int 32) -Int 1
                  andBool Y >=Int 0 andBool Y <Int (2 ^Int 32) -Int 1
                  andBool J >=Int 0 andBool J <Int (2 ^Int 32) -Int 1
                  andBool Z >=Int 0 andBool Z <Int (2 ^Int 32) -Int 1
                  andBool A >=Int 0 andBool A <Int (2 ^Int 32) -Int 1
                  andBool C >=Int 0 andBool C <=Int 1
                  andBool E >=Int 0 andBool E <=Int 1
                  andBool D >=Int 0 andBool D <=Int 3
           
endmodule
