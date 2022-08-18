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
			memloc(mi(32, 0)) |-> storedInstr( MOV r1, # A, .Operands)
			)
		</instructiontext>
		<regstate>
			"R1" |-> mi(32, A)
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
			"RESULT" |-> mi(32, 0)
			"RESULT64" |-> mi(64, 0)
		</regstate>
			requires 1 <=Int A andBool A <=Int 10
endmodule
