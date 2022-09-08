require "armv8-conversions.k"

module ARMV8-MINT-SORTS
  syntax MInts
  syntax Floats
  syntax Ints
endmodule

module ARMV8-MINT-SYNTAX
  imports ARMV8-MINT-SORTS
  imports MINT
  imports INT
  imports INT
  imports FLOAT
  imports MAP
  imports STRING
  imports ARMV8-CONVERSIONS
  
  syntax MInt ::= "undefMInt"
  syntax MInt ::= "undefMInt8"
  syntax MInt ::= "undefMInt16"
  syntax MInt ::= "undefMInt32"
  syntax MInt ::= "undefMInt64"
  syntax Bool ::= "undefBool"
  syntax MInt ::= "zeroMIntW1"
  syntax MInt ::= "zeroMIntW64"
  syntax MInt ::= "zeroMIntW256"
  syntax MInt ::= "oneMIntW1"
  syntax MInt ::= "oneMIntW64"
  syntax MInt ::= "divideError"
  
  syntax Bool ::= IsUndef(MInt) [function]
  
  syntax MInts ::= List{MInt, ""} [klabel(mintlist)]
  syntax Floats ::= List{Float, ""} [klabel(floatlist)]
  syntax Ints ::= List{Int, ""} [klabel(intlist)]
  
  syntax MInt ::= "ifMInt" Bool "then" MInt "else" MInt [function, smtlib(ite)]
  syntax Bool ::= "ifBool" Bool "then" Bool "else" Bool [function, smtlib(ite)]
  syntax Int ::= "ifInt" Bool "then" Int "else" Int [function, smtlib(ite)]
  syntax MInts ::= "ifMInts" Bool "then" MInts "else" MInts [function, smtlib(ite)]
  
  // Convert MInts to Signed Ints
  syntax Ints ::= convertMIntsToSInts(MInts) [function]
  
  // Convert MInts to Floats
  syntax Floats ::= convertMIntsToFps(MInts, Int, Int) [function]
  
  // Convert Ints to Floats
  syntax Floats ::= convertIntsToFps(Ints, Int, Int) [function]
  
  // Convert Floats to Ints
  syntax Ints ::= convertFpsToInts(Floats) [function]
  
  // Covert Floats to MInts.
  syntax MInts ::= convertFpsToMInts(Floats, Int) [function]
  
  // Covert Ints to MInts.
  syntax MInts ::= convertIntsToMInts(Ints, Int) [function]
  
  // Covert Single Precision Float to Double preceson Float.
  syntax Floats ::= convertFloatsToDoubles(Floats) [function]
  
  // Bitwise negation
  syntax MInt ::= negateMInt(MInt)   [function]

  // Adding MInt List.
  syntax MInt ::= addListMInt(Int, MInts) [function]

  // Conversion from/to MInt and Bool
  syntax Bool ::= toBool(MInt) [function]
  syntax MInt ::= fromBoolToMInt(Bool, Int) [function]
  
  /*@ extractMask(MI, W, S) Extracts the lower W bits
    from MInt starting from lower significant bit position S.

    Ex: extractMask(MI, 16, 8):
        MI:64' 0x 00 ff 00 ff 00 ff 00 ff
        Output:                  <--->
          MI:16' 0x                 ff 00
    Todo :check for MI wodth < W
  */
  syntax MInt ::= extractMask(MInt, Int, Int) [function]
  
  /*@ truncate(MI, To) Truncates a mi(From,V1) to mi(To,V2)
    Todo : type check
  */
  syntax MInt ::= truncate(MInt, Int) [function]

  /*@
    zeroExtend(MI, N): Zero extend MInt MI to a MInt of
      N bitwidth.
  */
  syntax MInt ::= zeroExtend(MInt, Int) [function]
  
  /*@
    plugInMask(MITarget, MISrc, S):
      Let MITarget == mi(WT, VT)
      Let MISrc == mi(WS, VS)
      plugInMask updates the lower WS bits of VT starting at
      lower significant bit position S with VS.

      Ex: plugInMask(MIT,MIS, 8):
        MIT:64' 0x 00 ff 00 ff 00 ff 00 ff
        MIS:16' 0x                   55 44
        Output:
            64' 0x 00 ff 00 ff 00 55 44 ff
  */
  syntax MInt ::= plugInMask(MInt, MInt, Int) [function]
  
  /*@
    signExtend(MI, N): Sign extend MInt MI to a MInt of
      N bitwidth.
  */
  syntax MInt ::= signExtend(MInt, Int) [function]
  
  /*@
    popCount(MI, N): Count the number of set bits, V, in MI and
    create a MInt(N, V)
  */
  syntax Int ::= popCount(MInt) [function]
  syntax Int ::= countOnes(MInt, Int) [function]

  /*@
    getSignBit(MI): return mi(1, signBit of MI)
  */
  syntax MInt ::= getSignBit(MInt) [function]
  
