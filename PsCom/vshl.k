require "armv8-configuration.k"

module VSHL
    imports ARMV8-CONFIGURATION
  
    rule <k> setDefaultRegs(VSHL:Opcode) => . ...</k>
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
  
    rule <k> beatResult(VSHL:Opcode . S:Label Qd:Q128, Qm:Q128, # Imm:Int, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K S8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0),
                                                    mi(8, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) <<Int Imm) &Int 255), 0
                                                ),
                                                mi(8, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) <<Int Imm) &Int 255), 8
                                            ),
                                            mi(8, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) <<Int Imm) &Int 255), 16
                                        ),
                                        mi(8, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) <<Int Imm) &Int 255), 24
                                    )
                                else ifMInt (S ==K S16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            mi(16, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) <<Int Imm) &Int 65535), 0
                                        ),
                                        mi(16, (svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) <<Int Imm) &Int 65535), 16
                                    )
                                else ifMInt (S ==K S32) then
                                    mi(32, (svalueMInt(getVecParentValue(Qm, I, RSMap)) <<Int Imm) &Int 4294967295)
                                else ifMInt (S ==K U8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0),
                                                    mi(8, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) <<Int Imm) &Int 255), 0
                                                ),
                                                mi(8, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) <<Int Imm) &Int 255), 8
                                            ),
                                            mi(8, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) <<Int Imm) &Int 255), 16
                                        ),
                                        mi(8, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) <<Int Imm) &Int 255), 24
                                    )
                                else ifMInt (S ==K U16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            mi(16, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) <<Int Imm) &Int 65535), 0
                                        ),
                                        mi(16, (uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) <<Int Imm) &Int 65535), 16
                                    )
                                else ifMInt (S ==K U32) then
                                    mi(32, (uvalueMInt(getVecParentValue(Qm, I, RSMap)) <<Int Imm) &Int 4294967295)
                                else
                                    undefMInt32

            )
        </regstate>
  
    rule <k> execinstrBeat(VSHL:Opcode . S:Label Qd:Q128, Qm:Q128, # Imm:Int, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>


 
endmodule
