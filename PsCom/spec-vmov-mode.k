require "armv8-semantics.k"
module SPEC-VMOV-MODE
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
			code (
			memloc(mi(32, 0)) |-> storedInstr( VMOV q0, # B, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q0" |-> mi(128, B)
			"S0" |-> extractMInt(mi(128, B), 96,128)
			"S1" |-> extractMInt(mi(128, B), 64,96)
			"S2" |-> extractMInt(mi(128, B), 32,64)
			"S3" |-> extractMInt(mi(128, B), 0,32)
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires 0 <=Int B andBool B <=Int 340282366920938463463374607431768211455
endmodule
