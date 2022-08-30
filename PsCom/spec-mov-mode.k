require "armv8-semantics.k"
module SPEC-MOV-MODE
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
			memloc(mi(32, 0)) |-> storedInstr( MOV r0, # A, .Operands)
			)
		</instructiontext>
		<regstate>
			"R0" |-> mi(32, A)
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires -32 <=Int A andBool A <=Int 63
endmodule
