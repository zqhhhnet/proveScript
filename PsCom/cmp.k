/*@
    compare of max or min
*/


require "armv8-configuration.k"

module CMP
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(dtc:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  /*@
    for test
    when I equal to 0, cmp gets max one,
    cmp gets min others.
  */
  /*@
  rule <k> execinstr(cmp:StepCommand . S:Label Rd:R32, Qd:Q128, (# I:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "RESULT" |-> ifMInt (I ==Int 0) then ( ifMInt (getRegI("V_TEMP1", RSMap) <=Int getRegI("V_TEMP2", RSMap)) then (signExtend( (ifMInt ((S ==K S8) orBool (S ==K U8)) then mi(8, getRegI("V_TEMP2", RSMap)) else (ifMInt ((S ==K S16) orBool (S ==K U16)) then mi(16, getRegI("V_TEMP2", RSMap)) else (ifMInt ((S ==K S32) orBool (S ==K U32)) then (mi(32, getRegI("V_TEMP2", RSMap))) else (undefMInt) ))), 32)) else ( signExtend( (ifMInt ((S ==K S8) orBool (S ==K U8)) then mi(8, getRegI("V_TEMP1", RSMap)) else (ifMInt ((S ==K S16) orBool (S ==K U16)) then mi(16, getRegI("V_TEMP1", RSMap)) else (ifMInt ((S ==K S32) orBool (S ==K U32)) then (mi(32, getRegI("V_TEMP1", RSMap))) else (undefMInt) ))), 32) ) ) else ( ifMInt (getRegI("V_TEMP1", RSMap) <=Int getRegI("V_TEMP2", RSMap)) then (signExtend( (ifMInt ((S ==K S8) orBool (S ==K U8)) then mi(8, getRegI("V_TEMP1", RSMap)) else (ifMInt ((S ==K S16) orBool (S ==K U16)) then mi(16, getRegI("V_TEMP1", RSMap)) else (ifMInt ((S ==K S32) orBool (S ==K U32)) then (mi(32, getRegI("V_TEMP1", RSMap))) else (undefMInt) ))), 32)) else ( signExtend( (ifMInt ((S ==K S8) orBool (S ==K U8)) then mi(8, getRegI("V_TEMP2", RSMap)) else (ifMInt ((S ==K S16) orBool (S ==K U16)) then mi(16, getRegI("V_TEMP2", RSMap)) else (ifMInt ((S ==K S32) orBool (S ==K U32)) then (mi(32, getRegI("V_TEMP2", RSMap))) else (undefMInt) ))), 32) ) )
         
       ) </regstate>
  */

  /*@
    for step by step, R is destination register
    I1 for cmp mode, 0 for max, 1 for min
    I2 for the element index of Qd to compare 
    I3 for extend the bitvector mode, 0 for signExtend, 1 for zeroExtend
    decide type of Int or Float by S
   */
  rule <k> execinstr(cmp:StepCommand . S:Label Rd:R32, Qd:Q128, (# I1:Int):Imm, (# I2:Int):Imm, (# I3:Int):Imm, .Operands) => .
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> ifMInt (I1 ==Int 0) 
                                  then ( ifMInt (I3 ==Int 0) 
                                    then ( signExtend( ifMInt (S ==K S32)
                                      then ( ifMInt (svalueMInt(getParentValue(Rd, RSMap)) >Int svalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd, RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K U32)
                                      then ( ifMInt (uvalueMInt(getParentValue(Rd, RSMap)) >Int uvalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd,RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K S16)
                                      then ( ifMInt (svalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) >Int svalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                      else ( ifMInt (S ==K U16)
                                      then ( ifMInt (uvalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) >Int uvalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) ) 
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)))
                                      else ( ifMInt (S ==K S8)
                                      then ( ifMInt ( svalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) >Int svalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8) ) )
                                        then (extractMInt(getParentValue(Rd, RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      else ( ifMInt (S ==K U8)
                                      then ( ifMInt (uvalueMInt(extractMInt(getParentValue(Rd,RSMap), 24, 32)) >Int uvalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)))
                                        then (extractMInt(getParentValue(Rd,RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      // TODO for FP
                                      else (undefMInt32) ) ) ) ) ) , 32) ) 
                                    else (  
                                      zeroExtend( ifMInt (S ==K S32)
                                      then ( ifMInt (svalueMInt(getParentValue(Rd, RSMap)) >Int svalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd, RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K U32)
                                      then ( ifMInt (uvalueMInt(getParentValue(Rd, RSMap)) >Int uvalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd,RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K S16)
                                      then ( ifMInt (svalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) >Int svalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                      else ( ifMInt (S ==K U16)
                                      then ( ifMInt (uvalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) >Int uvalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) ) 
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)))
                                      else ( ifMInt (S ==K S8)
                                      then ( ifMInt ( svalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) >Int svalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8) ) )
                                        then (extractMInt(getParentValue(Rd, RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      else ( ifMInt (S ==K U8)
                                      then ( ifMInt (uvalueMInt(extractMInt(getParentValue(Rd,RSMap), 24, 32)) >Int uvalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)))
                                        then (extractMInt(getParentValue(Rd,RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      // TODO for FP
                                      else (undefMInt32) ) ) ) ) ) , 32)
                                    ) ) 
                                  else ( ifMInt (I3 ==Int 0) 
                                    then ( signExtend( ifMInt (S ==K S32)
                                      then ( ifMInt (svalueMInt(getParentValue(Rd, RSMap)) <Int svalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd, RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K U32)
                                      then ( ifMInt (uvalueMInt(getParentValue(Rd, RSMap)) <Int uvalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd,RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K S16)
                                      then ( ifMInt (svalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) <Int svalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                      else ( ifMInt (S ==K U16)
                                      then ( ifMInt (uvalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) <Int uvalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) ) 
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)))
                                      else ( ifMInt (S ==K S8)
                                      then ( ifMInt ( svalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) <Int svalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8) ) )
                                        then (extractMInt(getParentValue(Rd, RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      else ( ifMInt (S ==K U8)
                                      then ( ifMInt (uvalueMInt(extractMInt(getParentValue(Rd,RSMap), 24, 32)) <Int uvalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)))
                                        then (extractMInt(getParentValue(Rd,RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      // TODO for FP
                                      else (undefMInt32) ) ) ) ) ) , 32) ) 
                                    else (  
                                      zeroExtend( ifMInt (S ==K S32)
                                      then ( ifMInt (svalueMInt(getParentValue(Rd, RSMap)) <Int svalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd, RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K U32)
                                      then ( ifMInt (uvalueMInt(getParentValue(Rd, RSMap)) <Int uvalueMInt(getVecParentValue(Qd, I2, RSMap)))
                                        then (getParentValue(Rd,RSMap))
                                        else (getVecParentValue(Qd, I2, RSMap)) )
                                      else ( ifMInt (S ==K S16)
                                      then ( ifMInt (svalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) <Int svalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) )
                                      else ( ifMInt (S ==K U16)
                                      then ( ifMInt (uvalueMInt( extractMInt(getParentValue(Rd,RSMap), 16, 32) ) <Int uvalueMInt(extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)) ) 
                                        then (extractMInt(getParentValue(Rd,RSMap), 16, 32))
                                        else (extractMInt(getVecParentValue(Qd,I2 /Int 2, RSMap), (1 -Int (I2 %Int 2)) *Int 16, (2 -Int (I2 %Int 2)) *Int 16)))
                                      else ( ifMInt (S ==K S8)
                                      then ( ifMInt ( svalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) <Int svalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8) ) )
                                        then (extractMInt(getParentValue(Rd, RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      else ( ifMInt (S ==K U8)
                                      then ( ifMInt (uvalueMInt(extractMInt(getParentValue(Rd,RSMap), 24, 32)) <Int uvalueMInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)))
                                        then (extractMInt(getParentValue(Rd,RSMap), 24, 32))
                                        else (extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), (3 -Int (I2 %Int 4)) *Int 8, (4 -Int (I2 %Int 4)) *Int 8)) )
                                      // TODO for FP
                                      else (undefMInt32) ) ) ) ) ) , 32)
                                    ) )
         
         )
       </regstate>
          requires (I1 ==Int 0 orBool I1 ==Int 1) andBool
                   (I3 ==Int 0 orBool I3 ==Int 1) andBool
                   ( ( (S ==K S32 orBool S ==K U32 orBool S ==K F32) andBool I2 >=Int 0 andBool I2 <=Int 3) orBool
                     ( (S ==K S16 orBool S ==K U16 orBool S ==K F16) andBool I2 >=Int 0 andBool I2 <=Int 7) orBool
                     ( (S ==K S8 orBool S ==K U8) andBool I2 >=Int 0 andBool I2 <=Int 15)
                   )
  
  // TODO: for vertor compare vector
  /*@
  rule <k> execinstr(cmp:StepCommand . S:Label Qd:Q128, Qn:Q128, Qm:Q128, (# I1:Int):Imm, (# I2:Int):Imm, (# I3:Int):Imm, .Operands) => .
        ...</k>
      <regstate> RSMap:Map => updateMap(RSMap,

      )

      </regstate>
      */

endmodule
