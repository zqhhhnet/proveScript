require "armv8-configuration.k"

module VQRDMULH
    imports ARMV8-CONFIGURATION
  
    rule <k> setDefaultRegs(VQRDMULH:Opcode) => . ...</k>
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
                "FPSCR" |-> mi(32, 50331648)
            )
        </regstate>
  
  /*@
    action for a beat
  */
  
    rule <k> beatResult(VQRDMULH:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K S8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0), 
                                                    ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127) then
                                                        mi(8, 127)
                                                    else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128) then
                                                        mi(8, -128)
                                                    else
                                                        mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) +Int 128) >>Int 8))
                                                    , 0
                                                ), 
                                                ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) +Int 128) >>Int 8) >Int 127) then
                                                    mi(8, 127)
                                                else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) +Int 128) >>Int 8) <Int -128) then
                                                    mi(8, -128)
                                                else
                                                    mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) +Int 128) >>Int 8))
                                                , 8
                                            ), 
                                            ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) +Int 128) >>Int 8) >Int 127) then
                                                mi(8, 127)
                                            else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) +Int 128) >>Int 8) <Int -128) then
                                                mi(8, -128)
                                            else
                                                mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) +Int 128) >>Int 8))
                                            , 16
                                        ), 
                                        ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) +Int 128) >>Int 8) >Int 127) then
                                            mi(8, 127)
                                        else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) +Int 128) >>Int 8) <Int -128) then
                                            mi(8, -128)
                                        else
                                            mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) +Int 128) >>Int 8))
                                        , 24
                                    )
                                else ifMInt (S ==K S16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767) then
                                                mi(16, 32767)
                                            else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768) then
                                                mi(16, -32768)
                                            else
                                                mi(16, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) +Int 32768) >>Int 16))
                                            , 0
                                        ),
                                        ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) +Int 32768) >>Int 16) >Int 32767) then
                                            mi(16, 32767)
                                        else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) +Int 32768) >>Int 16) <Int -32768) then
                                            mi(16, -32768)
                                        else
                                            mi(16, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) +Int 32768) >>Int 16))
                                        , 16
                                    )
                                else ifMInt (S ==K S32) then
                                    ifMInt (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                        mi(32, 2147483647)
                                    else ifMInt (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                        mi(32, -2147483648)
                                    else
                                        mi(32, ((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)) +Int 2147483648) >>Int 32))
                                else
                                    undefMInt32
                
                // 27bit to 1
                "FPSCR" |-> ifMInt (S ==K S8) then
                                ifMInt ((((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 24)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 8, 16)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 8)) +Int 128) >>Int 8) <Int -128)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else ifMInt (S ==K S16) then
                                ifMInt ((((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) +Int 32768) >>Int 16) >Int 32767)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16)) +Int 32768) >>Int 16) <Int -32768)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else ifMInt (S ==K S32) then 
                                ifMInt ((((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)) +Int 2147483648) >>Int 32) >Int 2147483647)
                                    orBool (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)) +Int 2147483648) >>Int 32) <Int -2147483648)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else 
                                undefMInt32
            )
        </regstate>
  
    rule <k> execinstrBeat(VQRDMULH:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>

    rule <k> beatResult(VQRDMULH:Opcode . S:Label Qd:Q128, Qn:Q128, Rm:R32, .Operands, I:Int) => . ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                "RESULT" |->    ifMInt (S ==K S8) then
                                    plugInMask(
                                        plugInMask(
                                            plugInMask(
                                                plugInMask(
                                                    mi(32, 0), 
                                                    ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127) then
                                                        mi(8, 127)
                                                    else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128) then
                                                        mi(8, -128)
                                                    else
                                                        mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8))
                                                    , 0
                                                ), 
                                                ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127) then
                                                    mi(8, 127)
                                                else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128) then
                                                    mi(8, -128)
                                                else
                                                    mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8))
                                                , 8
                                            ), 
                                            ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127) then
                                                mi(8, 127)
                                            else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128) then
                                                mi(8, -128)
                                            else
                                                mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8))
                                            , 16
                                        ), 
                                        ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127) then
                                            mi(8, 127)
                                        else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128) then
                                            mi(8, -128)
                                        else
                                            mi(8, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8))
                                        , 24
                                    )
                                else ifMInt (S ==K S16) then
                                    plugInMask(
                                        plugInMask(
                                            mi(32, 0),
                                            ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767) then
                                                mi(16, 32767)
                                            else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768) then
                                                mi(16, -32768)
                                            else
                                                mi(16, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16))
                                            , 0
                                        ),
                                        ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767) then
                                            mi(16, 32767)
                                        else ifMInt (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768) then
                                            mi(16, -32768)
                                        else
                                            mi(16, ((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16))
                                        , 16
                                    )
                                else ifMInt (S ==K S32) then
                                    ifMInt (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getParentValue(Rm, RSMap)) +Int 2147483648) >>Int 32) >Int 2147483647) then
                                        mi(32, 2147483647)
                                    else ifMInt (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getParentValue(Rm, RSMap)) +Int 2147483648) >>Int 32) <Int -2147483648) then
                                        mi(32, -2147483648)
                                    else
                                        mi(32, ((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getParentValue(Rm, RSMap)) +Int 2147483648) >>Int 32))
                                else
                                    undefMInt32
                
                // 27bit to 1
                "FPSCR" |-> ifMInt (S ==K S8) then
                                ifMInt ((((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 24, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 24)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 8, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) >Int 127)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 8)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 24, 32)) +Int 128) >>Int 8) <Int -128)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else ifMInt (S ==K S16) then
                                ifMInt ((((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) >Int 32767)
                                    orBool (((2 *Int svalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16)) *Int svalueMInt(extractMInt(getParentValue(Rm, RSMap), 16, 32)) +Int 32768) >>Int 16) <Int -32768)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else ifMInt (S ==K S32) then 
                                ifMInt ((((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getParentValue(Rm, RSMap)) +Int 2147483648) >>Int 32) >Int 2147483647)
                                    orBool (((2 *Int svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getParentValue(Rm, RSMap)) +Int 2147483648) >>Int 32) <Int -2147483648)) then
                                    plugInMask(getReg("FPSCR", RSMap), mi(1, 1), 27)
                                else
                                    getReg("FPSCR", RSMap)
                            else 
                                undefMInt32
                                
            )
        </regstate>
  
    rule <k> execinstrBeat(VQRDMULH:Opcode . S:Label Qd:Q128, Qn:Q128, Rm:R32, .Operands, I:Int) => . 
       ...</k>
        <regstate>
            RSMap:Map => updateMap(RSMap,
                convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
                else (undefMInt32)
                
                convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
            )
        </regstate>


 
endmodule
