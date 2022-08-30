/*@
    get signed integer value of MInt
*/

require "armv8-configuration.k"

module SINT
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(sint:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(sint:StepCommand (# I1:Int):Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "V_TEMP3" |-> svalueMInt(mi(32, I1))
         
       ) </regstate>
       
    
endmodule