endmodule

module ARMV8-MINT
  imports ARMV8-MINT-SYNTAX
  
  rule zeroMIntW1   =>  mi(1,  0) [macro]
  rule zeroMIntW64  =>  mi(64, 0) [macro]
  rule zeroMIntW256 =>  mi(256,0) [macro]
  rule oneMIntW1    =>  mi(1,  1) [macro]
  rule oneMIntW64   =>  mi(64, 1) [macro]


  /*@
    The bitwodth of undef is defined as 8 bits.
    Used while allocating the undef stack memory,
  */
  rule bitwidthMInt(undefMInt8) =>  8 [lemma]
  rule bitwidthMInt(undefMInt16) => 16 [lemma]
  rule bitwidthMInt(undefMInt32) => 32 [lemma]
  rule bitwidthMInt(undefMInt64) => 64 [lemma]
  
  /*@
    Get Ascii value of a char.
  */
  syntax Int ::= charAt(String, Int) [function]
  rule charAt(S:String, I:Int) => ordChar(substrString(S, I, I +Int 1))
  
  /*@
    If Else Then for Sorts
  */
  rule ifMInt B then M else _ => M requires B
  rule ifMInt B then _ else M => M requires notBool B
  rule ifInt B then M else _ => M requires B
  rule ifInt B then _ else M => M requires notBool B
  rule ifBool B then M else _ => M requires B
  rule ifBool B then _ else M => M requires notBool B
  rule ifMInts B then M else _ => M requires B
  rule ifMInts B then _ else M => M requires notBool B
  
  /*@
    Convert MInts to Signed Ints.
  */
  rule convertMIntsToSInts(MI MIs) => svalueMInt(MI) convertMIntsToSInts(MIs)
  rule convertMIntsToSInts(.MInts) => .Ints
  
  /*@
    Covert MInts to Floats(or BigFloats).
  */
  rule convertMIntsToFps(MI MIs, P, E) => MInt2Float(MI, P, E) convertMIntsToFps(MIs, P, E)
  rule convertMIntsToFps(.MInts, _, _) => .Floats

  /*@
    Covert Ints to Floats(or BigFloats).
  */
  rule convertIntsToFps(I Is, P, E) => Int2Float(I, P, E) convertIntsToFps(Is, P, E)
  rule convertIntsToFps(.Ints, _, _) => .Floats

  /*@
    Covert Floats to Ints.
  */
  rule convertFpsToInts(F Fs) => Float2Int(F) convertFpsToInts(Fs)
  rule convertFpsToInts(.Floats) => .Ints
  
  /*@
    Covert Floats to MInts.
  */
  rule convertFpsToMInts(F Fs, W) => Float2MInt(F, W) convertFpsToMInts(Fs, W)
  rule convertFpsToMInts(.Floats, _) => .MInts
  
  /*@
    Covert Ints to MInts.
  */
  rule convertIntsToMInts(I Is, W) => mi(I, W) convertIntsToMInts(Is, W)
  rule convertIntsToMInts(.Ints, _) => .MInts

  /*@
    Covert Single Precision Float to Double preceson Float.
  */
  rule convertFloatsToDoubles(F Fs) => Float2Double(F) convertFloatsToDoubles(Fs)
  rule convertFloatsToDoubles(.Floats) => .Floats
  
  /*@
    Bitwise negation
  */
  rule negateMInt(MI) => xorMInt(MI, mi(bitwidthMInt(MI), -1))

  /*@
    Adding MInt List.
  */
  rule addListMInt(W:Int, MI1:MInt MI2:MInt Rest:MInts) =>
    addMInt(addMInt(MI1, MI2), addListMInt(W, Rest))
  rule addListMInt(W:Int, MI:MInt .MInts) => MI
  rule addListMInt(W:Int, .MInts) => mi(W,0)
  
  /*@
    Conversion from/to MInt and Bool
  */
  rule toBool(MI) => ifBool uvalueMInt(MI) =/=Int 0 then true
                     else false
                     
  rule fromBoolToMInt(B:Bool, W:Int) => ifMInt B then mi(W,1)
                                        else mi(W,0)
  
  /*@ extractMask(MI, W, S) Extracts the lower W bits
    from MInt starting from lower significant bit position S.

    Ex: extractMask(MI, 16, 8):
        MI:64' 0x 00 ff 00 ff 00 ff 00 ff
        Output:                  <--->
          MI:16' 0x                 ff 00

    extractMask(MI, 4, 1)
      6 5 4 3 2 1 0
      * * * * * * *
          ------^

    extractMask(MI, NUM, P) <==> extractMInt(MI, S , S + NUM)
      where S = bitwidthMInt(MI) - (P + NUM)

    Example, extractMInt(MI, 2, 6) // Bits in range [2..6)

      0 1 2 3 4 5 6
      * * * * * * *
          ^-------^
  */
  rule extractMask(MI, NUM, P) => extractMInt(MI, bitwidthMInt(MI) -Int P -Int NUM,
      bitwidthMInt(MI) -Int P)
    requires (P +Int NUM) <=Int bitwidthMInt(MI)
    
  /*@ truncate(MI, To) Truncates a mi(From,V1) to mi(To,V2)
    Todo : type check
  */

  rule truncate(MI, To) =>
    mi(To, svalueMInt(andMInt(MI, mi(bitwidthMInt(MI),umaxMInt(To)))))
  
  /*@
    zeroExtend(MI, N): Zero extend MInt MI to a MInt of
      N bitwidth.
  rule zeroExtend(MI:MInt, N:Int) => mi(N, uvalueMInt(MI))
    requires N >=Int bitwidthMInt(MI)
  */
  rule zeroExtend(MI:MInt, N:Int) => MI
    requires N ==Int bitwidthMInt(MI)

  rule zeroExtend(MI:MInt, N:Int) => concatenateMInt(mi(N -Int bitwidthMInt(MI), 0), MI)
    requires N >Int bitwidthMInt(MI)
  
  /*@
    plugInMask(MITarget, MISrc, P):
      Let MITarget == mi(WT, VT)
      Let MISrc == mi(WS, VS)
      plugInMask updates the lower WS bits of VT starting at
      lower significant bit position P with VS.

      Ex: plugInMask(MIT,MIS, 8):
        MIT:64' 0x 00 ff 00 ff 00 ff 00 ff
        MIS:16' 0x                   55 44
        Output:
            64' 0x 00 ff 00 ff 00 55 44 ff
  */
  rule plugInMask(MITarget, MISrc, P) => MISrc
    requires (P ==Int 0) andBool (bitwidthMInt(MISrc) ==Int bitwidthMInt(MITarget))
  
  rule plugInMask(MITarget, MISrc, P) => concatenateMInt(
          extractMInt(MITarget, 0 , (bitwidthMInt(MITarget) -Int bitwidthMInt(MISrc))),
          MISrc
          )
      requires (P ==Int 0) andBool (bitwidthMInt(MISrc) <Int bitwidthMInt(MITarget))
  
  rule plugInMask(MITarget, MISrc, P) => concatenateMInt(MISrc, extractMInt(MITarget, bitwidthMInt(MISrc), bitwidthMInt(MITarget)))
      requires (P =/=Int 0) andBool ((P +Int bitwidthMInt(MISrc)) ==Int bitwidthMInt(MITarget))


    rule plugInMask(MITarget, MISrc, P) => concatenateMInt(
          extractMInt(MITarget, 0 , (bitwidthMInt(MITarget) -Int bitwidthMInt(MISrc) -Int P)),
          concatenateMInt(
            MISrc,
            extractMInt(MITarget, (bitwidthMInt(MITarget) -Int P), bitwidthMInt(MITarget))
            )
        )
      requires (P =/=Int 0) andBool ((P +Int bitwidthMInt(MISrc)) <Int bitwidthMInt(MITarget))
  
  /*@
    signExtend(MI, N): Sign extend MInt MI to a MInt of
      N bitwidth.
  */
  rule signExtend(MI:MInt, N:Int) => MI
    requires N ==Int bitwidthMInt(MI)

  rule signExtend(MI:MInt, N:Int) => mi(N, svalueMInt(MI))
    requires N >Int bitwidthMInt(MI)

  /*@
    popCount(MI, N): Count the number of set bits, V, in MI and
    create a MINt(N, V)
  */
  rule popCount(MI:MInt) => countOnes(MI, 0)

  rule countOnes(MI:MInt, C:Int) =>
    countOnes(andMInt(MI, subMInt(MI, mi(bitwidthMInt(MI),1))), C +Int 1)
      requires notBool zeroMInt(MI)

  rule countOnes(MI:MInt, C:Int) =>  C
      requires zeroMInt(MI)

  /*@
    getSignBit(MI): return mi(1, signBit of MI)
  rule getSignBit(MI:MInt) =>
    fromBoolToMInt( toBool(
        andMInt(MI,
            mi(bitwidthMInt(MI), sminMInt(bitwidthMInt(MI)))
        )
      ), 1)
  */
  rule getSignBit(MI:MInt) => extractMInt(MI, 0, 1)
  
  rule IsUndef(MI) => true requires   MI ==K undefMInt16
  				orBool MI ==K undefMInt32
  				orBool MI ==K undefMInt8
  				orBool MI ==K undefMInt64
  rule IsUndef(MI) => false requires notBool (MI ==K undefMInt16
  				andBool MI ==K undefMInt32
  				andBool MI ==K undefMInt8
  				andBool MI ==K undefMInt64)
endmodule
