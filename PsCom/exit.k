requires "armv8-configuration.k"

module EXIT
  imports ARMV8-CONFIGURATION
  
  // context execinstr(end:Opcode .Operands)
  rule <k> setDefaultRegs(end:Opcode) => . ...</k>
       <regstate> RSMap:Map </regstate>

  rule <k> execinstr (end:Opcode .Operands) => . ...</k>
       <regstate> RSMap:Map </regstate>
endmodule
