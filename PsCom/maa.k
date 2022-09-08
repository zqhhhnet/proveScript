require "armv8-configuration.k"

module MAA

    imports ARMV8-CONFIGURATION

    /*@
        for inner production, multiplication and add.
        I point to the index of element in vector register.
        first multiply two elements and then compute the sum of prod and val in Rd.
    */
    
    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => . 
       ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, svalueMInt(getParentValue(Rd, RSMap)) +Int ( svalueMInt(getVecParentValue(Qn, I, RSMap)) *Int svalueMInt(getVecParentValue(Qm, I, RSMap)))), 32, 64)
         
        ) </regstate>
            requires S ==K S32 andBool I >=Int 0 andBool I <=Int 3

    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => .
        ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, uvalueMInt(getParentValue(Rd, RSMap)) +Int ( uvalueMInt(getVecParentValue(Qn, I, RSMap)) *Int uvalueMInt(getVecParentValue(Qm, I, RSMap)))), 32, 64)

        )
        </regstate>
            requires S ==K U32 andBool I >=Int 0 andBool I <=Int 3
    
    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => .
        ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, svalueMInt(extractMInt(getParentValue(Rd, RSMap), 16, 32)) +Int ( svalueMInt(extractMInt(getVecParentValue(Qn, I /Int 2, RSMap), 16 *Int (1 -Int (I %Int 2)), 16 *Int (2 -Int (I %Int 2)))) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I /Int 2, RSMap), 16 *Int (1 -Int (I %Int 2)), 16 *Int (2 -Int (I %Int 2)))))), 32, 64)

        )
        </regstate>
            requires S ==K S16 andBool I >=Int 0 andBool I <=Int 7

    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => .
        ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 16, 32)) +Int ( uvalueMInt(extractMInt(getVecParentValue(Qn, I /Int 2, RSMap), 16 *Int (1 -Int (I %Int 2)), 16 *Int (2 -Int (I %Int 2)))) *Int uvalueMInt(extractMInt(getVecParentValue(Qm, I /Int 2, RSMap), 16 *Int (1 -Int (I %Int 2)), 16 *Int (2 -Int (I %Int 2)))))), 32, 64)

        )
        </regstate>
            requires S ==K U16 andBool I >=Int 0 andBool I <=Int 7

    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => .
        ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, svalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) +Int ( svalueMInt(extractMInt(getVecParentValue(Qn, I /Int 4, RSMap), 8 *Int (3 -Int (I %Int 4)), 8 *Int (4 -Int (I %Int 4)))) *Int svalueMInt(extractMInt(getVecParentValue(Qm, I /Int 4, RSMap), 8 *Int (3 -Int (I %Int 4)), 8 *Int (4 -Int (I %Int 4)))))), 32, 64)

        )
        </regstate>
            requires S ==K S8 andBool I >=Int 0 andBool I <=Int 15

    rule <k> execinstr(maa:StepCommand . S:Label Rd:R32, Qn:Q128, Qm:Q128, (# I:Int):Imm, .Operands) => .
        ...</k>
        <regstate> RSMap:Map => updateMap(RSMap,
            convToRegKeys(Rd) |-> extractMInt(mi(64, uvalueMInt(extractMInt(getParentValue(Rd, RSMap), 24, 32)) +Int ( uvalueMInt(extractMInt(getVecParentValue(Qn, I /Int 4, RSMap), 8 *Int (3 -Int (I %Int 4)), 8 *Int (4 -Int (I %Int 4)))) *Int uvalueMInt(extractMInt(getVecParentValue(Qm, I /Int 4, RSMap), 8 *Int (3 -Int (I %Int 4)), 8 *Int (4 -Int (I %Int 4)))))), 32, 64)

        )
        </regstate>
            requires S ==K U8 andBool I >=Int 0 andBool I <=Int 15

endmodule