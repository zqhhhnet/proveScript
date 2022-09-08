/*@ 
    data size check and set to temporary variable
*/

require "armv8-configuration.k"

module DTC
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(dtc:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(dtc:StepCommand . S:Label Qd:Q128, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "V_TEMP1" |->  ifInt ((S ==K S8) orBool (S ==K S16) orBool (S ==K S32)) then svalueMInt(getReg("TEMP1", RSMap)) else (ifInt (((S ==K U8) orBool (S ==K U16)) orBool (S ==K U32)) then uvalueMInt(getReg("TEMP1", RSMap)) else (-1) /*( ifMInt (((S ==K F16) orBool (S ==K F32)) orBool (S ==K F64) ) then extractMInt(getParentValue(Qd, RSMap), (128 -Int I1 -Int 32), (128 -Int I1)) else (undefMInt) )*/)
         
       ) </regstate>
       
  rule <k> execinstr(dtc:StepCommand . S:Label Rd:R32, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "V_TEMP2" |->  ifInt ((S ==K S8) orBool (S ==K S16) orBool (S ==K S32)) then svalueMInt(getReg("TEMP2", RSMap)) else (ifInt (((S ==K U8) orBool (S ==K U16)) orBool (S ==K U32)) then uvalueMInt(getReg("TEMP2", RSMap)) else (-1) /*( ifMInt (((S ==K F16) orBool (S ==K F32)) orBool (S ==K F64) ) then extractMInt(getParentValue(Qd, RSMap), (128 -Int I1 -Int 32), (128 -Int I1)) else (undefMInt) )*/)
         
       ) </regstate>
  
endmodule
