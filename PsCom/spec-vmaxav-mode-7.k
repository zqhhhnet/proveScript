require "armv8-semantics.k"
module SPEC-VMAXAV-MODE-7
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
			memloc(mi(32, 0)) |-> storedInstr( cmpAbs . S8 r0, q0, # 0, # 7, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q0" |-> concatenateMInt(mi(8, B0015), concatenateMInt(mi(8, B0014), concatenateMInt(mi(8, B0013), concatenateMInt(mi(8, B0012), concatenateMInt(mi(8, B0011), concatenateMInt(mi(8, B0010), concatenateMInt(mi(8, B009), concatenateMInt(mi(8, B008), concatenateMInt(mi(8, B007), concatenateMInt(mi(8, B006), concatenateMInt(mi(8, B005), concatenateMInt(mi(8, B004), concatenateMInt(mi(8, B003), concatenateMInt(mi(8, B002), concatenateMInt(mi(8, B001), mi(8, B000))))))))))))))))
			"S0" |-> concatenateMInt(mi(8, B003), concatenateMInt(mi(8, B002), concatenateMInt(mi(8, B001), mi(8, B000))))
			"S1" |-> concatenateMInt(mi(8, B007), concatenateMInt(mi(8, B006), concatenateMInt(mi(8, B005), mi(8, B004))))
			"S2" |-> concatenateMInt(mi(8, B0011), concatenateMInt(mi(8, B0010), concatenateMInt(mi(8, B009), mi(8, B008))))
			"S3" |-> concatenateMInt(mi(8, B0015), concatenateMInt(mi(8, B0014), concatenateMInt(mi(8, B0013), mi(8, B0012))))
			"R0" |-> (mi(32, NewA6) => mi(32, svalueMInt(ifMInt absInt(B007) <=Int uvalueMInt(extractMInt(mi(32, NewA6), 24, 32)) then extractMInt(mi(32, NewA6), 24, 32) else mi(8, absInt(B007)))))
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires B000 >=Int -64 andBool B000 <=Int 7
			andBool B001 >=Int -25 andBool B001 <=Int 1
			andBool B002 >=Int -26 andBool B002 <=Int 22
			andBool B003 >=Int -24 andBool B003 <=Int 19
			andBool B004 >=Int -12 andBool B004 <=Int 4
			andBool B005 >=Int -11 andBool B005 <=Int 5
			andBool B006 >=Int -32 andBool B006 <=Int 0
			andBool B007 >=Int -12 andBool B007 <=Int 59
			andBool B008 >=Int 0 andBool B008 <=Int 31
			andBool B009 >=Int -2 andBool B009 <=Int 27
			andBool B0010 >=Int 23 andBool B0010 <=Int 54
			andBool B0011 >=Int 12 andBool B0011 <=Int 89
			andBool B0012 >=Int 13 andBool B0012 <=Int 88
			andBool B0013 >=Int 15 andBool B0013 <=Int 55
			andBool B0014 >=Int 20 andBool B0014 <=Int 112
			andBool B0015 >=Int 12 andBool B0015 <=Int 111
			andBool NewA6 >=Int -32 andBool NewA6 <=Int 64
endmodule
