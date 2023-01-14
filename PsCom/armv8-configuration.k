require "armv8-syntax.k"
require "armv8-abstract-syntax.k"
require "armv8-mint.k"

module ARMV8-CONFIGURATION
  imports ARMV8-SYNTAX
  imports ARMV8-MINT-SYNTAX
  imports ARMV8-ABSTRACT-SYNTAX
  imports MINT
  
  configuration
    <k>
      // initDefaultRegs ~>
      $PGM:Instructions ~>
      loadBegin ~>
      registersMessage ~>
      scan
    </k>
    
    <begin> .K </begin>
    <currentstate> "text" </currentstate>
    <nextloc> mi(32, 0) </nextloc>
    <functarget> .Map </functarget>
    <instructiontext> code(.Map) </instructiontext>
    
    <regstate> 
      //.Map
      // Qn for check
      
      ("Q0"		|-> mi(128, 0))
      ("Q1"		|-> mi(128, 0))
      ("Q2"		|-> mi(128, 0))
      ("Q3"		|-> mi(128, 0))
      ("Q4"		|-> mi(128, 0))
      ("Q5"		|-> mi(128, 0))
      ("Q6"		|-> mi(128, 0))
      ("Q7"		|-> mi(128, 0))
      
      // Dn for check 
      
      ("D0"		|-> mi(64, 0))
      ("D1"		|-> mi(64, 0))
      ("D2"		|-> mi(64, 0))
      ("D3"		|-> mi(64, 0))
      ("D4"		|-> mi(64, 0))
      ("D5"		|-> mi(64, 0))
      ("D6"		|-> mi(64, 0))
      ("D7"		|-> mi(64, 0))
      ("D8"		|-> mi(64, 0))
      ("D9"		|-> mi(64, 0))
      ("D10"		|-> mi(64, 0))
      ("D11"		|-> mi(64, 0))
      ("D12"		|-> mi(64, 0))
      ("D13"		|-> mi(64, 0))
      ("D14"		|-> mi(64, 0))
      ("D15"		|-> mi(64, 0))
      
      ("R0"		|-> mi(32, 0))
      ("R1"		|-> mi(32, 0))
      ("R2"		|-> mi(32, 0))
      ("R3"		|-> mi(32, 0))
      ("R4"		|-> mi(32, 0))
      ("R5"		|-> mi(32, 0))
      ("R6"		|-> mi(32, 0))
      ("R7"		|-> mi(32, 0))
      ("R8"		|-> mi(32, 0))
      ("R9"		|-> mi(32, 0))
      ("R10"		|-> mi(32, 0))
      ("R11"		|-> mi(32, 0))
      ("R12"		|-> mi(32, 0))
      ("R13"		|-> mi(32, 0))
      ("R14"		|-> mi(32, 0))
      ("R15"		|-> mi(32, 0)) 
      ("S0"		|-> mi(32, 0))
      ("S1"		|-> mi(32, 0))
      ("S2"		|-> mi(32, 0))
      ("S3"		|-> mi(32, 0))
      ("S4"		|-> mi(32, 0))
      ("S5"		|-> mi(32, 0))
      ("S6"		|-> mi(32, 0))
      ("S7"		|-> mi(32, 0))
      ("S8"		|-> mi(32, 0))
      
      ("S9"		|-> mi(32, 0))
      ("S10"		|-> mi(32, 0))
      ("S11"		|-> mi(32, 0))
      ("S12"		|-> mi(32, 0))
      ("S13"		|-> mi(32, 0))
      ("S14"		|-> mi(32, 0))
      ("S15"		|-> mi(32, 0))
      ("S16"		|-> mi(32, 0))
      ("S17"		|-> mi(32, 0))
      ("S18"		|-> mi(32, 0))
      ("S19"		|-> mi(32, 0))
      ("S20"		|-> mi(32, 0))
      ("S21"		|-> mi(32, 0))
      ("S22"		|-> mi(32, 0))
      ("S23"		|-> mi(32, 0))
      ("S24"		|-> mi(32, 0))
      ("S25"		|-> mi(32, 0))
      ("S26"		|-> mi(32, 0))
      ("S27"		|-> mi(32, 0))
      ("S28"		|-> mi(32, 0))
      ("S29"		|-> mi(32, 0))
      ("S30"		|-> mi(32, 0))
      ("S31"		|-> mi(32, 0))
      
      // virtual "RESULT", default 32bit 0
      
      ("RESULT"	|-> mi(32, 0))
      // virtual "RESULT64", default 64bit 0
      ("RESULT64"	|-> mi(64, 0))
      // set default value to regsiters
      ("CONTROL"	|-> mi(32, 0))
      ("CONTROL_S"	|-> mi(32, 0))
      ("CONTROL_NS"	|-> mi(32, 0))
      ("CPACR_S" 	|-> mi(32, 0))
      ("CPACR_NS" 	|-> mi(32, 0))
      ("CPACR" 	|-> mi(32, 0))
      ("NSACR" 	|-> mi(32, 0))
      ("CPPWR_S" 	|-> mi(32, 0))
      ("CPPWR_NS" 	|-> mi(32, 0))
      ("CPPWR"		|-> mi(32, 0))
      ("MVFR1"		|-> mi(32, 0))
      ("EPSR"		|-> mi(32, 0))
      ("FPCCR"		|-> mi(32, 0))
      ("FPCCR_S"	|-> mi(32, 0))
      ("FPCCR_NS"	|-> mi(32, 0))
      ("VPR"		|-> mi(32, 0))
      //("FPSCR"		|-> mi(32, 0))
      // for prove
      ("FPSCR"    |-> mi(32, 50331648))
      // add for check
      ("TEMP1"		|-> mi(32, 0))
      ("TEMP2"		|-> mi(32, 0))
      ("V_TEMP1"	|-> 0)
      ("V_TEMP2"	|-> 0)
      
    </regstate>
    
    <regstateseq> .List </regstateseq>
    
endmodule
