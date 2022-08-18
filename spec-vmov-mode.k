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
			memloc(mi(32, 0)) |-> storedInstr( VMOV q1, q2, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q2" |-> mi(128, 0)
			"Q1" |-> mi(128, 0)
			"S8" |-> extractMInt(mi(128, 0), 96,128)
			"S9" |-> extractMInt(mi(128, 0), 64,96)
			"S10" |-> extractMInt(mi(128, 0), 32,64)
			"S11" |-> extractMInt(mi(128, 0), 0,32)
			"S4" |-> extractMInt(mi(128, 0), 96,128)
			"S5" |-> extractMInt(mi(128, 0), 64,96)
			"S6" |-> extractMInt(mi(128, 0), 32,64)
			"S7" |-> extractMInt(mi(128, 0), 0,32)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
		</regstate>
			requires endmodule
