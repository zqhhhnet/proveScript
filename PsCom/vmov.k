require "armv8-configuration.k"

module VMOV
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(VMOV:Opcode) => . ...</k>
       <regstate> 
       RSMap:Map => updateMap(RSMap,
           "RESULT" |-> mi(32, 0)
           "RESULT64" |-> mi(64, 0)
         )
       
       </regstate>
  
  rule <k> execinstrBeat(VMOV:Opcode Qd:Q128, Imm128:Imm, .Operands, I:Int) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Qd) |-> mi(128, modImm128(Imm128))
         
           convVecToRegKeys(Qd, I) |-> extractMInt(Imm2MInt(Imm128, 128, 128), (96 -Int 32 *Int I), (128 -Int 32 *Int I))
         
       )
       </regstate>
       
  rule <k> execinstrBeat(VMOV:Opcode Qd:Q128, Qs:Q128, .Operands, I:Int) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Qd, I) |-> getVecParentValue(Qs, I, RSMap)
	   
	   convToRegKeys(Qd) |-> getParentValue(Qs, RSMap)
         )
       </regstate>
      
  
  
  rule <k> execinstr(VMOV:Opcode . ($ S:Int):NLabel (Qd:Q128 [I:Int]):Q128, Rn:R32, .Operands) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Qd, (I /Int (32 /Int S))) |-> plugInMask(getVecParentValue(Qd, (I /Int (32 /Int S)), RSMap), extractMInt(getParentValue(Rn, RSMap), (32 -Int S), 32), (I %Int (32 /Int S)) *Int S)
           convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap), extractMInt(getParentValue(Rn, RSMap), (32 -Int S), 32), (I *Int S))
         )
       </regstate>
         requires I >=Int 0 andBool I <Int 16 andBool (S ==Int 8 orBool S ==Int 16 orBool S ==Int 32)
         

endmodule
