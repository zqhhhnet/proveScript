require "armv8-configuration.k"

/*
    abstract compare   
 */

module CMPABS
  imports ARMV8-CONFIGURATION
  
  /*@
    when I1 equal to 0, cmp gets max one, cmp gets min others.
    I2 for the index of elements
  */
  
  rule <k> execinstr(cmpAbs:StepCommand . S:Label Rd:R32, Qd:Q128, (# I1:Int):Imm, (# I2:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> 
                ifMInt (I1 ==Int 0) then 
                    ifMInt (S ==K S32) then
                        LeftAbsMaxMIntOfInt(getVecParentValue(Qd, I2, RSMap), getParentValue(Rd, RSMap), 32, RSMap)
                    else ifMInt (S ==K S16) then
                        signExtend(LeftAbsMaxMIntOfInt(extractMInt(getVecParentValue(Qd, I2 /Int 2, RSMap), 16 *Int ( 1 -Int (I2 %Int 2)), 16 *Int (2 -Int (I2 %Int 2))), extractMInt(getParentValue(Rd, RSMap), 16, 32), 16, RSMap), 32)
                    else ifMInt (S ==K S8) then
                        signExtend(LeftAbsMaxMIntOfInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), 8 *Int (3 -Int (I2 %Int 4)), 8 *Int (4 -Int (I2 %Int 4))), extractMInt(getParentValue(Rd, RSMap), 24, 32), 8, RSMap), 32)
                    else
                        undefMInt32
                else
                    ifMInt (S ==K S32) then
                        LeftAbsMinMIntOfInt(getVecParentValue(Qd, I2, RSMap), getParentValue(Rd, RSMap), 32, RSMap)
                    else ifMInt (S ==K S16) then
                        signExtend(LeftAbsMinMIntOfInt(extractMInt(getVecParentValue(Qd, I2 /Int 2, RSMap), 16 *Int ( 1 -Int (I2 %Int 2)), 16 *Int (2 -Int (I2 %Int 2))), extractMInt(getParentValue(Rd, RSMap), 16, 32), 16, RSMap), 32)
                    else ifMInt (S ==K S8) then
                        signExtend(LeftAbsMinMIntOfInt(extractMInt(getVecParentValue(Qd, I2 /Int 4, RSMap), 8 *Int (3 -Int (I2 %Int 4)), 8 *Int (4 -Int (I2 %Int 4))), extractMInt(getParentValue(Rd, RSMap), 24, 32), 8, RSMap), 32)
                    else
                        undefMInt32
         
       ) </regstate>
            requires (S ==K S32 andBool (I2 >=Int 0 andBool I2 <=Int 3))
                orBool (S ==K S16 andBool (I2 >=Int 0 andBool I2 <=Int 7))
                orBool (S ==K S8 andBool (I2 >=Int 0 andBool I2 <=Int 15))
  
endmodule