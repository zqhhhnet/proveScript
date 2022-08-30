require "armv8-configuration.k"

module VMAXNM
  imports ARMV8-CONFIGURATION
  
  rule <k>
         setDefaultRegs(VMAXNM:Opcode) => .
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
           "FPCCR" |-> mi(32, 2147483648)
           "FPCCR_S" |-> mi(32, 2147483648)
           "FPCCR_NS" |-> mi(32, 2147483648)
           "VPR" |-> mi(32, 2048)
           "FPSCR" |-> mi(32, 50331648) /* 0000 0011 0000 0000 0000 0000 0000 0000 */
           "RESULT" |-> mi(32, 0)
         )
       </regstate>
  
  /*@
    vector action for a beat
  */
  
  rule <k> beatResult(VMAXNM:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           "RESULT" |-> ( ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,1)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then ( ifMInt (S ==K F32) then ( plugInMask( mi(32, 0) , MaxMIntOfFP( extractMInt(getVecParentValue(Qn, I, RSMap), 0, 32), extractMInt(getVecParentValue(Qm, I, RSMap), 0, 32), 32, RSMap) , 0) ) 
             else ( ifMInt (S ==K F16) then ( plugInMask( (plugInMask( mi(32, 0) , /* low 16 bit */ MaxMIntOfFP( extractMInt(getVecParentValue(Qn, I, RSMap), 16, 32), extractMInt(getVecParentValue(Qm, I, RSMap), 16, 32), 16, RSMap) , 0 )) , 
             /* top 16 bit */ MaxMIntOfFP( extractMInt(getVecParentValue(Qn, I, RSMap), 0, 16), extractMInt(getVecParentValue(Qm, I, RSMap), 0, 16), 16, RSMap) , 16) ) 
             else (undefMInt32) ) 
           ) else (undefMInt32)
           )
           
           "FPSCR" |-> ( ifMInt (S ==K F32) then ( ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 9, 10), mi(1,0)))) ) then (mi(32, 50331649)) else (mi(32, 50331648)) ) else ( ifMInt (S ==K F16) then ( ifMInt ( ((((uvalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 6, 7), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 1, 6)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 6, 7), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) orBool ((((uvalueMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qn, I, RSMap), 22, 23), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getVecParentValue(Qm, I, RSMap), 22, 23), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) ) then (mi(32, 50331649)) else (getReg("FPSCR", RSMap)) ) else (getReg("FPSCR", RSMap)) ) )
         )
       </regstate>
       
  rule <k> execinstrBeat(VMAXNM:Opcode . S:Label Qd:Q128, Qn:Q128, Qm:Q128, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Qd, I) |-> /* store 32 bit of result to lowest 32 bit of Qd */ ifMInt (notBool IsUndef(getParentValue(result, RSMap))) then ( plugInMask( ( /* finish [23:0] */ plugInMask( ( /* finish [15:0] */ plugInMask( (/* finish [7:0] */ plugInMask( getVecParentValue(Qd, I, RSMap) , extractMInt(getParentValue(result, RSMap), 24, 32) , 0) ) , extractMInt(getParentValue(result, RSMap), 16, 24) , 8) ) , extractMInt(getParentValue(result, RSMap), 8, 16) , 16) ) , extractMInt(getParentValue(result, RSMap), 0, 8) , 24) )
           else (undefMInt32)
           
           convToRegKeys(Qd) |-> plugInMask(getParentValue(Qd, RSMap) ,getParentValue(result, RSMap), (I *Int 32))
           
         )
       </regstate>
  
  /*@
    FP S register action
  */
  rule <k> beatResult(VMAXNM:Opcode . S:Label Sd:S32, Sn:S32, Sm:S32, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convToRegKeys(Sd) |-> ( ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,1)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then (ifMInt (I ==Int 0) then (ifMInt (S ==K F16) then (zeroExtend( MaxMIntOfFP( extractMInt(getParentValue(Sn, RSMap), 16, 32), extractMInt(getParentValue(Sm, RSMap), 16, 32), 16, RSMap) , 32) )
               else( ifMInt (S ==K F32) then  MaxMIntOfFP( extractMInt(getParentValue(Sn, RSMap), 0, 32), extractMInt(getParentValue(Sm, RSMap), 0, 32), 32, RSMap) 
                 else (undefMInt32)) ) 
             else (getParentValue(Sd, RSMap)) )
           else (undefMInt32)
           )
           
           "FPSCR" |-> ( ifMInt (S ==K F32) then ( ifMInt (((uvalueMInt(extractMInt(getParentValue(Sn, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getParentValue(Sn, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getParentValue(Sn, RSMap), 9, 10), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getParentValue(Sm, RSMap), 1, 9)) ==Int MaxExponentBits(8)) andBool ((neMInt(extractMInt(getParentValue(Sm, RSMap), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(getParentValue(Sm, RSMap), 9, 10), mi(1,0)))) ) then (mi(32, 50331649)) else (mi(32, 50331648)) ) else ( ifMInt (S ==K F16) then ( ifMInt ((((uvalueMInt(extractMInt(getParentValue(Sn, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getParentValue(Sn, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getParentValue(Sn, RSMap), 22, 23), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getParentValue(Sm, RSMap), 17, 22)) ==Int MaxExponentBits(5)) andBool ((neMInt(extractMInt(getParentValue(Sm, RSMap), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(getParentValue(Sm, RSMap), 22, 23), mi(1,0))))) andBool (eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))) ) then (mi(32, 50331649)) else (mi(32, 50331648)) ) else (mi(32, 50331648)) ) )
         )
       </regstate>
  
  rule <k> execinstrBeat(VMAXNM:Opcode . S:Label Sd:S32, Sn:S32, Sm:S32, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map
       </regstate>
  
  /*@
    FP D register action
  */
  rule <k> beatResult(VMAXNM:Opcode . S:Label Dd:D64, Dn:D64, Dm:D64, Operands, I:Int) => . 
       ...</k>
       
       <regstate>
         RSMap:Map => updateMap(RSMap,
           convVecToRegKeys(Dd, I) |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,1)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then ( ifMInt (I ==Int 0) then (ifMInt (S ==K F64) then ( ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1, 1)))) ) then ( plugInMask(getVecParentValue(Dn, (I +Int 1), RSMap), mi(32, 0), 0) ) else (ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1,0)))) ) then ( plugInMask(getVecParentValue(Dn, I, RSMap), mi(32, 0), 0) ) else ( ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1, 1))) ) then (getVecParentValue(Dm, I, RSMap)) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1, 1))) ) then (getVecParentValue(Dn, I, RSMap)) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dm, I, RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0)))) then ( ifMInt (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1), mi(1, 1))) then (getVecParentValue(Dn, I, RSMap)) else (getVecParentValue(Dm, I, RSMap)) ) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dn, I, RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0)))) then ( ifMInt (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), mi(1, 1))) then (getVecParentValue(Dm, I, RSMap)) else (getVecParentValue(Dn, I, RSMap)) ) else (ifMInt ((((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) ) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) ) ) andBool ugtMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1)) ) then (extractMInt(getVecParentValue(Dm, I, RSMap), 0, 32)) else (ifMInt ((((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) ) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) ) ) andBool uleMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1)) ) then (getVecParentValue(Dn, I, RSMap)) else (ifMInt (MInt2Float(concatenateMInt(getVecParentValue(Dn, (I +Int 1), RSMap), getVecParentValue(Dn, I, RSMap)), 53, 11) <=Float MInt2Float(concatenateMInt(getVecParentValue(Dm, (I +Int 1), RSMap), getVecParentValue(Dm, I, RSMap)), 53, 11)) then (getVecParentValue(Dm, I, RSMap)) else (getVecParentValue(Dn, I, RSMap)) ) ) ))) ) ) ) ) else (undefMInt32) )
             else (ifMInt (I ==Int 1) then (getVecParentValue(Dd, I, RSMap)) 
             else (undefMInt32))) 
           else (undefMInt32))
           
           convVecToRegKeys(Dd, (I +Int 1)) |-> (ifMInt (((((((eqMInt(extractMInt(getReg("CONTROL", RSMap), 31, 32), mi(1,1)) andBool (eqMInt(extractMInt(getReg("CPACR", RSMap), 10, 12), mi(2,3)) andBool (eqMInt(extractMInt(getReg("NSACR", RSMap), 21, 22), mi(1,1))))) andBool eqMInt(extractMInt(getReg("CPPWR", RSMap), 11, 12), mi(1,0))) andBool neMInt(extractMInt(getReg("MVFR1", RSMap), 20, 24), mi(4,0))) andBool (eqMInt(extractMInt(getReg("EPSR", RSMap), 5, 7), mi(2,0)) andBool eqMInt(extractMInt(getReg("EPSR", RSMap), 16, 22), mi(6,2)))) andBool (eqMInt(extractMInt(getReg("FPCCR", RSMap), 31, 32), mi(1,0)) andBool eqMInt(extractMInt(getReg("FPCCR", RSMap), 0, 1), mi(1,1)))) andBool eqMInt(extractMInt(getReg("CONTROL", RSMap), 29, 30), mi(1,0))) andBool eqMInt(extractMInt(getReg("VPR", RSMap), 20, 21), mi(1,1)) ) then ( ifMInt (I ==Int 0) then (ifMInt (S ==K F64) then ( ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1, 1)))) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1, 1)))) ) then ( plugInMask(getVecParentValue(Dn, (I +Int 1), RSMap), mi(32, 2146959360), 0) ) else (ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1,0)))) ) then ( plugInMask(getVecParentValue(Dn, (I +Int 1), RSMap), mi(32, 2146959360), 0) ) else ( ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1, 1))) ) then (getVecParentValue(Dm, (I +Int 1), RSMap)) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1, 1))) ) then (getVecParentValue(Dn, (I +Int 1), RSMap)) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dm, I, RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0)))) then ( ifMInt (eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1), mi(1, 1))) then (getVecParentValue(Dn, (I +Int 1), RSMap)) else (getVecParentValue(Dm, (I +Int 1), RSMap)) ) else (ifMInt ((uvalueMInt(extractMInt(getVecParentValue(Dn, I, RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0)))) then ( ifMInt (eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), mi(1, 1))) then (getVecParentValue(Dm, (I +Int 1), RSMap)) else (getVecParentValue(Dn, (I +Int 1), RSMap)) ) else (ifMInt ((((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) ) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) ) ) andBool ugtMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1)) ) then (extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 32)) else (ifMInt ((((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) ) andBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int 0) andBool (eqMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) ) ) andBool uleMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 0, 1), extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 0, 1)) ) then (getVecParentValue(Dn, (I +Int 1), RSMap)) else (ifMInt (MInt2Float(concatenateMInt(getVecParentValue(Dn, (I +Int 1), RSMap), getVecParentValue(Dn, I, RSMap)), 53, 11) <=Float MInt2Float(concatenateMInt(getVecParentValue(Dm, (I +Int 1), RSMap), getVecParentValue(Dm, I, RSMap)), 53, 11)) then (getVecParentValue(Dm, (I +Int 1), RSMap)) else (getVecParentValue(Dn, (I +Int 1), RSMap)) ) ) ))) ) ) ) ) else (undefMInt32))
             else (undefMInt32)) 
           else (undefMInt32))
         
         "FPSCR" |-> (ifMInt (I ==Int 0) then ( ifMInt (S ==K F64) then ( ifMInt (((uvalueMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dn, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dn, (I +Int 1), RSMap), 12, 13), mi(1,0)))) orBool ((uvalueMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 1, 12)) ==Int MaxExponentBits(11)) andBool ((neMInt(concatenateMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 32), getVecParentValue(Dm, I, RSMap)), mi(52, 0))) andBool eqMInt(extractMInt(getVecParentValue(Dm, (I +Int 1), RSMap), 12, 13), mi(1,0)))) ) then (mi(32, 50331649)) else (mi(32, 50331648)) ) else (mi(32, 50331648)) )
         else (mi(32, 50331648)) )
         
         )
       </regstate>
       
  rule <k> execinstrBeat(VMAXNM:Opcode . S:Label Dd:D64, Dn:D64, Dm:D64, .Operands, I:Int) => . 
       ...</k>
       <regstate>
         RSMap:Map
       </regstate>
endmodule
