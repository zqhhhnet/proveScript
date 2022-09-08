require "armv8-configuration.k"

module VMAXV
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(VMAXV:Opcode) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "CONTROL" |-> mi(32, 1)
           "CONTROL_S" |-> mi(32, 1)
           "CONTROL_NS" |-> mi(32, 1)
           "CPACR" |-> mi(32, 3145728)
           "CPACR_S" |-> mi(32, 3145728)
           "CPACR_NS" |-> mi(32, 3145728)
           "NSACR" |-> mi(32, 1024)
           "CPPWR" |-> mi(32, 0)
           "CPPWR_NS" |-> mi(32, 0)
           "CPPWR_S" |-> mi(32, 0)
           "MVFR1" |-> mi(32, 256)
           "EPSR" |-> mi(32, 2048)
           "FPCCR" |-> mi(32, 0)
           "FPCCR_S" |-> mi(32, 0)
           "FPCCR_NS" |-> mi(32, 0)
           "VPR" |-> mi(32, 2048)
           "RESULT" |-> mi(32, 0)
         )
       </regstate>
  
  /*@
    signExtend
   */
  rule <k> beatResult(VMAXV:Opcode . S:Label Rd:R32, Qm:Q128, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "RESULT" |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,0)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then (ifMInt (S ==K S8) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32), (extractMInt(getParentValue(Rd, RSMap), 24, 32)), 8, S8, RSMap)), 8, S8, RSMap)), 8, S8, RSMap)), 8, S8, RSMap)), 32) else (ifMInt (S ==K S16) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), (extractMInt(getParentValue(Rd, RSMap), 16, 32)), 16, S16, RSMap)), 16, S16, RSMap)), 32) else (ifMInt (S ==K S32) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), (getParentValue(Rd, RSMap)), 32, S32, RSMap)), 32) else (ifMInt (S ==K U8) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32), (extractMInt(getParentValue(Rd, RSMap), 24, 32)), 8, U8, RSMap)), 8, U8, RSMap)), 8, U8, RSMap)), 8, U8, RSMap)), 32) else (ifMInt (S ==K U16) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), (MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), (extractMInt(getParentValue(Rd, RSMap), 16, 32)), 16, U16, RSMap)), 16, U16, RSMap)), 32) else (ifMInt (S ==K U32) then signExtend((MaxMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), (getParentValue(Rd, RSMap)), 32, U32, RSMap)), 32) else (undefMInt32) ) ) ) ) ) )
           else (undefMInt32) )
         )
       
       </regstate>
  
  rule <k> execinstrBeat(VMAXV:Opcode . S:Label Rd:R32, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then getParentValue(result, RSMap) else (undefMInt32)
         )
         
       </regstate>
  
  
endmodule
