require "armv8-loader.k"
require "vmax.k"
require "armv8-abstract-semantic.k"
require "armv8-verification.k"
require "armv8-mint.k"
require "exit.k"
require "vmaxnm.k"
require "vmov.k"
require "vmaxa.k"
require "vmaxnma.k"
require "vmaxnmv.k"
require "mov.k"
require "vmaxnmav.k"
require "vmaxv.k"
require "vmaxav.k"
require "vmin.k"
require "vmina.k"
require "vminv.k"
require "vminav.k"
require "vminnm.k"
require "vminnma.k"
require "vminnmv.k"
require "vminnmav.k"
require "vmlav.k"
require "add-for-test.k"
require "max-for-test.k"

// add for check
require "sst.k"
require "ext.k"
require "dtc.k"
require "cmp.k"
require "sto.k"
require "conca.k"
require "sint.k"
require "uint.k"
require "maa.k"

module ARMV8-SEMANTICS
  imports ARMV8-LOADER
  imports ARMV8-ABSTRACT-SEMANTIC
  imports VMAX
  imports ARMV8-VERIFICATION
  imports ARMV8-MINT
  imports EXIT
  imports VMAXNM
  imports VMOV
  imports VMAXA
  imports VMAXNMA
  imports VMAXNMV
  imports MOV
  imports VMAXNMAV
  imports VMAXV
  imports VMAXAV
  imports VMIN
  imports VMINA
  imports VMINV
  imports VMINAV
  imports VMINNM
  imports VMINNMA
  imports VMINNMV
  imports VMINNMAV
  imports VMLAV
  imports ADD-FOR-TEST
  imports MAX-FOR-TEST
  
  //add for check
  imports SST
  imports EXT
  imports DTC
  imports CMP
  imports STO
  imports CONCA
  imports UINT
  imports SINT
  imports MAA
  
endmodule
