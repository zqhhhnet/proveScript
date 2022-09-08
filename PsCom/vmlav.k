require "armv8-configuration.k"

module VMLAV
  imports ARMV8-CONFIGURATION
  
  rule <k>
         setDefaultRegs(VMLAV:Opcode) => .
       ...</k>
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

  rule <k> beatResult(VMLAV:Opcode . S:Label Rd:R32, Qn:Q128, Qm:Q128, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "RESULT64" |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,0)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then (ifMInt (I ==Int 0) then ( ifMInt (S ==K U8) then (uMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) else ( ifMInt (S ==K S8) then (sMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) else ( ifMInt (S ==K U16) then (uMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) else ( ifMInt (S ==K S16) then (sMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) else ( ifMInt (S ==K U32) then (uMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) else ( ifMInt (S ==K S32) then (sMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) 
                   else ( undefMInt64 ) ) ) ) ) ) ) 
               else (ifMInt (notBool IsUndef(getParentValue(Rd, RSMap))) then ( ifMInt (S ==K U8) then mi(64, (uvalueMInt(uMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S8) then mi(64, (svalueMInt(sMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K U16) then mi(64, (uvalueMInt(uMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S16) then mi(64, (svalueMInt(sMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K U32) then mi(64, (uvalueMInt(uMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S32) then mi(64, (svalueMInt(sMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) 
                   else ( undefMInt64 ) ) ) ) ) ) ) else (undefMInt64) ) ) else (undefMInt64) )
         )
       </regstate>
  
  rule <k> execinstrBeat(VMLAV:Opcode . S:Label Rd:R32, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> ifMInt (notBool IsUndef(getParentValue(result64, RSMap))) then ( extractMInt(getParentValue(result64, RSMap), 32, 64) )
           else (undefMInt32)
         )
       </regstate>
  
  rule <k>
         setDefaultRegs(VMLAVA:Opcode) => .
       ...</k>
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

  rule <k> beatResult(VMLAVA:Opcode . S:Label Rd:R32, Qn:Q128, Qm:Q128, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "RESULT64" |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,0)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then (ifMInt (notBool IsUndef(getParentValue(Rd, RSMap))) then ( ifMInt (S ==K U8) then mi(64, (uvalueMInt(uMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S8) then mi(64, (svalueMInt(sMulofInt8(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K U16) then mi(64, (uvalueMInt(uMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S16) then mi(64, (svalueMInt(sMulofInt16(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K U32) then mi(64, (uvalueMInt(uMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int uvalueMInt(getParentValue(Rd, RSMap)))) else ( ifMInt (S ==K S32) then mi(64, (svalueMInt(sMulofInt32(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))) +Int svalueMInt(getParentValue(Rd, RSMap)))) 
                   else ( undefMInt64 ) ) ) ) ) ) ) else (undefMInt64) ) else (undefMInt64) )
         )
       </regstate>
  
  rule <k> execinstrBeat(VMLAVA:Opcode . S:Label Rd:R32, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> ifMInt (notBool IsUndef(getParentValue(result64, RSMap))) then ( extractMInt(getParentValue(result64, RSMap), 32, 64) )
           else (undefMInt32)
         )
       </regstate>

endmodule
