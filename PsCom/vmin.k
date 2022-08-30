require "armv8-configuration.k"

module VMIN
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(VMIN:Opcode) => . ...</k>
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
    action for a beat
  */
  
  rule <k> beatResult(VMIN:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, Operands, I:Int) => . ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
         "RESULT" |->  /* the first beat lowest 32b */ (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,0)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then ( ifMInt (S ==K S8) then ( plugInMask( ( /* finish insert [23:0] */ plugInMask( ( /* finish insert [15:0] */ plugInMask( (/* finish insert [7:0] */ plugInMask( mi(32, 0) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32), 8, S, RSMap)) , 0 ) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24), extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24), 8, S, RSMap)) , 8)  ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16), extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16), 8, S, RSMap)) , 16) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8), 8, S, RSMap)) , 24) ) 
             else ( ifMInt (S ==K U8) then ( plugInMask( ( /* finish insert [23:0] */ plugInMask( ( /* finish insert [15:0] */ plugInMask( (/* finish insert [7:0] */ plugInMask( mi(32, 0) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32), 8, S, RSMap)) , 0 ) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24), extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24), 8, S, RSMap)) , 8)  ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16), extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16), 8, S, RSMap)) , 16) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8), 8, S, RSMap)) , 24) ) 
             else ( ifMInt (S ==K S16) then ( plugInMask( (/* finish insert [15:0] */ plugInMask( mi(32, 0) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32), 16, S, RSMap)) , 0 ) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16), 16, S, RSMap)) , 16) ) 
             else ( ifMInt (S ==K U16) then ( plugInMask( (/* finish insert [15:0] */ plugInMask( mi(32, 0) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32), 16, S, RSMap)) , 0 ) ) , (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16), 16, S, RSMap)) , 16) ) 
             else ( ifMInt (S ==K S32) then (plugInMask(mi(32, 0), (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 32), 32, S, RSMap)) , 0)) 
             else ( ifMInt (S ==K U32) then (plugInMask(mi(32, 0), (MinMIntOfInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), extractMInt(getVecParentValue(Qn, I, RSMap), 0, 32), 32, S, RSMap)) , 0)) 
             else (undefMInt32) ) ) ) ) ) 
           ) else (undefMInt32)
           )
         )
       </regstate>
  
  rule <k> execinstrBeat(VMIN:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
           else (undefMInt32)
           
           convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
         )
       </regstate>
 
endmodule
