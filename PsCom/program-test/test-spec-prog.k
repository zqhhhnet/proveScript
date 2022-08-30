require "armv8-semantics.k"

module TEST-SPEC-PROG

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
         code ( memloc ( mi(32, 0) ) |-> storedInstr ( VMOV q0 , # 7101656499985446417749811181341197757318 , .Operands )
    memloc ( mi(32, 1) ) |-> storedInstr ( MOV r0 , # 0 , .Operands )
    memloc ( mi(32, 2) ) |-> storedInstr ( VMAXV . S8 r0 , q0 , .Operands )
    memloc ( mi(32, 3) ) |-> storedInstr ( VMOV q0 , # 1447163071352862168344493284646355772084 , .Operands )
    memloc ( mi(32, 4) ) |-> storedInstr ( MOV r1 , # 0 , .Operands )
    memloc ( mi(32, 5) ) |-> storedInstr ( VMAXV . S8 r1 , q0 , .Operands )
    memloc ( mi(32, 6) ) |-> storedInstr ( VMOV q0 , # 9419896167491740808063989887586577951168 , .Operands )
    memloc ( mi(32, 7) ) |-> storedInstr ( MOV r2 , # 0 , .Operands )
    memloc ( mi(32, 8) ) |-> storedInstr ( VMAXV . S8 r2 , q0 , .Operands )
    memloc ( mi(32, 9) ) |-> storedInstr ( VMOV q0 , # 6941985641167737716528846811377828489732 , .Operands )
    memloc ( mi(32, 10) ) |-> storedInstr ( MOV r3 , # 0 , .Operands )
    memloc ( mi(32, 11) ) |-> storedInstr ( VMAXV . S8 r3 , q0 , .Operands )
    memloc ( mi(32, 12) ) |-> storedInstr ( VMOV q0 , # 1033363727627029601985649396351097798283 , .Operands )
    memloc ( mi(32, 13) ) |-> storedInstr ( MOV r4 , # 0 , .Operands )
    memloc ( mi(32, 14) ) |-> storedInstr ( VMAXV . S8 r4 , q0 , .Operands )
    memloc ( mi(32, 15) ) |-> storedInstr ( VMOV q0 , # 5827932009669502875666190544285247877436 , .Operands )
    memloc ( mi(32, 16) ) |-> storedInstr ( MOV r5 , # 0 , .Operands )
    memloc ( mi(32, 17) ) |-> storedInstr ( VMAXV . S8 r5 , q0 , .Operands )
    memloc ( mi(32, 18) ) |-> storedInstr ( VMOV q0 , # 4924138603098770130358131084558987319475 , .Operands )
    memloc ( mi(32, 19) ) |-> storedInstr ( MOV r6 , # 0 , .Operands )
    memloc ( mi(32, 20) ) |-> storedInstr ( VMAXV . S8 r6 , q0 , .Operands )
    memloc ( mi(32, 21) ) |-> storedInstr ( VMOV q0 , # 4337644267499194279942952270566116581885 , .Operands )
    memloc ( mi(32, 22) ) |-> storedInstr ( MOV r7 , # 0 , .Operands )
    memloc ( mi(32, 23) ) |-> storedInstr ( VMAXV . S8 r7 , q0 , .Operands )
    memloc ( mi(32, 24) ) |-> storedInstr ( VMOV . $ 8 q1 [ 0 ] , r0 , .Operands )
    memloc ( mi(32, 25) ) |-> storedInstr ( VMOV . $ 8 q1 [ 1 ] , r1 , .Operands )
    memloc ( mi(32, 26) ) |-> storedInstr ( VMOV . $ 8 q1 [ 2 ] , r2 , .Operands )
    memloc ( mi(32, 27) ) |-> storedInstr ( VMOV . $ 8 q1 [ 3 ] , r3 , .Operands )
    memloc ( mi(32, 28) ) |-> storedInstr ( VMOV . $ 8 q1 [ 4 ] , r4 , .Operands )
    memloc ( mi(32, 29) ) |-> storedInstr ( VMOV . $ 8 q1 [ 5 ] , r5 , .Operands )
    memloc ( mi(32, 30) ) |-> storedInstr ( VMOV . $ 8 q1 [ 6 ] , r6 , .Operands )
    memloc ( mi(32, 31) ) |-> storedInstr ( VMOV . $ 8 q1 [ 7 ] , r7 , .Operands )
    memloc ( mi(32, 32) ) |-> storedInstr ( VMOV q0 , # 663655083119278761867668831250121166231 , .Operands )
    memloc ( mi(32, 33) ) |-> storedInstr ( MOV r0 , # 0 , .Operands )
    memloc ( mi(32, 34) ) |-> storedInstr ( VMAXV . S8 r0 , q0 , .Operands )
    memloc ( mi(32, 35) ) |-> storedInstr ( VMOV q0 , # 2600692742856490401830912406952153398413 , .Operands )
    memloc ( mi(32, 36) ) |-> storedInstr ( MOV r1 , # 0 , .Operands )
    memloc ( mi(32, 37) ) |-> storedInstr ( VMAXV . S8 r1 , q0 , .Operands )
    memloc ( mi(32, 38) ) |-> storedInstr ( VMOV q0 , # 907112666069913837349867571395165964263 , .Operands )
    memloc ( mi(32, 39) ) |-> storedInstr ( MOV r2 , # 0 , .Operands )
    memloc ( mi(32, 40) ) |-> storedInstr ( VMAXV . S8 r2 , q0 , .Operands )
    memloc ( mi(32, 41) ) |-> storedInstr ( VMOV q0 , # 2694932117843888001747399394048380112313 , .Operands )
    memloc ( mi(32, 42) ) |-> storedInstr ( MOV r3 , # 0 , .Operands )
    memloc ( mi(32, 43) ) |-> storedInstr ( VMAXV . S8 r3 , q0 , .Operands )
    memloc ( mi(32, 44) ) |-> storedInstr ( VMOV q0 , # 9821821920241091215713474566232361892674 , .Operands )
    memloc ( mi(32, 45) ) |-> storedInstr ( MOV r4 , # 0 , .Operands )
    memloc ( mi(32, 46) ) |-> storedInstr ( VMAXV . S8 r4 , q0 , .Operands )
    memloc ( mi(32, 47) ) |-> storedInstr ( VMOV q0 , # 4009198122623912839089364287453441355107 , .Operands )
    memloc ( mi(32, 48) ) |-> storedInstr ( MOV r5 , # 0 , .Operands )
    memloc ( mi(32, 49) ) |-> storedInstr ( VMAXV . S8 r5 , q0 , .Operands )
    memloc ( mi(32, 50) ) |-> storedInstr ( VMOV q0 , # 6247730918379965557388463542923074116009 , .Operands )
    memloc ( mi(32, 51) ) |-> storedInstr ( MOV r6 , # 0 , .Operands )
    memloc ( mi(32, 52) ) |-> storedInstr ( VMAXV . S8 r6 , q0 , .Operands )
    memloc ( mi(32, 53) ) |-> storedInstr ( VMOV q0 , # 157316759269120729406377316743496927952 , .Operands )
    memloc ( mi(32, 54) ) |-> storedInstr ( MOV r7 , # 0 , .Operands )
    memloc ( mi(32, 55) ) |-> storedInstr ( VMAXV . S8 r7 , q0 , .Operands )
    memloc ( mi(32, 56) ) |-> storedInstr ( VMOV . $ 8 q1 [ 8 ] , r0 , .Operands )
    memloc ( mi(32, 57) ) |-> storedInstr ( VMOV . $ 8 q1 [ 9 ] , r1 , .Operands )
    memloc ( mi(32, 58) ) |-> storedInstr ( VMOV . $ 8 q1 [ 10 ] , r2 , .Operands )
    memloc ( mi(32, 59) ) |-> storedInstr ( VMOV . $ 8 q1 [ 11 ] , r3 , .Operands )
    memloc ( mi(32, 60) ) |-> storedInstr ( VMOV . $ 8 q1 [ 12 ] , r4 , .Operands )
    memloc ( mi(32, 61) ) |-> storedInstr ( VMOV . $ 8 q1 [ 13 ] , r5 , .Operands )
    memloc ( mi(32, 62) ) |-> storedInstr ( VMOV . $ 8 q1 [ 14 ] , r6 , .Operands )
    memloc ( mi(32, 63) ) |-> storedInstr ( VMOV . $ 8 q1 [ 15 ] , r7 , .Operands )
    memloc ( mi(32, 64) ) |-> storedInstr ( VMOV q2 , # 9110302564881101301142797185345813108425 , .Operands )
    memloc ( mi(32, 65) ) |-> storedInstr ( MOV r8 , # 0 , .Operands )
    memloc ( mi(32, 66) ) |-> storedInstr ( VMLAV . S8 r8 , q1 , q2 , .Operands )
    memloc ( mi(32, 67) ) |-> storedInstr ( VMOV q3 , # 9322581109971323809051289431880843386465 , .Operands )
    memloc ( mi(32, 68) ) |-> storedInstr ( MOV r9 , # 0 , .Operands )
    memloc ( mi(32, 69) ) |-> storedInstr ( VMLAV . S8 r9 , q1 , q3 , .Operands )
    memloc ( mi(32, 70) ) |-> storedInstr ( VMOV q4 , # 6459888891961543482907143830613458548582 , .Operands )
    memloc ( mi(32, 71) ) |-> storedInstr ( MOV r10 , # 0 , .Operands )
    memloc ( mi(32, 72) ) |-> storedInstr ( VMLAV . S8 r10 , q1 , q4 , .Operands )
    memloc ( mi(32, 73) ) |-> storedInstr ( VMOV q5 , # 6667587189888747373090849516989613237196 , .Operands )
    memloc ( mi(32, 74) ) |-> storedInstr ( MOV r11 , # 0 , .Operands )
    memloc ( mi(32, 75) ) |-> storedInstr ( VMLAV . S8 r11 , q1 , q5 , .Operands )
    memloc ( mi(32, 76) ) |-> storedInstr ( end .Operands )  )
       </instructiontext>
       <regstate>
         /*
         "CONTROL" |-> mi(32, 1)
         "CONTROL_NS" |-> mi(32, 1)
         "CONTROL_S" |-> mi(32, 1)
         "CPACR" |-> mi(32, 3145728)
         "CPACR_NS" |-> mi(32, 3145728)
         "CPACR_S" |-> mi(32, 3145728)
         "CPPWR" |-> mi(32, 0)
         "CPPWR_NS" |-> mi(32, 0)
         "CPPWR_S" |-> mi(32, 0)
         "EPSR" |-> mi(32, 2048)
         "FPCCR" |-> mi(32, 0)
         "FPCCR_NS" |-> mi(32, 0)
         "FPCCR_S" |-> mi(32, 0)
         "MVFR1" |-> mi(32, 256)
         "NSACR" |-> mi(32, 1024)
         "VPR" |-> mi(32, 2048)
         */
         "R8" |-> mi(32, 4294882987)
         "R9" |-> mi(32, 4294963100)
         "R10" |-> mi(32, 4294932822)
         "R11" |-> mi(32, 21806)
         "R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 77)))
       </regstate>
          //requires (A >=Int 0) andBool (A <Int (2 ^Int 32))
           
endmodule
