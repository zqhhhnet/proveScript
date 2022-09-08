require "armv8-configuration.k"

module MAX-FOR-TEST
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(MAX:Opcode) => . ...</k>
       <regstate> RSMap:Map </regstate>
  
  rule <k> execinstr(MAX:Opcode Rd:R32, Rn:R32, Rm:R32, .Operands) => . ...</k>
       <regstate> 
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> /* mi(32, maxInt(uvalueMInt(getParentValue(Rn, RSMap)), uvalueMInt(getParentValue(Rm, RSMap)))) */ ifMInt (uvalueMInt(getParentValue(Rn, RSMap)) >=Int uvalueMInt(getParentValue(Rm, RSMap))) then (getParentValue(Rn, RSMap)) else (getParentValue(Rm, RSMap))
         )
       </regstate>
endmodule
