

	DataType ::= U8 | U16 | U32 | S8 | ... | F16 | F32 | F64
	Q128 ::= Q0 | Q1 | ... | Q7		R32 ::= R0 | R1 | ... | R15
	S32 ::= S0 | S1 | ... | S31		D64 ::= D0 | D1 | ... | D15
	SPReg ::= FPSCR | ...
	Reg ::= Q128 | R32 | S32 | D64
	Operand ::= Reg
	Inst ::= vmax.DataType Q128, Q128, Q128 	| vmaxa.DataType Q128, Q128
	       | vmaxnm.DataType S32, S32, S32 	| vmaxnm.DataType D64, D64, D64
	       | vmaxnm.DataType Q128, Q128, Q128 	| vmaxnma.DataType Q128, Q128
	       | vmaxnmv.DataType R32, Q128 		| vmaxnmav.DataType R32, Q128
	       | vmaxv.DataType  R32, Q128		| vmaxav.DataType R32, Q128
	       | vmin.DataType Q128, Q128, Q128	| vmina.DataType Q128, Q128
	       | vminnm.DataType S32, S32, S32	| vminnm.DataType D64, D64, D64
	       | vminnm.DataType Q128, Q128, Q128	| vminnma.DataType Q128, Q128
	       | vminnmv.DataType R32, Q128		| vminnmav.DataType R32, Q128
	       | vminv.DataType R32, Q128		| vminav.DataType R32, Q128
	Prog ::= Inst | Inst Prog
