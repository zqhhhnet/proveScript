require "armv8-semantics.k"
module SPEC-VMAXNMV-MODE
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
			memloc(mi(32, 0)) |-> storedInstr( cmp . F16 r0, q0, # 0, # 1, .Operands)
			)
		</instructiontext>
		<regstate>
			"Q0" |-> concatenateMInt(mi(16, B07), concatenateMInt(mi(16, B06), concatenateMInt(mi(16, B05), concatenateMInt(mi(16, B04), concatenateMInt(mi(16, B03), concatenateMInt(mi(16, B02), concatenateMInt(mi(16, B01), mi(16, B00))))))))
			"S0" |-> concatenateMInt(mi(16, B01), mi(16, B00))
			"S1" |-> concatenateMInt(mi(16, B03), mi(16, B02))
			"S2" |-> concatenateMInt(mi(16, B05), mi(16, B04))
			"S3" |-> concatenateMInt(mi(16, B07), mi(16, B06))
		    "FPSCR" |-> (mi(32, 50331648) => ifMInt ((uvalueMInt(extractMInt(mi(32, A), 17, 22)) ==Int 31 
											andBool ((neMInt(extractMInt(mi(32, A), 22, 32), mi(10, 0))) andBool eqMInt(extractMInt(mi(32, A), 22, 23), mi(1,0)))) 
											orBool
											(uvalueMInt(extractMInt(mi(16, B01), 1, 6)) ==Int 31
											andBool ((neMInt(extractMInt(mi(16, B01), 6, 16), mi(10, 0))) andBool eqMInt(extractMInt(mi(16, B01), 6, 7), mi(1,0))))) then 
							mi(32, 50331649)
						else (mi(32, 50331648)))
			"R0" |-> (mi(32, A) => mi ( 32 , uvalueMInt (
				 	ifMInt /* S S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 ) andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 0) ) ) ) then 
				 		mi(16,32256) 
					else ifMInt /* S Q or Q S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 1) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 andBool ( neMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 1) ) ) ) then
						mi(16,32256) 
					else ifMInt /* Q Q */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 1) ) andBool ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 1) ) ) then 
						mi(16,32256) 
					else ifMInt /* S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 ) andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 0) ) ) then 
						mi(16 , B01) 
					else ifMInt /* S */ ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 ) andBool ( neMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) , mi(10, 0) ) andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 0) ) ) then 
						extractMInt ( mi ( 32 , A ) , 16 , 32 ) 
					else ifMInt /* Q */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 23 ) , mi(1, 1) ) then 
						mi(16 , B01) 
					else ifMInt /* Q */ ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 7 ) , mi(1, 1) ) then 
						extractMInt ( mi ( 32 , A ) , 16 , 32 ) 
					else ifMInt /* infinite */ ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) , mi(10, 0) ) then 
						ifMInt eqMInt ( extractMInt ( mi ( 16 , B01 ) , 0 , 1 ) , mi(1, 0) ) then mi ( 16 , B01 ) else extractMInt ( mi ( 32 , A ) , 16 , 32 ) 
					else ifMInt /* infinite */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 31 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) , mi(10, 0) ) then 
						ifMInt eqMInt ( extractMInt ( mi ( 32 , A ) , 16 , 17 ) , mi(1, 0) ) then extractMInt ( mi ( 32 , A ) , 16 , 32 ) else mi ( 16 , B01 ) 
					else ifMInt /* zero */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) ==K 0 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) , mi(10, 0) ) andBool ( uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) ==K 0 andBool eqMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) , mi(10, 0) ) ) then 
						ifMInt eqMInt ( extractMInt ( mi ( 16 , B01 ) , 0 , 1 ) , mi(1, 0) ) then mi ( 16 , B01 ) else extractMInt ( mi ( 32 , A ) , 16 , 32 ) 
					else ifMInt /* Normal */ MIntToFloatImpl ( 11 , 5 , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 16 , 17 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 17 , 22 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 22 , 32 ) ) ) <=Float MIntToFloatImpl ( 11 , 5 , uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 1 , 6 ) ) , uvalueMInt ( extractMInt ( mi ( 16 , B01 ) , 6 , 16 ) ) ) then 
						mi ( 16 , B01 ) 
					else extractMInt ( mi ( 32 , A ) , 16 , 32 ) ) ))

			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires B00 >=Int 1024 andBool B00 <=Int 31808
			andBool B01 >=Int 1807 andBool B01 <=Int 31808
			andBool B02 >=Int 26 andBool B02 <=Int 27
			andBool B03 >=Int 24 andBool B03 <=Int 182
			andBool B04 >=Int 12 andBool B04 <=Int 56
			andBool B05 >=Int 11 andBool B05 <=Int 55
			andBool B06 >=Int 32 andBool B06 <=Int 165
			andBool B07 >=Int 2 andBool B07 <=Int 59
			andBool A >=Int 1745 andBool A <=Int 31746
endmodule
