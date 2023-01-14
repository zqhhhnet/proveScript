require "armv8-semantics.k"
module SPEC-VMLAV-MODE-0
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
			memloc(mi(32, 0)) |-> storedInstr( maa . S8 r11, q1, q5, # 0, Operands)
			)
		</instructiontext>
		<regstate>
			"Q1" |-> concatenateMInt(mi(8, Q1_V0015), concatenateMInt(mi(8, Q1_V0014), concatenateMInt(mi(8, Q1_V0013), concatenateMInt(mi(8, Q1_V0012), concatenateMInt(mi(8, Q1_V0011), concatenateMInt(mi(8, Q1_V0010), concatenateMInt(mi(8, Q1_V009), concatenateMInt(mi(8, Q1_V008), concatenateMInt(mi(8, Q1_V007), concatenateMInt(mi(8, Q1_V006), concatenateMInt(mi(8, Q1_V005), concatenateMInt(mi(8, Q1_V004), concatenateMInt(mi(8, Q1_V003), concatenateMInt(mi(8, Q1_V002), concatenateMInt(mi(8, Q1_V001), mi(8, Q1_V000))))))))))))))))
			"S4" |-> concatenateMInt(mi(8, Q1_V003), concatenateMInt(mi(8, Q1_V002), concatenateMInt(mi(8, Q1_V001), mi(8, Q1_V000))))
			"S5" |-> concatenateMInt(mi(8, Q1_V007), concatenateMInt(mi(8, Q1_V006), concatenateMInt(mi(8, Q1_V005), mi(8, Q1_V004))))
			"S6" |-> concatenateMInt(mi(8, Q1_V0011), concatenateMInt(mi(8, Q1_V0010), concatenateMInt(mi(8, Q1_V009), mi(8, Q1_V008))))
			"S7" |-> concatenateMInt(mi(8, Q1_V0015), concatenateMInt(mi(8, Q1_V0014), concatenateMInt(mi(8, Q1_V0013), mi(8, Q1_V0012))))
			"Q5" |-> concatenateMInt(mi(8, U0015), concatenateMInt(mi(8, U0014), concatenateMInt(mi(8, U0013), concatenateMInt(mi(8, U0012), concatenateMInt(mi(8, U0011), concatenateMInt(mi(8, U0010), concatenateMInt(mi(8, U009), concatenateMInt(mi(8, U008), concatenateMInt(mi(8, U007), concatenateMInt(mi(8, U006), concatenateMInt(mi(8, U005), concatenateMInt(mi(8, U004), concatenateMInt(mi(8, U003), concatenateMInt(mi(8, U002), concatenateMInt(mi(8, U001), mi(8, U000))))))))))))))))
			"S20" |-> concatenateMInt(mi(8, U003), concatenateMInt(mi(8, U002), concatenateMInt(mi(8, U001), mi(8, U000))))
			"S21" |-> concatenateMInt(mi(8, U007), concatenateMInt(mi(8, U006), concatenateMInt(mi(8, U005), mi(8, U004))))
			"S22" |-> concatenateMInt(mi(8, U0011), concatenateMInt(mi(8, U0010), concatenateMInt(mi(8, U009), mi(8, U008))))
			"S23" |-> concatenateMInt(mi(8, U0015), concatenateMInt(mi(8, U0014), concatenateMInt(mi(8, U0013), mi(8, U0012))))
			"R11" |-> (mi(32, 0) => ifMInt ((Q1_V000 *Int U000 +Int Q1_V001 *Int U001 +Int Q1_V002 *Int U002 +Int Q1_V003 *Int U003 +Int 0 >=Int -2 ^Int 31) andBool (Q1_V000 *Int U000 +Int Q1_V001 *Int U001 +Int Q1_V002 *Int U002 +Int Q1_V003 *Int U003 +Int 0 <=Int 2 ^Int 31 -Int 1)) then (extractMInt(mi(64, Q1_V000 *Int U000 +Int Q1_V001 *Int U001 +Int Q1_V002 *Int U002 +Int Q1_V003 *Int U003 +Int 0), 32, 64)) else (undefMInt32))
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires Q1_V000 >=Int 23 andBool Q1_V000 <=Int 112
			andBool Q1_V001 >=Int 23 andBool Q1_V001 <=Int 112
			andBool Q1_V002 >=Int 23 andBool Q1_V002 <=Int 112
			andBool Q1_V003 >=Int 23 andBool Q1_V003 <=Int 112
			andBool Q1_V004 >=Int 23 andBool Q1_V004 <=Int 112
			andBool Q1_V005 >=Int 23 andBool Q1_V005 <=Int 112
			andBool Q1_V006 >=Int 23 andBool Q1_V006 <=Int 112
			andBool Q1_V007 >=Int 23 andBool Q1_V007 <=Int 112
			andBool Q1_V008 >=Int 23 andBool Q1_V008 <=Int 112
			andBool Q1_V009 >=Int 23 andBool Q1_V009 <=Int 112
			andBool Q1_V0010 >=Int 23 andBool Q1_V0010 <=Int 112
			andBool Q1_V0011 >=Int 23 andBool Q1_V0011 <=Int 112
			andBool Q1_V0012 >=Int 23 andBool Q1_V0012 <=Int 112
			andBool Q1_V0013 >=Int 23 andBool Q1_V0013 <=Int 112
			andBool Q1_V0014 >=Int 23 andBool Q1_V0014 <=Int 112
			andBool Q1_V0015 >=Int 23 andBool Q1_V0015 <=Int 112
			andBool U000 >=Int -64 andBool U000 <=Int 7
			andBool U001 >=Int -25 andBool U001 <=Int 1
			andBool U002 >=Int -26 andBool U002 <=Int 22
			andBool U003 >=Int -24 andBool U003 <=Int 19
			andBool U004 >=Int -12 andBool U004 <=Int 4
			andBool U005 >=Int -11 andBool U005 <=Int 5
			andBool U006 >=Int -32 andBool U006 <=Int 0
			andBool U007 >=Int -12 andBool U007 <=Int 59
			andBool U008 >=Int 0 andBool U008 <=Int 31
			andBool U009 >=Int -2 andBool U009 <=Int 27
			andBool U0010 >=Int 23 andBool U0010 <=Int 54
			andBool U0011 >=Int 12 andBool U0011 <=Int 89
			andBool U0012 >=Int 13 andBool U0012 <=Int 88
			andBool U0013 >=Int 15 andBool U0013 <=Int 55
			andBool U0014 >=Int 20 andBool U0014 <=Int 112
			andBool U0015 >=Int 12 andBool U0015 <=Int 111
			andBool 0 >=Int 0 andBool 0 <=Int 0
endmodule
