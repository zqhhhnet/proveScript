require "armv8-semantics.k"
module SPEC-VMAX-ONCE
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
			memloc(mi(32, 0)) |-> storedInstr( VMAX . S8 q0, q1, q0, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q1" |-> concatenateMInt(mi(8, A0015), concatenateMInt(mi(8, A0014), concatenateMInt(mi(8, A0013), concatenateMInt(mi(8, A0012), concatenateMInt(mi(8, A0011), concatenateMInt(mi(8, A0010), concatenateMInt(mi(8, A009), concatenateMInt(mi(8, A008), concatenateMInt(mi(8, A007), concatenateMInt(mi(8, A006), concatenateMInt(mi(8, A005), concatenateMInt(mi(8, A004), concatenateMInt(mi(8, A003), concatenateMInt(mi(8, A002), concatenateMInt(mi(8, A001), mi(8, A000))))))))))))))))
			"S4" |-> concatenateMInt(mi(8, A003), concatenateMInt(mi(8, A002), concatenateMInt(mi(8, A001), mi(8, A000))))
			"S5" |-> concatenateMInt(mi(8, A007), concatenateMInt(mi(8, A006), concatenateMInt(mi(8, A005), mi(8, A004))))
			"S6" |-> concatenateMInt(mi(8, A0011), concatenateMInt(mi(8, A0010), concatenateMInt(mi(8, A009), mi(8, A008))))
			"S7" |-> concatenateMInt(mi(8, A0015), concatenateMInt(mi(8, A0014), concatenateMInt(mi(8, A0013), mi(8, A0012))))
			"CONTROL" |-> (mi(32, _:Int) => mi(32, 1))
			"CONTROL_NS" |-> (mi(32, _:Int) => mi(32, 1))
 			"CONTROL_S" |-> (mi(32, _:Int) => mi(32, 1))
			"CPACR" |-> (mi(32, _:Int) => mi(32, 3145728))
			"CPACR_NS" |-> (mi(32, _:Int) => mi(32, 3145728))
			"CPACR_S" |-> (mi(32, _:Int) => mi(32, 3145728))
			"CPPWR" |-> (mi(32, _:Int) => mi(32, 0))
			"CPPWR_NS" |-> (mi(32, _:Int) => mi(32, 0))
			"CPPWR_S" |-> (mi(32, _:Int) => mi(32, 0))
			"EPSR" |-> (mi(32, _:Int) => mi(32, 2048))
			"FPCCR" |-> (mi(32, _:Int) => mi(32, 0))
			"FPCCR_NS" |-> (mi(32, _:Int) => mi(32, 0))
			"FPCCR_S" |-> (mi(32, _:Int) => mi(32, 0))
			"MVFR1" |-> (mi(32, _:Int) => mi(32, 256))
			"NSACR" |-> (mi(32, _:Int) => mi(32, 1024))
			"VPR" |-> (mi(32, _:Int) => mi(32, 2048))
			"RESULT64" |-> mi(64, 0)

			"S0" |-> (concatenateMInt(mi(8, B003), concatenateMInt(mi(8, B002), concatenateMInt(mi(8, B001), mi(8, B000))))				 => 
				ifMInt notBool IsUndef (concatenateMInt(ifMInt (B003 <=Int A003) then (mi(8, A003)) else mi(8, B003) ,concatenateMInt(ifMInt (B002 <=Int A002) then (mi(8, A002)) else mi(8, B002) ,concatenateMInt(ifMInt (B001 <=Int A001) then (mi(8, A001)) else mi(8, B001) , ifMInt (B000 <=Int A000) then mi(8, A000) else mi(8, B000))))
				) then concatenateMInt(ifMInt (B003 <=Int A003) then (mi(8, A003)) else mi(8, B003) ,concatenateMInt(ifMInt (B002 <=Int A002) then (mi(8, A002)) else mi(8, B002) ,concatenateMInt(ifMInt (B001 <=Int A001) then (mi(8, A001)) else mi(8, B001) , ifMInt (B000 <=Int A000) then mi(8, A000) else mi(8, B000))))
				else undefMInt32)

			"S1" |-> (concatenateMInt(mi(8, B007), concatenateMInt(mi(8, B006), concatenateMInt(mi(8, B005), mi(8, B004))))				 => 
				ifMInt notBool IsUndef (concatenateMInt(ifMInt (B007 <=Int A007) then (mi(8, A007)) else mi(8, B007) ,concatenateMInt(ifMInt (B006 <=Int A006) then (mi(8, A006)) else mi(8, B006) ,concatenateMInt(ifMInt (B005 <=Int A005) then (mi(8, A005)) else mi(8, B005) , ifMInt (B004 <=Int A004) then mi(8, A004) else mi(8, B004))))
				) then concatenateMInt(ifMInt (B007 <=Int A007) then (mi(8, A007)) else mi(8, B007) ,concatenateMInt(ifMInt (B006 <=Int A006) then (mi(8, A006)) else mi(8, B006) ,concatenateMInt(ifMInt (B005 <=Int A005) then (mi(8, A005)) else mi(8, B005) , ifMInt (B004 <=Int A004) then mi(8, A004) else mi(8, B004))))
				else undefMInt32)

			"S2" |-> (concatenateMInt(mi(8, B0011), concatenateMInt(mi(8, B0010), concatenateMInt(mi(8, B009), mi(8, B008))))				 => 
				ifMInt notBool IsUndef (concatenateMInt(ifMInt (B0011 <=Int A0011) then (mi(8, A0011)) else mi(8, B0011) ,concatenateMInt(ifMInt (B0010 <=Int A0010) then (mi(8, A0010)) else mi(8, B0010) ,concatenateMInt(ifMInt (B009 <=Int A009) then (mi(8, A009)) else mi(8, B009) , ifMInt (B008 <=Int A008) then mi(8, A008) else mi(8, B008))))
				) then concatenateMInt(ifMInt (B0011 <=Int A0011) then (mi(8, A0011)) else mi(8, B0011) ,concatenateMInt(ifMInt (B0010 <=Int A0010) then (mi(8, A0010)) else mi(8, B0010) ,concatenateMInt(ifMInt (B009 <=Int A009) then (mi(8, A009)) else mi(8, B009) , ifMInt (B008 <=Int A008) then mi(8, A008) else mi(8, B008))))
				else undefMInt32)

			"S3" |-> (concatenateMInt(mi(8, B0015), concatenateMInt(mi(8, B0014), concatenateMInt(mi(8, B0013), mi(8, B0012))))				 => 
				ifMInt notBool IsUndef (concatenateMInt(ifMInt (B0015 <=Int A0015) then (mi(8, A0015)) else mi(8, B0015) ,concatenateMInt(ifMInt (B0014 <=Int A0014) then (mi(8, A0014)) else mi(8, B0014) ,concatenateMInt(ifMInt (B0013 <=Int A0013) then (mi(8, A0013)) else mi(8, B0013) , ifMInt (B0012 <=Int A0012) then mi(8, A0012) else mi(8, B0012))))
				) then concatenateMInt(ifMInt (B0015 <=Int A0015) then (mi(8, A0015)) else mi(8, B0015) ,concatenateMInt(ifMInt (B0014 <=Int A0014) then (mi(8, A0014)) else mi(8, B0014) ,concatenateMInt(ifMInt (B0013 <=Int A0013) then (mi(8, A0013)) else mi(8, B0013) , ifMInt (B0012 <=Int A0012) then mi(8, A0012) else mi(8, B0012))))
				else undefMInt32)
			"RESULT" |-> (mi(32, 0) => concatenateMInt(ifMInt (B0015 <=Int A0015) then (mi(8, A0015)) else mi(8, B0015) ,concatenateMInt(ifMInt (B0014 <=Int A0014) then (mi(8, A0014)) else mi(8, B0014) ,concatenateMInt(ifMInt (B0013 <=Int A0013) then (mi(8, A0013)) else mi(8, B0013) , ifMInt (B0012 <=Int A0012) then mi(8, A0012) else mi(8, B0012))))
				)
			"Q0" |-> (concatenateMInt(mi(8, B0015), concatenateMInt(mi(8, B0014), concatenateMInt(mi(8, B0013), concatenateMInt(mi(8, B0012), concatenateMInt(mi(8, B0011), concatenateMInt(mi(8, B0010), concatenateMInt(mi(8, B009), concatenateMInt(mi(8, B008), concatenateMInt(mi(8, B007), concatenateMInt(mi(8, B006), concatenateMInt(mi(8, B005), concatenateMInt(mi(8, B004), concatenateMInt(mi(8, B003), concatenateMInt(mi(8, B002), concatenateMInt(mi(8, B001), mi(8, B000)))))))))))))))) => concatenateMInt(concatenateMInt(ifMInt (B0015 <=Int A0015) then (mi(8, A0015)) else mi(8, B0015) ,concatenateMInt(ifMInt (B0014 <=Int A0014) then (mi(8, A0014)) else mi(8, B0014) ,concatenateMInt(ifMInt (B0013 <=Int A0013) then (mi(8, A0013)) else mi(8, B0013) , ifMInt (B0012 <=Int A0012) then mi(8, A0012) else mi(8, B0012))))
				,
				concatenateMInt(concatenateMInt(ifMInt (B0011 <=Int A0011) then (mi(8, A0011)) else mi(8, B0011) ,concatenateMInt(ifMInt (B0010 <=Int A0010) then (mi(8, A0010)) else mi(8, B0010) ,concatenateMInt(ifMInt (B009 <=Int A009) then (mi(8, A009)) else mi(8, B009) , ifMInt (B008 <=Int A008) then mi(8, A008) else mi(8, B008))))
				,
				concatenateMInt(concatenateMInt(ifMInt (B007 <=Int A007) then (mi(8, A007)) else mi(8, B007) ,concatenateMInt(ifMInt (B006 <=Int A006) then (mi(8, A006)) else mi(8, B006) ,concatenateMInt(ifMInt (B005 <=Int A005) then (mi(8, A005)) else mi(8, B005) , ifMInt (B004 <=Int A004) then mi(8, A004) else mi(8, B004))))
				,
				concatenateMInt(ifMInt (B003 <=Int A003) then (mi(8, A003)) else mi(8, B003) ,concatenateMInt(ifMInt (B002 <=Int A002) then (mi(8, A002)) else mi(8, B002) ,concatenateMInt(ifMInt (B001 <=Int A001) then (mi(8, A001)) else mi(8, B001) , ifMInt (B000 <=Int A000) then mi(8, A000) else mi(8, B000))))
				))))
			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires A000 >=Int -8 andBool A000 <=Int 63
			andBool A001 >=Int -5 andBool A001 <=Int 20
			andBool A002 >=Int 6 andBool A002 <=Int 24
			andBool A003 >=Int -4 andBool A003 <=Int -1
			andBool A004 >=Int -72 andBool A004 <=Int 50
			andBool A005 >=Int -1 andBool A005 <=Int 62
			andBool A006 >=Int -2 andBool A006 <=Int 9
			andBool A007 >=Int -22 andBool A007 <=Int 5
			andBool A008 >=Int 1 andBool A008 <=Int 31
			andBool A009 >=Int -32 andBool A009 <=Int 23
			andBool A0010 >=Int 3 andBool A0010 <=Int 55
			andBool A0011 >=Int 2 andBool A0011 <=Int 89
			andBool A0012 >=Int -13 andBool A0012 <=Int 88
			andBool A0013 >=Int -15 andBool A0013 <=Int 55
			andBool A0014 >=Int 2 andBool A0014 <=Int 112
			andBool A0015 >=Int 12 andBool A0015 <=Int 111
			andBool B000 >=Int -64 andBool B000 <=Int 7
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

endmodule
