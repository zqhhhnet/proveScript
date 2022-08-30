require "armv8-configuration.k"

module ADD-FOR-TEST
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(ADD:Opcode) => . ...</k>
       <regstate> RSMap:Map </regstate>
  
  rule <k> execinstr(ADD:Opcode Rd:R32, Rn:R32, Rm:R32, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> addMInt(getParentValue(Rn, RSMap), getParentValue(Rm, RSMap))
         )
       </regstate>
         
  
endmodule
