require "armv8-semantics.k"
module SPEC-VMAXNMV-CHECK
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
			memloc(mi(32, 0)) |-> storedInstr( cmp . F32 r0, q0, # 0, # 1, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q0" |-> concatenateMInt(mi(32, B3), concatenateMInt(mi(32, B2), concatenateMInt((mi(32, B1)):MInt, mi(32, B0))))
			"S0" |-> mi(32, B0)
			"S1" |-> mi(32, B1)
			"S2" |-> mi(32, B2)
			"S3" |-> mi(32, B3)
		    "FPSCR" |-> (mi(32, 50331648) => mi(32, ?Y))

			"R0" |-> (mi(32, 2139095030) => mi(32, ?X))

			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires B0 >=Int 0 andBool B0 <=Int 213
            andBool bitwidthMInt(mi(32, B1)) ==Int 32
			andBool B1 >=Int 2139095037 andBool B1 <=Int 2139095038
            andBool uvalueMInt(extractMInt({mi(32, B1)}:>MInt, 1, 9)) <Int 255 andBool uvalueMInt(extractMInt(mi(32, B1), 1, 9)) >Int 0
            andBool ultMInt(lshrMInt(mi(32,B1), 23), mi(32, 255))
			andBool B2 >=Int 26 andBool B2 <=Int 27
			andBool B3 >=Int 24 andBool B3 <=Int 1823
			//andBool A >=Int 8388609 andBool A <=Int 8388609 
			//andBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))

            ensures ?Y ==Int 50331648 andBool ?X ==Int B1
endmodule
