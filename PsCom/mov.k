require "armv8-configuration.k"

module MOV
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(MOV:Opcode) => . ...</k>
       <regstate> 
         RSMap:Map
          => updateMap(RSMap,
           "RESULT" |-> mi(32, 0)
           //"RESULT64" |-> mi(64, 0)
         )
         
       
       </regstate>
  
  rule <k> execinstr(MOV:Opcode Rd:R32, Imm32:Imm, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> mi(32, modImm32(Imm32))
       )
       </regstate>
  
  rule <k> execinstr(MOV:Opcode Rd:R32, Rm:R32, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> getParentValue(Rm, RSMap)
       )
       </regstate>
  
  rule <k> execinstr(MOV:Opcode Sd:S32, Imm32:Imm, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Sd) |-> mi(32, modImm32(Imm32))
       )
       </regstate>
  
  rule <k> execinstr(MOV:Opcode Dd:D64, Imm64:Imm, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Dd, 0) |-> extractMInt(mi(64, modImm64(Imm64)), 32, 64)
           
           convVecToRegKeys(Dd, 1) |-> extractMInt(mi(64, modImm64(Imm64)), 0, 32)
           
           convToRegKeys(Dd) |-> mi(64, modImm64(Imm64))
       )
       </regstate>

endmodule
