/*@
    extrcat bits of MInt
*/

require "armv8-configuration.k"

module EXT
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(ext:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(ext:StepCommand . S:Label Qd:Q128, (# I1:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "TEMP1" |-> ifMInt ((I1 >=Int 0) andBool (I1 <Int 128)) then ( ifMInt ((S ==K S8) orBool (S ==K U8)) then extractMInt(getParentValue(Qd, RSMap), (128 -Int I1 -Int 8), (128 -Int I1)) else (ifMInt (((S ==K S16) orBool (S ==K U16)) /*orBool (S ==K F16)*/) then extractMInt(getParentValue(Qd, RSMap), (128 -Int I1 -Int 16), (128 -Int I1)) else ( ifMInt (((S ==K S32) orBool (S ==K U32)) /*orBool (S ==K F32)*/ ) then extractMInt(getParentValue(Qd, RSMap), (128 -Int I1 -Int 32), (128 -Int I1)) else (undefMInt) ))) else undefMInt
         
       ) </regstate>
       
  rule <k> execinstr(ext:StepCommand . S:Label Rd:R32, (# I1:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "TEMP2" |-> ifMInt ((I1 >=Int 0) andBool (I1 <Int 32)) then ( ifMInt ((S ==K S8) orBool (S ==K U8)) then extractMInt(getParentValue(Rd, RSMap), (32 -Int I1 -Int 8), (32 -Int I1)) else (ifMInt (((S ==K S16) orBool (S ==K U16)) /*orBool (S ==K F16)*/) then extractMInt(getParentValue(Rd, RSMap), (32 -Int I1 -Int 16), (32 -Int I1)) else ( ifMInt (((S ==K S32) orBool (S ==K U32)) /*orBool (S ==K F32)*/ ) then extractMInt(getParentValue(Rd, RSMap), (32 -Int I1 -Int 32), (32 -Int I1)) else (undefMInt) ))) else undefMInt
         
       ) </regstate>
    
endmodule
