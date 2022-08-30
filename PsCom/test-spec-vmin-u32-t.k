require "armv8-semantics.k"

module TEST-SPEC-VMIN-U32-T

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
         code ( memloc(mi(32, 0)) |-> storedInstr ( VMOV q0 , (# N:Int):Imm , .Operands )
         memloc(mi(32, 1)) |-> storedInstr ( VMOV q1 , (# M:Int):Imm , .Operands )
         memloc(mi(32, 2)) |-> storedInstr ( VMIN . U32 q2 , q0 , q1 , .Operands )
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
         "FPCCR" |-> (mi(32, _:Int) => mi(32, 0))
         "FPCCR_NS" |-> (mi(32, _:Int) => mi(32, 0))
         "FPCCR_S" |-> (mi(32, _:Int) => mi(32, 0))
         "MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
         "NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
         "Q0"  |-> mi(128, N)
         "Q1"  |-> mi(128, M)
         "Q2"  |-> ( mi(128, _:Int) => mi(128, _) )
         "S0" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 96, 128))
         "S1" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 64, 96))
         "S2" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 32, 64))
         "S3" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# N)), 0, 32))
         "S4" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# M)), 96, 128))
         "S5" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# M)), 64, 96))
         "S6" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# M)), 32, 64))
         "S7" |-> (mi(32, _:Int) => extractMInt(mi(128, modImm128(# M)), 0, 32))
         "S8" |-> (mi(32, _:Int) => mi(32, _:Int) )
         "S9" |-> (mi(32, _:Int) => mi(32, _:Int) )
         "S10" |-> (mi(32, _:Int) => mi(32, _:Int) )
         "S11" |-> (mi(32, _:Int) => ifMInt notBool IsUndef ( ifMInt uvalueMInt ( extractMInt ( mi ( 128 , M ) , 0 , 32 ) ) >=Int uvalueMInt ( extractMInt ( mi ( 128 , N ) , 0 , 32 ) ) then extractMInt ( mi ( 128 , N ) , 0 , 32 ) else extractMInt ( mi ( 128 , M ) , 0 , 32 ) ) then ifMInt uvalueMInt ( extractMInt ( mi ( 128 , M ) , 0 , 32 ) ) >=Int uvalueMInt ( extractMInt ( mi ( 128 , N ) , 0 , 32 ) ) then extractMInt ( mi ( 128 , N ) , 0 , 32 ) else extractMInt ( mi ( 128 , M ) , 0 , 32 ) else undefMInt32 )
         "RESULT" |-> ( mi(32, 0) => mi(32, _:Int) )
         "RESULT64" |-> mi(64, 0)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 4)))
         "VPR" |-> (mi(32, _:Int) => mi(32, 2048))
       </regstate>
         requires  N >=Int 0
           andBool N <Int (2 ^Int 128)
           andBool M >=Int 0
           andBool M <Int (2 ^Int 128)

endmodule
