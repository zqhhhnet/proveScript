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
			memloc(mi(32, 0)) |-> storedInstr( VMOV q5, # U, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q5" |-> mi(128, U)
			"S20" |-> extractMInt(mi(128, U), 96,128)
			"S21" |-> extractMInt(mi(128, U), 64,96)
			"S22" |-> extractMInt(mi(128, U), 32,64)
			"S23" |-> extractMInt(mi(128, U), 0,32)
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires 0 <=Int U andBool U <=Int 340282366920938463463374607431768211455
endmodule
