require "armv8-semantics.k"

module TEST-SPEC-VMAXNMD

  imports ARMV8-SEMANTICS

  rule <k>
         scan => End
       </k>
       <begin>
         .K
       </begin>
       <currentstate>
         "text"
       </currentstate>
       <nextloc>
         _:MInt
       </nextloc>
       <functarget>
         start |-> mi(32, 0)
       </functarget>
       <instructiontext>
         code ( memloc(mi(32, 0)) |-> storedInstr ( MOV d0 , (# N:Int):Imm , .Operands )
         memloc(mi(32, 1)) |-> storedInstr ( MOV d1 , (# M:Int):Imm , .Operands )
         memloc(mi(32, 2)) |-> storedInstr ( VMAXNM . F64 d2 , d0 , d1 , .Operands )
         memloc(mi(32, 3)) |-> storedInstr ( end .Operands ) )
       </instructiontext>
       <regstate>
         "CONTROL" |-> (mi(32, _:Int) => mi(32, 1))
         "CONTROL_NS" |-> (mi(32, _:Int) => mi(32, 1))
         "CONTROL_S" |-> (mi(32, _:Int) => mi(32, 1))
         "CPACR" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPACR_NS" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPACR_S" |-> (mi(32, _:Int) => mi(32, 3145728))
         "CPPWR" |-> (mi(32, _:Int) => mi(32, 0))
         "CPPWR_NS" |-> (mi(32, _:Int) => mi(32, 0))
         "CPPWR_S" |-> (mi(32, _:Int) => mi(32, 0))
         "EPSR" |-> (mi(32, _:Int) => mi(32, 2048))
         "FPCCR" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPCCR_NS" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPCCR_S" |-> (mi(32, _:Int) => mi(32, 2147483648))
         "FPSCR" |-> ( mi(32, _:Int) => mi(32, 50331648) )
         "MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
         "NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
         "D0" |-> ( mi(64, _:Int) => mi(64, N) )
         "D1" |-> ( mi(64, _:Int) => mi(64, M) )
         "S0" |-> (mi(32, _:Int) => mi ( 32 , N ))
         "S1" |-> (mi(32, _:Int) => extractMInt ( mi ( 64 , N ) , 0 , 32 ))
         "S2" |-> (mi(32, _:Int) => mi ( 32 , M ))
         "S3" |-> (mi(32, _:Int) => extractMInt ( mi ( 64 , M ) , 0 , 32 ))
         "S4" |-> (mi(32, _:Int) => ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 1) ) andBool ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 1) ) ) then mi(32, 0) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 andBool ( neMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) , mi(52, 0) ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 0) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 andBool ( neMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) , mi(52, 0) ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 0) ) ) ) then mi(32, 0) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 1) ) then mi ( 32 , M ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 1) ) then mi ( 32 , N ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) , mi(52, 0) ) then ifMInt eqMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) , mi(1, 1) ) then mi ( 32 , N ) else mi ( 32 , M ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) , mi(52, 0) ) then ifMInt eqMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) , mi(1, 1) ) then mi ( 32 , M ) else mi ( 32 , N ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 0 ) andBool uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 0 then mi(32, 0) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) , mi(1, 1) ) then mi(32, 0) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) , mi(1, 1) ) then mi(32, 0) else ifMInt MIntToFloatImpl ( 53 , 11 , uvalueMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) , uvalueMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) ) ) <=Float MIntToFloatImpl ( 53 , 11 , uvalueMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) , uvalueMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) ) ) then mi ( 32 , M ) else mi ( 32 , N ) )
         "S5" |-> (mi(32, _:Int) => ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 1) ) andBool ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 1) ) ) then mi(32, 2146959360) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 andBool ( neMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) , mi(52, 0) ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 0) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 andBool ( neMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) , mi(52, 0) ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 0) ) ) ) then mi(32, 2146959360) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 12 , 13 ) , mi(1, 1) ) then extractMInt ( mi ( 64 , M ) , 0 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 12 , 13 ) , mi(1, 1) ) then extractMInt ( mi ( 64 , N ) , 0 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) , mi(52, 0) ) then ifMInt eqMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) , mi(1, 1) ) then extractMInt ( mi ( 64 , N ) , 0 , 32 ) else extractMInt ( mi ( 64 , M ) , 0 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 1 , 12 ) ) ==K 2047 ) andBool eqMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) , mi(52, 0) ) then ifMInt eqMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) , mi(1, 1) ) then extractMInt ( mi ( 64 , M ) , 0 , 32 ) else extractMInt ( mi ( 64 , N ) , 0 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 0 ) andBool uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 0 then concatenateMInt ( mi ( 1 , uvalueMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) ) &Int uvalueMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) ) ) , mi(31, 0) ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) , mi(1, 1) ) then concatenateMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) , mi(31, 0) ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) , mi(1, 1) ) then concatenateMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) , mi(31, 0) ) else ifMInt MIntToFloatImpl ( 53 , 11 , uvalueMInt ( extractMInt ( mi ( 64 , N ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 64 , N ) , 1 , 12 ) ) , uvalueMInt ( concatenateMInt ( extractMInt ( mi ( 64 , N ) , 12 , 32 ) , mi ( 32 , N ) ) ) ) <=Float MIntToFloatImpl ( 53 , 11 , uvalueMInt ( extractMInt ( mi ( 64 , M ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 64 , M ) , 1 , 12 ) ) , uvalueMInt ( concatenateMInt ( extractMInt ( mi ( 64 , M ) , 12 , 32 ) , mi ( 32 , M ) ) ) ) then extractMInt ( mi ( 64 , M ) , 0 , 32 ) else extractMInt ( mi ( 64 , N ) , 0 , 32 ) )
         "RESULT" |-> ( mi(32, 0) => mi(32, 0) )
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 4)))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
         convToRegKeysHelper ( convSubVecRegsToRegs ( d2 , 2 ) ) |-> undefMInt32
         convToRegKeysHelper ( convSubVecRegsToRegs ( d2 , 3 ) ) |-> undefMInt32
         convToRegKeysHelper ( convSubVecRegsToRegs ( d2 , 4 ) ) |-> undefMInt32
       </regstate>
         requires  N >=Int 0
           andBool N <Int (2 ^Int 32)
           andBool M >=Int 0
           andBool M <Int (2 ^Int 32)

endmodule
