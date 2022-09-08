/*@
    get unsigned integer value of MInt
*/

require "armv8-configuration.k"

module UINT
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(uint:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(uint:StepCommand (# I1:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "V_TEMP3" |-> uvalueMInt(mi(32, I1))
         
       ) </regstate>
       
    
endmodule
