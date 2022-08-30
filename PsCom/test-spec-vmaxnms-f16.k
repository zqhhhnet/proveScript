require "armv8-semantics.k"

module TEST-SPEC-VMAXNMS-F16

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( MOV s0 , (# N:Int):Imm , .Operands )
         memloc(mi(32, 1)) |-> storedInstr ( MOV s1 , (# M:Int):Imm , .Operands )
         memloc(mi(32, 2)) |-> storedInstr ( VMAXNM . F16 s2 , s0 , s1 , .Operands )
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
         "FPSCR" |-> ( mi(32, _:Int) => ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 23 ) , mi ( 1 , 0 ) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 23 ) , mi ( 1 , 0 ) ) ) ) then mi ( 32 , 50331649 ) else mi ( 32 , 50331648 ) )
         "MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
         "NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
         "S0" |-> (mi(32, _:Int) => mi(32, N))
         "S1" |-> (mi(32, _:Int) => mi(32, M))
         "S2" |-> (mi(32, _:Int) => mi ( 32 , uvalueMInt ( ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 23 ) , mi ( 1 , 1 ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 31 andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 23 ) , mi ( 1 , 1 ) ) ) then mi ( 16 , 32256 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 23 ) , mi ( 1 , 0 ) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 23 ) , mi ( 1 , 0 ) ) ) ) then mi ( 16 , 32256 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 23 ) , mi ( 1 , 1 ) ) then extractMInt ( mi ( 32 , M ) , 16 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 23 ) , mi ( 1 , 1 ) ) then extractMInt ( mi ( 32 , N ) , 16 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) , mi ( 10 , 0 ) ) then ifMInt eqMInt ( extractMInt ( mi ( 32 , M ) , 16 , 17 ) , mi ( 1 , 1 ) ) then extractMInt ( mi ( 32 , N ) , 16 , 32 ) else extractMInt ( mi ( 32 , M ) , 16 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) , mi ( 10 , 0 ) ) then ifMInt eqMInt ( extractMInt ( mi ( 32 , N ) , 16 , 17 ) , mi ( 1 , 1 ) ) then extractMInt ( mi ( 32 , M ) , 16 , 32 ) else extractMInt ( mi ( 32 , N ) , 16 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 0 andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) , mi ( 10 , 0 ) ) ) andBool ugtMInt ( extractMInt ( mi ( 32 , N ) , 16 , 17 ) , extractMInt ( mi ( 32 , M ) , 16 , 17 ) ) then extractMInt ( mi ( 32 , M ) , 16 , 32 ) else ifMInt ( uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) , mi ( 10 , 0 ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) ==K 0 andBool eqMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) , mi ( 10 , 0 ) ) ) andBool uleMInt ( extractMInt ( mi ( 32 , N ) , 16 , 17 ) , extractMInt ( mi ( 32 , M ) , 16 , 17 ) ) then extractMInt ( mi ( 32 , N ) , 16 , 32 ) else ifMInt MIntToFloatImpl ( 11 , 5 , uvalueMInt ( extractMInt ( mi ( 32 , N ) , 16 , 17 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , N ) , 17 , 22 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , N ) , 22 , 32 ) ) ) <=Float MIntToFloatImpl ( 11 , 5 , uvalueMInt ( extractMInt ( mi ( 32 , M ) , 16 , 17 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , M ) , 17 , 22 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , M ) , 22 , 32 ) ) ) then extractMInt ( mi ( 32 , M ) , 16 , 32 ) else extractMInt ( mi ( 32 , N ) , 16 , 32 ) ) ) )
         "RESULT" |-> ( mi(32, 0) => mi(32, 0) )
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 4)))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
       </regstate>
         requires  N >=Int 0
           andBool N <Int (2 ^Int 32)
           andBool M >=Int 0
           andBool M <Int (2 ^Int 32)

endmodule
