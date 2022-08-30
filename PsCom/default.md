'''
  instruction default set to the system registers
'''

1  VMAX VMAXA
	Decode
		** size != '11'
		** CheckDecodeFaults(Ext Type_Mve) :
			** ThisInstr() : return UNKNOWN or the instruction encode
				** HaveMve() : True
			** IsCPInstruction(ThisInstr()) : return isCP : true , return cpNumber : 10
			** CheckCPEnabled() : 
				** IsCPEnabled(cp, privileged, secure) : cp = 10, privilieged unkonwn, secure is T, return enabled is true, toSecure unkonwn
					** CONTROL.nPRIV [0] : 1 ; 
					** CPACR.S [21:20] : '11' access right for FP
					** NSACR[10] = '1'
					** CPPWR_S[20] = '0' 
				** excInfo = DefaultExcInfo() : execute the default action
			** MVFR1.MVE != '0000'
		** InITBlock() : ITSTATE[3:0] == '0000', return false .  EPSR.IT == '00001000' [15:10]:[26:25]
		** VMAX : D=0 M=0 N=0
		** VMAXA : Da=0 M=0
		
	Operation
		** ExecuteFPCheck() : 
			** PreserveFPState() : 
				** FPCCR_S.LSPACT / FPCCR_NS.LSPACT [0] = '0' and that avoid to execute the other check for the lazy stack preserve action
				** FPCCR.ASPEN [31] = '0'
				** CONTROL.FPCA [2] = '0'
		** (curBeat, elmtMask) = GetCurInstrBeat() : for 4 times
			** Ones(4) = '1111'
			** VPR.P0 = '111*1'
			** LoopCount = 1 2 3 4
			** _BeatID =   0 1 2 3
			** ltpsize = predSize : '000' means 8b (vector element size) , '001' means 16b, '010' means 32b, '011' means 64b, '100' means not applied
			** elmtMask = '1111' means active for the element

2   VMAXNM(FP)
	Operation
		** FPCCR.ASPEN [31] = '1'
		** FPSCR.AHP [26] = '0'
			
			
		
			
