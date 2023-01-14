require "armv8-configuration.k"

module VDUP
    imports ARMV8-CONFIGURATION
  
    rule <k> setDefaultRegs(VDUP:Opcode) => . ...</k>
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
  
    rule <k> beatResult(VDUP:Opcode . S:Label Qd:Q128, Rt:R32, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K 8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0),
                                                    extractMInt(getParentValue(Rt, RSMap), 24, 32), 0
                                                ), 
                                                extractMInt(getParentValue(Rt, RSMap), 24, 32), 8
                                            ), 
                                            extractMInt(getParentValue(Rt, RSMap), 24, 32), 16
                                        ), 
                                        extractMInt(getParentValue(Rt, RSMap), 24, 32), 24
                                    )
                                else ifMInt (S ==K 16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            extractMInt(getParentValue(Rt, RSMap), 16, 32), 0
                                        ), 
                                        extractMInt(getParentValue(Rt, RSMap), 16, 32), 16
                                    )
                                else ifMInt (S ==K 32) then
                                    getParentValue(Rt, RSMap)
                                else
                                    undefMInt32

            )
        </regstate>
  
    rule <k> execinstrBeat(VDUP:Opcode . S:Label Qd:Q128, Rt:R32, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>
 
endmodule
