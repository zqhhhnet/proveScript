/*@
    Set begin state
*/

require "armv8-configuration.k"

module SST
  imports ARMV8-CONFIGURATION
  
  rule <k> setDefaultRegs(sst:StepCommand) => . ...</k>
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
         )
       </regstate>
  
  rule <k> execinstr(sst:StepCommand .Operands) => . 
       ...</k>
       <regstate> RSMap:Map </regstate>
endmodule
