require "armv8-configuration.k"

module VSUB
    imports ARMV8-CONFIGURATION
  
    rule <k> setDefaultRegs(VSUB:Opcode) => . ...</k>
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
  
    rule <k> beatResult(VSUB:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K I8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0), 
                                                    subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32), extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)), 0
                                                ), 
                                                subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24), extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)), 8
                                            ), 
                                            subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 6, 16), extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)), 16
                                        ), 
                                        subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8), extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)), 24
                                    )
                                else ifMInt (S ==K I16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32), extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)), 0
                                        ),
                                        subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16), extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)), 16
                                    )
                                else ifMInt (S ==K I32) then
                                    subMInt(getVecParentValue(Qn, I, RSMap), getVecParentValue(Qm, I, RSMap))
                                else
                                    undefMInt32
            )
        </regstate>
  
    rule <k> execinstrBeat(VSUB:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>

    rule <k> beatResult(VSUB:Opcode . S:Label Qd:Q128, Qn:Q128, Rm:R32, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K I8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0),
                                                    subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32), extractMInt(getParentValue(Rm, RSMap), 24, 32)), 0
                                                ),
                                                subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24), extractMInt(getParentValue(Rm, RSMap), 24, 32)), 8
                                            ),
                                            subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16), extractMInt(getParentValue(Rm, RSMap), 24, 32)), 16
                                        ),
                                        subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8), extractMInt(getParentValue(Rm, RSMap), 24, 32)), 24
                                    )
                                else ifMInt (S ==K I16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32), extractMInt(getParentValue(Rm, RSMap), 16, 32)), 0
                                        ),
                                        subMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16), extractMInt(getParentValue(Rm, RSMap), 16, 32)), 16
                                    )
                                else ifMInt (S ==K I32) then
                                    subMInt(getVecParentValue(Qn, I, RSMap), getParentValue(Rm, RSMap))
                                else
                                    undefMInt32

            )
        </regstate>
  
    rule <k> execinstrBeat(VSUB:Opcode . S:Label Qd:Q128, Qn:Q128, Rm:R32, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>

 
endmodule
