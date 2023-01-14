require "armv8-configuration.k"

module VMINNMAV
  imports ARMV8-CONFIGURATION
  
  rule <k>
         setDefaultRegs(VMINNMAV:Opcode) => .
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
           "MVFR1" |-> mi(32, 512)
           "EPSR" |-> mi(32, 2048)
           "FPCCR" |-> mi(32, 2147483648)
           "FPCCR_S" |-> mi(32, 2147483648)
           "FPCCR_NS" |-> mi(32, 2147483648)
           "VPR" |-> mi(32, 2048)
           "FPSCR" |-> mi(32, 50331648) /* 0000 0011 0000 0000 0000 0000 0000 0000 */
           "RESULT" |-> mi(32, 0)
         )
       </regstate>
  
  rule <k> beatResult(VMINNMAV:Opcode . S:Label Rd:R32, Qm:Q128, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "RESULT" |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,1)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then ( ifMInt (S ==K F16) then (concatenateMInt( mi(16, 0), LeftAbsMinMIntOfFP(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), LeftAbsMinMIntOfFP(extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), extractMInt(getParentValue(Rd, RSMap), 16, 32), 16, RSMap), 16, RSMap) ) ) 
             else (ifMInt (S ==K F32) then (LeftAbsMinMIntOfFP(extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), extractMInt(getParentValue(Rd, RSMap), 0, 32), 32, RSMap))
             else (undefMInt32) ) )
             else (undefMInt32)
             )
           
           "FPSCR" |-> 
            (ifMInt (S ==K F32) then 
              (ifMInt /* both InvalidOP and Denormalized */ (((uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 1, 9)) ==Int MaxExponentBits(8))
                      andBool ((neMInt(extractMInt(getParentValue(Rd, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getParentValue(Rd, RSMap), 9, 10), mi(1,0)))) 
                    orBool 
                      ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 9)) ==Int MaxExponentBits(8)) 
                      andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 10), mi(1,0)))) )
                  andBool
                    (((uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 1, 9)) ==Int 0) andBool neMInt(extractMInt(getParentValue(Rd, RSMap), 9, 32), mi(23, 0)) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) 
                    orBool 
                    ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 9)) ==Int 0) andBool neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 32), mi(23, 0)) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then
                  mi(32, 50331777)
              else ifMInt (((uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getParentValue(Rd, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getParentValue(Rd, RSMap), 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 10), mi(1,0)))) ) then 
                (mi(32, 50331649)) 
              else (ifMInt /* Denormalized */ (((uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 1, 9)) ==Int 0) andBool neMInt(extractMInt(getParentValue(Rd, RSMap), 9, 32), mi(23, 0)) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) 
                    orBool 
                    ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 9)) ==Int 0) andBool neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 32), mi(23, 0)) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 7, 8), mi(1,1))) ) ) then 
                  (mi(32, 50331776))
              else (getReg("FPSCR", RSMap)) ) )
            else ( ifMInt (S ==K F16) then 
              ( ifMInt (((((uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getParentValue(Rd, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getParentValue(Rd, RSMap), 22, 23), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 22, 23), mi(1,0))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0)))) ) then (mi(32, 50331649)) else (getReg("FPSCR", RSMap)) ) 
            else (getReg("FPSCR", RSMap)) ) )
         )
       </regstate>
       
  rule <k> execinstrBeat(VMINNMAV:Opcode . S:Label Rd:R32, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Rd) |-> ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then (getParentValue(result, RSMap)) else undefMInt32
           
         )
       </regstate>
  


endmodule
