require "armv8-semantics.k"
module SPEC-VMOV-LANE-MODE
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
			memloc(mi(32, 0)) |-> storedInstr( VMOV . $8 q1[15], r7, .Operands)
			)
		</instructiontext>
		<regstate>
			"R7" |-> mi(32, New015)
			"Q1" |-> (mi(128, Q1_V) => concatenateMInt(extractMInt(mi(32, New015), 24, 32), extractMInt(mi(128, Q1_V), 8, 128)))
			"S4" |-> extractMInt(mi(128, Q1_V), 96, 128)
			"S5" |-> extractMInt(mi(128, Q1_V), 64, 96)
			"S6" |-> extractMInt(mi(128, Q1_V), 32, 64)
			"S7" |-> (extractMInt(mi(128, Q1_V),0, 32) => concatenateMInt(extractMInt(mi(32, New015), 24, 32), extractMInt(mi(128, Q1_V), 8, 32)))
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires Q1_V ==Int 0
				andBool 23 <=Int New015 andBool New015 <=Int 112
endmodule
