/*@
    concatenate bits of MInt
*/

require "armv8-configuration.k"

module CONCA
  imports ARMV8-CONFIGURATION
  
  /*
  rule <k> setDefaultRegs(conca:StepCommand) => . ... </k>
       <regstate>
         RSMap:Map
       </regstate>
  */
  
  rule <k> execinstr(conca:StepCommand I1:Imm, I2:Imm, .Operands) => . 
       ...</k>
       <regstate> RSMap:Map => updateMap(RSMap,
         "TEMP4" |-> concatenateMInt(mi(32, modImm32(I1)), mi(32, modImm32(I2)))
         
       ) </regstate>
       
    
endmodule
