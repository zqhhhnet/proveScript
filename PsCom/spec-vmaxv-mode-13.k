require "armv8-semantics.k"
module SPEC-VMAXV-MODE-13
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
			memloc(mi(32, 0)) |-> storedInstr( cmp . S8 r7, q0, # 0, # 13, # 0, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q0" |-> concatenateMInt(mi(8, Q0015), concatenateMInt(mi(8, Q0014), concatenateMInt(mi(8, Q0013), concatenateMInt(mi(8, Q0012), concatenateMInt(mi(8, Q0011), concatenateMInt(mi(8, Q0010), concatenateMInt(mi(8, Q009), concatenateMInt(mi(8, Q008), concatenateMInt(mi(8, Q007), concatenateMInt(mi(8, Q006), concatenateMInt(mi(8, Q005), concatenateMInt(mi(8, Q004), concatenateMInt(mi(8, Q003), concatenateMInt(mi(8, Q002), concatenateMInt(mi(8, Q001), mi(8, Q000))))))))))))))))
			"S0" |-> concatenateMInt(mi(8, Q003), concatenateMInt(mi(8, Q002), concatenateMInt(mi(8, Q001), mi(8, Q000))))
			"S1" |-> concatenateMInt(mi(8, Q007), concatenateMInt(mi(8, Q006), concatenateMInt(mi(8, Q005), mi(8, Q004))))
			"S2" |-> concatenateMInt(mi(8, Q0011), concatenateMInt(mi(8, Q0010), concatenateMInt(mi(8, Q009), mi(8, Q008))))
			"S3" |-> concatenateMInt(mi(8, Q0015), concatenateMInt(mi(8, Q0014), concatenateMInt(mi(8, Q0013), mi(8, Q0012))))
			"R7" |-> (mi(32, New012) => mi(32, svalueMInt(ifMInt svalueMInt(extractMInt(mi(32, New012), 24, 32)) >Int svalueMInt(mi(8, Q0013)) then extractMInt(mi(32, New012), 24, 32) else mi(8, Q0013))))
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires Q000 >=Int -64 andBool Q000 <=Int 7
			andBool Q001 >=Int -25 andBool Q001 <=Int 1
			andBool Q002 >=Int -26 andBool Q002 <=Int 22
			andBool Q003 >=Int -24 andBool Q003 <=Int 19
			andBool Q004 >=Int -12 andBool Q004 <=Int 4
			andBool Q005 >=Int -11 andBool Q005 <=Int 5
			andBool Q006 >=Int -32 andBool Q006 <=Int 0
			andBool Q007 >=Int -12 andBool Q007 <=Int 59
			andBool Q008 >=Int 0 andBool Q008 <=Int 31
			andBool Q009 >=Int -2 andBool Q009 <=Int 27
			andBool Q0010 >=Int 23 andBool Q0010 <=Int 54
			andBool Q0011 >=Int 12 andBool Q0011 <=Int 89
			andBool Q0012 >=Int 13 andBool Q0012 <=Int 88
			andBool Q0013 >=Int 15 andBool Q0013 <=Int 55
			andBool Q0014 >=Int 20 andBool Q0014 <=Int 112
			andBool Q0015 >=Int 12 andBool Q0015 <=Int 111
			andBool New012 >=Int 23 andBool New012 <=Int 89
endmodule
