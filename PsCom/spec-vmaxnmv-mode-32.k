require "armv8-semantics.k"
module SPEC-VMAXNMV-MODE-32
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
			"Q0" |-> concatenateMInt(mi(32, B3), concatenateMInt(mi(32, B2), concatenateMInt(mi(32, B1), mi(32, B0))))
			"S0" |-> mi(32, B0)
			"S1" |-> mi(32, B1)
			"S2" |-> mi(32, B2)
			"S3" |-> mi(32, B3)
		    "FPSCR" |-> (mi(32, 50331648) => mi(32, ?Y))/*ifMInt (((uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 255 
							    andBool ((neMInt(extractMInt(mi(32, A), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(mi(32, A), 9, 10), mi(1,0))))
							        orBool
							    (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 255
							    andBool ((neMInt(extractMInt(mi(32, B1), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(mi(32, B1), 9, 10), mi(1,0)))))
                                andBool
                                ((uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 0 andBool neMInt(extractMInt(mi(32, A), 9, 32), mi(23, 0)))
                                    orBool
                                (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 0 andBool neMInt(extractMInt(mi(32, B1), 9, 32), mi(23, 0))))) then
                            mi(32, 50331777)
                        else ifMInt ((uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 255 
								andBool ((neMInt(extractMInt(mi(32, A), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(mi(32, A), 9, 10), mi(1,0)))) 
								orBool
								(uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 255
							    andBool ((neMInt(extractMInt(mi(32, B1), 9, 32), mi(23, 0))) andBool eqMInt(extractMInt(mi(32, B1), 9, 10), mi(1,0))))) then 
							mi(32, 50331649)
                        else ifMInt ((uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 0 andBool neMInt(extractMInt(mi(32, A), 9, 32), mi(23, 0)))
                                orBool
                                (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 0 andBool neMInt(extractMInt(mi(32, B1), 9, 32), mi(23, 0)))) then
                            mi(32, 50331776) 
						else (mi(32, 50331648)))*/

			"R0" |-> (mi(32, A) =>
				 	ifMInt /* S S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 ) andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 andBool ( neMInt ( extractMInt ( mi(32, B1) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 0) ) ) ) then 
				 		mi(32,2143289344) 
					else ifMInt /* S Q or Q S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 1) ) ) ) orBool ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 andBool ( neMInt ( extractMInt ( mi(32, B1) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 0) ) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 1) ) ) ) then
						mi(32,2143289344) 
					else ifMInt /* Q Q */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 1) ) andBool ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 1) ) ) then 
						mi(32,2143289344) 
					else ifMInt /* S */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 ) andBool ( neMInt ( extractMInt ( mi ( 32 , A ) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 0) ) ) then 
						//mi(32, B1) 
                        (ifMInt (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 0) then 
                            (ifMInt (eqMInt(extractMInt(mi(32, B1), 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(mi(32, A), 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
                        else (mi(32, B1)))
					else ifMInt /* S */ ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 ) andBool ( neMInt ( extractMInt ( mi(32, B1) , 9 , 32 ) , mi(23, 0) ) andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 0) ) ) then 
						//mi(32, A) 
                        (ifMInt (uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 0) then 
                            (ifMInt (eqMInt(extractMInt(mi(32, A), 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(mi(32, B1), 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
                        else (mi(32, A)))
					else ifMInt /* Q */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 10 ) , mi(1, 1) ) then 
						//mi(32, B1) 
                        (ifMInt (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 0) then 
                            (ifMInt (eqMInt(extractMInt(mi(32, B1), 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(mi(32, A), 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
                        else (mi(32, B1)))
					else ifMInt /* Q */ ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 ) andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 10 ) , mi(1, 1) ) then 
						//mi(32, A) 
                        (ifMInt (uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 0) then 
                            (ifMInt (eqMInt(extractMInt(mi(32, A), 0, 1), mi(1, 0))) then (concatenateMInt(extractMInt(mi(32, B1), 0, 1), mi(31, 0))) else concatenateMInt(mi(1,1), mi(31, 0))) 
                        else (mi(32, A)))
					else ifMInt /* infinite */ ( uvalueMInt ( extractMInt ( mi ( 32 , B1 ) , 1 , 9 ) ) ==K 255 ) andBool eqMInt ( extractMInt ( mi(32, B1) , 9 , 32 ) , mi(23, 0) ) then 
						ifMInt eqMInt ( extractMInt ( mi(32, B1) , 0 , 1 ) , mi(1, 0) ) then mi(32, B1) else mi(32, A) 
					else ifMInt /* infinite */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 255 ) andBool eqMInt ( extractMInt ( mi ( 32 , A ) , 9 , 32 ) , mi(23, 0) ) then 
						ifMInt eqMInt ( extractMInt ( mi ( 32 , A ) , 0 , 1 ) , mi(1, 0) ) then mi(32, A) else mi(32, B1) 
					else ifMInt /* zero zero */ ( uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) ==K 0 ) andBool ( uvalueMInt ( extractMInt ( mi(32, B1) , 1 , 9 ) ) ==K 0 ) then 
						ifMInt eqMInt ( extractMInt ( mi(32, B1) , 0 , 1 ) , mi(1, 1) ) then concatenateMInt(extractMInt(mi(32, A), 0, 1), mi(31, 0)) else mi(32, 0)
                    else ifMInt /* zero and - */ (uvalueMInt(extractMInt(mi(32, A), 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(mi(32, B1), 0, 1), mi(1, 1))) then
                        concatenateMInt(extractMInt(mi(32, A), 0, 1), mi(31, 0))
                    else ifMInt /* zero and - */ (uvalueMInt(extractMInt(mi(32, B1), 1, 9)) ==Int 0) andBool (eqMInt(extractMInt(mi(32, A), 0, 1), mi(1, 1))) then
                        concatenateMInt(extractMInt(mi(32,B1), 0, 1), mi(31, 0))
					else ifMInt /* Normal */ MIntToFloatImpl ( 24 , 8 , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 1 , 9 ) ) , uvalueMInt ( extractMInt ( mi ( 32 , A ) , 9 , 32 ) ) ) <=Float MIntToFloatImpl ( 24 , 8 , uvalueMInt ( extractMInt ( mi(32, B1) , 0 , 1 ) ) , uvalueMInt ( extractMInt ( mi(32, B1) , 1 , 9 ) ) , uvalueMInt ( extractMInt ( mi(32, B1) , 9 , 32 ) ) ) then 
						mi(32, B1) 
					else mi(32, A)  )

			"R15" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))
		</regstate>
			requires B0 >=Int 0 andBool B0 <=Int 213
			andBool B1 >=Int 8388609 andBool B1 <=Int 8388609
			andBool B2 >=Int 26 andBool B2 <=Int 27
			andBool B3 >=Int 24 andBool B3 <=Int 1823
			andBool A >=Int 8388608 andBool A <=Int 8388609 
			//andBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 5, 6), mi(1,0))
            
            ensures ?Y ==Int 50331648

                //andBool eqMInt(extractMInt(getReg("FPSCR", RSMap), 24, 25), mi(1,0))
endmodule
