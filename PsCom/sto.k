/*@
    store value to register
*/

require "armv8-configuration.k"

module STO
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(dtc:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(sto:StepCommand Rd:R32, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         convToRegKeys(Rd) |-> getParentValue(result, RSMap)
         
       ) </regstate>
  
  rule <k> execinstr(sto:StepCommand Qd:Q128, (# I:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         convVecToRegKeys(Qd, I) |-> getParentValue(result, RSMap)
         
         convToRegKeys(Qd) |-> ifMInt ((I <=Int 3) andBool (I >=Int 0)) then plugInMask(getParentValue(Qd, RSMap), getParentValue(result, RSMap), (I *Int 32)) else (undefMInt)
         
       ) </regstate>
         requires (I >=Int 0) andBool (I <=Int 3)
  
endmodule
