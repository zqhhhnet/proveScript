require "armv8-configuration.k"

module VMAX11
  imports ARMV8-CONFIGURATION
  
  /*
  rule S8:Label => mi(3, 0)
  rule U8:Label => mi(3, 1)
  rule S16:Label => mi(3, 2)
  rule U16:Label => mi(3, 3)
  rule S32:Label => mi(3, 4)
  rule U32:Label => mi(3, 5)
  */
  
  rule <k> execinstr(vmax:Opcode . S:Label Qd:Q128, Qm:Q128, Qn:Q128, Opreands) => .
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
         convToRegKeys(Qd) |-> /* S8 size */ ifMInt (S ==K S8) then concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 0, 8), extractMInt(getParentValue(Qn, RSMap), 0, 8)) then extractMInt(getParentValue(Qm, RSMap), 0, 8) else extractMInt(getParentValue(Qn, RSMap), 0, 8)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 8, 16), extractMInt(getParentValue(Qn, RSMap), 8, 16)) then extractMInt(getParentValue(Qm, RSMap), 8, 16) else extractMInt(getParentValue(Qn, RSMap), 8, 16)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 16, 24), extractMInt(getParentValue(Qn, RSMap), 16, 24)) then extractMInt(getParentValue(Qm, RSMap), 16, 24) else extractMInt(getParentValue(Qn, RSMap), 16, 24)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 24, 32), extractMInt(getParentValue(Qn, RSMap), 24, 32)) then extractMInt(getParentValue(Qm, RSMap), 24, 32) else extractMInt(getParentValue(Qn, RSMap), 24, 32)), concatenateMInt((ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 32, 40), extractMInt(getParentValue(Qn, RSMap), 32, 40)) then extractMInt(getParentValue(Qm, RSMap), 32, 40) else extractMInt(getParentValue(Qn, RSMap), 32, 40)), concatenateMInt((ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 40, 48), extractMInt(getParentValue(Qn, RSMap), 40, 48)) then extractMInt(getParentValue(Qm, RSMap), 40, 48) else extractMInt(getParentValue(Qn, RSMap), 40, 48)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 48, 56), extractMInt(getParentValue(Qn, RSMap), 48, 56)) then extractMInt(getParentValue(Qm, RSMap), 48, 56) else extractMInt(getParentValue(Qn, RSMap), 48, 56)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 56, 64), extractMInt(getParentValue(Qn, RSMap), 56, 64)) then extractMInt(getParentValue(Qm, RSMap), 56, 64) else extractMInt(getParentValue(Qn, RSMap), 56, 64)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 64, 72), extractMInt(getParentValue(Qn, RSMap), 64, 72)) then extractMInt(getParentValue(Qm, RSMap), 64, 72) else extractMInt(getParentValue(Qn, RSMap), 64, 72)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 72, 80), extractMInt(getParentValue(Qn, RSMap), 72, 80)) then extractMInt(getParentValue(Qm, RSMap), 72, 80) else extractMInt(getParentValue(Qn, RSMap), 72, 80)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 80, 88), extractMInt(getParentValue(Qn, RSMap), 80, 88)) then extractMInt(getParentValue(Qm, RSMap), 80, 88) else extractMInt(getParentValue(Qn, RSMap), 80, 88)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 88, 96), extractMInt(getParentValue(Qn, RSMap), 88, 96)) then extractMInt(getParentValue(Qm, RSMap), 88, 96) else extractMInt(getParentValue(Qn, RSMap), 88, 96)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 96, 104), extractMInt(getParentValue(Qn, RSMap), 96, 104)) then extractMInt(getParentValue(Qm, RSMap), 96, 104) else extractMInt(getParentValue(Qn, RSMap), 96, 104)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 104, 112), extractMInt(getParentValue(Qn, RSMap), 104, 112)) then extractMInt(getParentValue(Qm, RSMap), 104, 112) else extractMInt(getParentValue(Qn, RSMap), 104, 112)), concatenateMInt( (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 112, 120), extractMInt(getParentValue(Qn, RSMap), 112, 120)) then extractMInt(getParentValue(Qm, RSMap), 112, 120) else extractMInt(getParentValue(Qn, RSMap), 112, 120)), (ifMInt sgeMInt( extractMInt(getParentValue(Qm, RSMap), 120, 128), extractMInt(getParentValue(Qn, RSMap), 120, 128)) then extractMInt(getParentValue(Qm, RSMap), 120, 128) else extractMInt(getParentValue(Qn, RSMap), 120, 128)) )))))))))))))))
         
         else /* exception */ mi(128, -1)
         
         )
       </regstate>
endmodule
