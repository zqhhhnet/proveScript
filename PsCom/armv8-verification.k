require "armv8-mint.k"

module MINT-LEMMAS
  imports MINT
  imports ARMV8-MINT-SYNTAX
  imports K-REFLECTION-SYMBOLIC

  // bitwidthMInt    
  // Recursive rules
  rule bitwidthMInt(addMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(subMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(xorMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(orMInt(MIC,   _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(andMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  // rule bitwidthMInt(mulMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(lshrMInt(MIC, _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(ashrMInt(MIC, _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(shlMInt(MIC,  _)) => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(negMInt(MIC))     => bitwidthMInt(MIC) [lemma]
  rule bitwidthMInt(concatenateMInt(MI1:MInt, MI2:MInt)) => bitwidthMInt(MI1) +Int bitwidthMInt(MI2) [lemma]
  rule bitwidthMInt(ifMInt B:Bool then MI1 else MI2) => bitwidthMInt(MI1) [lemma]
  rule bitwidthMInt(Float2MInt(_:Float, W:Int)) => W [lemma]
  
  // Base Rules
  rule bitwidthMInt(mi(W:Int, _)) => W [lemma]
  rule bitwidthMInt(extractMask(_, W:Int, _)) => W [lemma]
  rule bitwidthMInt(extractMInt(_, S:Int, E:Int)) => E -Int S [lemma]
  rule bitwidthMInt(zeroExtend(_:MInt, W:Int)) => W [lemma]
  rule bitwidthMInt(signExtend(_:MInt, W:Int)) => W [lemma]
  
  // xorMInt
  rule xorMInt(MI:MInt, MI:MInt) => mi(bitwidthMInt(MI), 0) [lemma]
  
  // orMInt
  rule orMInt(MI:MInt, MI:MInt) =>  MI [lemma]

  rule orMInt(ZMI:MInt, MI:MInt) =>  MI 
    requires zeroMInt(ZMI)
  rule orMInt(MI, ZMI:MInt) =>  MI 
    requires zeroMInt(ZMI)

  rule orMInt(_:MInt, MI_ALL_ONES:MInt) => MI_ALL_ONES
    requires svalueMInt(MI_ALL_ONES) ==Int -1
  rule orMInt(MI_ALL_ONES:MInt, _:MInt) => MI_ALL_ONES
    requires svalueMInt(MI_ALL_ONES) ==Int -1

  // andMInt
  rule andMInt(MI:MInt, MI:MInt) =>  MI 

  rule andMInt(ZMI:MInt, MI:MInt) =>  ZMI
    requires zeroMInt(ZMI)
  rule andMInt(MI, ZMI:MInt) => ZMI
    requires zeroMInt(ZMI)

  rule andMInt(MI:MInt, MI_ALL_ONES:MInt) => MI
    requires svalueMInt(MI_ALL_ONES) ==Int -1
  rule andMInt(MI_ALL_ONES:MInt, MI:MInt) => MI
    requires svalueMInt(MI_ALL_ONES) ==Int -1
    
  // ultMInt
  rule ultMInt(_, MI) =>  false                         
    requires  eqMInt(MI, mi(bitwidthMInt(MI), 0))
  rule ultMInt(MI:MInt, MI:MInt) =>  false 
  
  // addMInt
  rule addMInt(MI:MInt, ZMI:MInt) => MI                   
    requires eqMInt(ZMI, mi(bitwidthMInt(ZMI), 0))

  rule addMInt(ZMI:MInt, MI:MInt) => MI                  
    requires eqMInt(ZMI, mi(bitwidthMInt(ZMI), 0))

  rule addMInt(MI:MInt, xorMInt(MI:MInt, MI_MINUS_ONE:MInt)) => MI_MINUS_ONE
    requires svalueMInt(MI_MINUS_ONE) ==Int -1
  rule addMInt(MI:MInt, xorMInt(MI_MINUS_ONE:MInt, MI:MInt)) => MI_MINUS_ONE
    requires svalueMInt(MI_MINUS_ONE) ==Int -1
    
  // subMInt
  rule subMInt(MI, MI) => mi(bitwidthMInt(MI), 0) [lemma]

  rule subMInt(MI:MInt, ZMI:MInt) => MI                   
    requires eqMInt(ZMI, mi(bitwidthMInt(ZMI), 0))
    
  // Float2MInt/MInt2Float
  rule Float2MInt(MInt2Float(MI:MInt, 53, 11), 64) => MI [lemma]
  rule MInt2Float(Float2MInt(F:Float, 64), 53, 11) => F [lemma]
  rule Float2MInt(MInt2Float(MI:MInt, 24, 8), 32)  => MI [lemma]
  rule MInt2Float(Float2MInt(F:Float, 32), 24, 8)  => F [lemma]
  
  // shlMInt / ashrMInt / lshrMInt
  rule shlMInt(MI:MInt, 0) => MI  [lemma]
  rule ashrMInt(MI:MInt, 0) => MI [lemma]
  rule lshrMInt(MI:MInt, 0) => MI [lemma]
  
  /* 
     Concatenation of consecutive extracts.
  */
  rule concatenateMInt(extractMInt(MI, S1, E1), extractMInt(MI, S2, E2)) => extractMInt(MI, S1, E2) 
    requires E1 ==Int S2

  /* 
     Concatenation of non-consecutive extracts.
  */
  rule concatenateMInt(extractMInt(MI1, S1, E1), concatenateMInt(extractMInt(MI1, S2, E2), MI2)) => concatenateMInt(extractMInt(MI1, S1, E2), MI2) 
    requires E1 ==Int S2

  /* 
     Extracting the whole bitvector
  */
  rule extractMInt(MI, S, E) => MI
    requires (bitwidthMInt(MI) ==Int E) andBool (S ==Int 0)

  /* 
     Extracting from a 0 bitvector returns a zero bitvector.
  */
  rule extractMInt(MI, S, E) => mi(E -Int S, 0)
    requires zeroMInt(MI)

  /*
     Distribute Extract over Concatenation
  */
  // Subpart is fully in the rhs of concat
  rule extractMInt(concatenateMInt(MI1, MI2), S, E) => extractMInt(MI2, S -Int bitwidthMInt(MI1), E -Int bitwidthMInt(MI1))
    requires S >=Int bitwidthMInt(MI1)
  
  // Subpart is fully in the lhs of concat
  rule extractMInt(concatenateMInt(MI1, MI2), S, E) => extractMInt(MI1, S , E)
    requires E <=Int bitwidthMInt(MI1) 

  // Subpart is an overlap of lhs and rhs.
  rule extractMInt(concatenateMInt(MI1, MI2), S, E) => concatenateMInt(extractMInt(MI1, S, bitwidthMInt(MI1)), extractMInt(MI2, 0, E -Int bitwidthMInt(MI1)))
    requires S <Int bitwidthMInt(MI1) andBool E >Int bitwidthMInt(MI1)
  
  /*@
     Merges two consecutive extracts.
  */
  rule extractMInt(extractMInt(MI, S1, E1), S2, E2) => extractMInt(MI, S1 +Int S2, S1 +Int E2)

  rule extractMInt(mi(W, svalueMInt(MI)), S, E) => extractMInt(MI, S -Int W +Int bitwidthMInt(MI), E -Int W +Int bitwidthMInt(MI))
    requires S >=Int W -Int bitwidthMInt(MI)

  /*@
     Extract over zeroExtend: 
     When the Etract overlaps with the signExtended MInt.
     When the Etract DOES NOT overlap with the signExtended MInt.
  */
  rule extractMInt(mi(W, uvalueMInt(MI)), S, E) => extractMInt(MI, S -Int W +Int bitwidthMInt(MI), E -Int W +Int bitwidthMInt(MI))
    requires S >=Int W -Int bitwidthMInt(MI)

  rule extractMInt(mi(W, uvalueMInt(MI)), S, E) => mi(E -Int S, 0)
    requires E <=Int W -Int bitwidthMInt(MI)

  rule extractMInt(mi(W, uvalueMInt(MI)), S, E) => 
      concatenateMInt(mi(W -Int bitwidthMInt(MI) -Int S, 0), extractMInt(MI, 0, E -Int W +Int bitwidthMInt(MI)))
    requires (S <Int W -Int bitwidthMInt(MI)) andBool (E >Int W -Int bitwidthMInt(MI))
  
  /*@
     Convert signExtension to zeroExtension
  */
  rule mi(W:Int, svalueMInt(concatenateMInt(MI1, MI2))) => zeroExtend(MI2, W)
    requires zeroMInt(MI1)
  
  /*@
     Concatenate zeroes
  */
  rule concatenateMInt(MI1, MI2) => mi(bitwidthMInt(MI1) +Int bitwidthMInt(MI2), 0) 
    requires zeroMInt(MI1) andBool zeroMInt(MI2)

  rule concatenateMInt(MI1, concatenateMInt(MI2, MI3)) => concatenateMInt(mi(bitwidthMInt(MI1) +Int bitwidthMInt(MI2), 0), MI3)
    requires zeroMInt(MI1) andBool zeroMInt(MI2)

  /*@
     Distribute Extract over Boolean operations
  */
  rule extractMInt(andMInt(MI1, MI2), S, E) =>  andMInt(extractMInt(MI1, S, E), extractMInt(MI2, S, E))
  rule extractMInt(orMInt( MI1, MI2), S, E) =>   orMInt(extractMInt(MI1, S, E), extractMInt(MI2, S, E))
  rule extractMInt(xorMInt(MI1, MI2), S, E) =>  xorMInt(extractMInt(MI1, S, E), extractMInt(MI2, S, E))

  /*@
     countOnes 
  */
  rule countOnes(concatenateMInt(MI1, MI2), I:Int) => countOnes(MI2, I)
    requires zeroMInt(MI1)
  rule countOnes(MI, I:Int) => uvalueMInt(MI)
    requires bitwidthMInt(MI) ==Int 1
  
  /*@
     Carry flag idioms
  */
  rule 
  addMInt(concatenateMInt(MIZ, MIF), MI_MINUS_ONE) 
    =>
  (ifMInt 
    eqMInt(MIF, mi(1, 1)) 
  then 
    mi(bitwidthMInt(MI_MINUS_ONE), 0)  
  else 
    MI_MINUS_ONE
  )
    requires  (bitwidthMInt(MIF) ==Int 1) andBool 
              zeroMInt(MIZ) andBool
              (svalueMInt(MI_MINUS_ONE) ==Int -1)
  
  /*@
    L0: Distributing extraction over addition
  */  
  rule extractMInt(
        addMInt( MI1:MInt, MI2:MInt), 
        S:Int, E:Int) 
  => addMInt(
      extractMInt(MI1, S, E), 
      extractMInt(MI2, S, E))
    requires  bitwidthMInt(MI1) ==Int bitwidthMInt(MI2)
    andBool   E <=Int bitwidthMInt(MI1)
    andBool   S <Int E andBool   S >=Int 0  
    andBool   E ==Int bitwidthMInt(MI1)

   rule extractMInt(
        addMInt( MI1:MInt, MI2:MInt), 
        S:Int, E:Int) 
  => addMInt(
      extractMInt(MI1, S, E), 
      extractMInt(MI2, S, E))
    requires  bitwidthMInt(MI1) ==Int bitwidthMInt(MI2)
    andBool   E <=Int bitwidthMInt(MI1)
    andBool   S <Int E andBool   S >=Int 0  
    andBool  E <Int  bitwidthMInt(MI1)
    andBool (
      eqMInt( extractMInt(MI1, E, bitwidthMInt(MI1)), mi(bitwidthMInt(MI1) -Int E, 0))
        orBool
      eqMInt( extractMInt(MI1, E, bitwidthMInt(MI1)), mi(bitwidthMInt(MI1) -Int E, 0))
      )

    rule 
      extractMInt(mi(M, A +Int B), S, E) => addMInt(extractMInt(mi(M, A), S, E), extractMInt(mi(M, B), S, E))
    requires  M ==Int E
    andBool   E >Int S andBool  S >=Int 0
    andBool   #isConcrete(A)
  
  /*@ 
    L1: addMInt semantics: Associativity
  */  
  rule addMInt(MI1, addMInt(MI2, MI3)) => addMInt(addMInt(MI1, MI2), MI3)
     requires  bitwidthMInt(MI1) ==Int bitwidthMInt(MI2) 
     andBool   bitwidthMInt(MI1) ==Int bitwidthMInt(MI3)

  /*@ 
    L3: addMInt: Semantics 
  */  
  /*
  rule addMInt(MI1:MInt, MI2:MInt) => 
    mi(bitwidthMInt(MI1), svalueMInt(MI1) +Int svalueMInt(MI2))
      requires (svalueMInt(MI1) +Int svalueMInt(MI2)) <Int        
                    ((2 ^Int bitwidthMInt(MI1)) -Int 1) 
       andBool (svalueMInt(MI1) +Int svalueMInt(MI2)) >=Int 
            -1 *Int ((2 ^Int bitwidthMInt(MI1)) -Int 1)
       andBool bitwidthMInt(MI1) ==Int bitwidthMInt(MI2) 
       */

  /*@ 
    L4: subMInt Semantics
  */  
  rule subMInt(MI1:MInt, MI2:MInt) => 
    mi(bitwidthMInt(MI1), svalueMInt(MI1) -Int svalueMInt(MI2))
      requires 
        ((svalueMInt(MI1) >=Int 0 andBool svalueMInt(MI2) >=Int 0)
          orBool
        (svalueMInt(MI1) <Int 0 andBool svalueMInt(MI2) <Int 0))
        andBool bitwidthMInt(MI1) ==Int bitwidthMInt(MI2)

  rule subMInt(MI1:MInt, MI2:MInt) => 
    mi(bitwidthMInt(MI1), svalueMInt(MI1) -Int svalueMInt(MI2))
      requires
        ((svalueMInt(MI1) >=Int 0 andBool svalueMInt(MI2) <Int 0)
          orBool
        (svalueMInt(MI1) <Int 0 andBool svalueMInt(MI2) >=Int 0))
       andBool svalueMInt(MI1) -Int svalueMInt(MI2) >=Int -1 *Int (2 ^Int (bitwidthMInt(MI1) -Int 1)) 
       andBool svalueMInt(MI1) -Int svalueMInt(MI2) <Int 2 ^Int (bitwidthMInt(MI1)-Int 1) 
       andBool bitwidthMInt(MI1) ==Int bitwidthMInt(MI2)
   
  /*@ 
    L5: uvalueMInt semantics
  */
  
  rule uvalueMInt(mi(M:Int, N:Int)) => N
    requires N >=Int 0 
    andBool  N <Int (2 ^Int M)

  rule uvalueMInt(mi(M:Int, N:Int)) => (2 ^Int M) +Int N
    requires N <Int 0 
    andBool  N >=Int -1 *Int (2 ^Int (M -Int 1))
  
  /*@ 
    L6: svalueMInt semantics
  */  
  rule svalueMInt(mi(M:Int, N:Int)) => (-1 *Int (2 ^Int M)) +Int N 
    requires  N >=Int 2 ^Int (M -Int 1)
    andBool   N <Int  2 ^Int M
    andBool   M >Int 1

  rule svalueMInt(mi(M:Int, N:Int)) => N
    requires M >Int 1
      andBool
        N >=Int -1 *Int (2 ^Int (M -Int 1))
      andBool
        N <Int (2 ^Int (M -Int 1))

  rule svalueMInt(mi(M:Int, N:Int)) => N
    requires M ==Int 1
  
  /*@
    Concatenate with 0
  */  
  rule concatenateMInt(MI1, MI2) => 
      mi(bitwidthMInt(MI1) +Int bitwidthMInt(MI2), uvalueMInt(MI2))
    requires eqMInt(MI1, mi(bitwidthMInt(MI1), 0))
  
  /*@
    L8: extract(MI) short width
  */  
  rule extractMInt(MI:MInt, S:Int, E:Int) => mi(E -Int S, uvalueMInt(MI))
    requires  bitwidthMInt(MI) ==Int E
    andBool   E >Int S
    andBool   bitwidthMInt(MI) >Int (E -Int S)
    andBool   uvalueMInt(MI) >=Int 0    
    andBool   uvalueMInt(MI) <Int (2 ^Int (E -Int S))    
    andBool   S ==Int 32 andBool E ==Int 64 

  rule extractMInt(MI:MInt, S:Int, E:Int) => mi(E -Int S, uvalueMInt(MI))
    requires  bitwidthMInt(MI) ==Int E
    andBool   E >Int S
    andBool   bitwidthMInt(MI) >Int (E -Int S)
    andBool   uvalueMInt(MI) >=Int 0    
    andBool   uvalueMInt(MI) <Int (2 ^Int (E -Int S))    
    andBool   S ==Int 1 andBool E ==Int 33
  
  /**
  rule extractMInt(MI:MInt, S:Int, E:Int) => mi(E -Int S, uvalueMInt(extractMInt(MI, S, E)))
    requires  bitwidthMInt(MI) ==Int E
    andBool   E >Int S
    andBool   bitwidthMInt(MI) >Int (E -Int S)
    andBool   uvalueMInt(MI) >=Int 0
    andBool   uvalueMInt(MI) <Int (2 ^Int E)
    andBool   S >=Int 0
    */
  
  /*@
    L11: mi semantics
  */
  rule mi(M, A +Int B) ==K mi(M, J) => A +Int B ==Int J
    requires  
              J >=Int -1 *Int (2 ^Int (M -Int 1)) andBool J <Int (2 ^Int (M -Int 1))

      andBool B +Int ((A *Int (A +Int 1)) /Int 2) >=Int   -1 *Int (2 ^Int (M -Int 1))
      andBool B +Int ((A *Int (A +Int 1)) /Int 2) <Int   (2 ^Int (M -Int 1))

  rule mi(M, I) ==K mi(M, J) => I ==Int J
    requires  I >=Int -1 *Int (2 ^Int (M -Int 1))
      andBool
              I <Int (2 ^Int (M -Int 1))
      andBool 
              J >=Int -1 *Int (2 ^Int (M -Int 1))
      andBool 
              J <Int (2 ^Int (M -Int 1))


  rule mi(M, I) ==K mi(M, J) => ((-1 *Int (2 ^Int M)) +Int I) ==Int ((-1 *Int (2 ^Int M)) +Int J)
    requires  I >=Int 2 ^Int (M -Int 1)
      andBool
              I <Int 2 ^Int M
      andBool
              J >=Int 2 ^Int (M -Int 1)
      andBool
              J <Int 2 ^Int M


  rule MI:MInt ==K mi(M, J) => svalueMInt(MI) ==Int J
    requires #isConcrete(MI)

  rule mi(M, J) ==K MI => J ==Int svalueMInt(MI)
    requires #isConcrete(MI)

  rule eqMInt( mi(M, I), MI2:MInt) => svalueMInt(MI2) ==Int I
    requires  bitwidthMInt(MI2) ==Int M
    andBool   #isConcrete(MI2)

  rule lshrMInt(lshrMInt(M:MInt, I:Int), J:Int) => lshrMInt(M, I +Int J)
    requires I <=Int bitwidthMInt(M) andBool J <=Int bitwidthMInt(M)

  rule lshrMInt(M:MInt, I:Int) => mi(bitwidthMInt(M), 0)
    requires I ==Int bitwidthMInt(M)
    
  rule absInt(I:Int) => I
    requires I >=Int 0
  
  rule absInt(I:Int) => -1 *Int I
    requires I <Int 0
  
endmodule

module ARMV8-VERIFICATION
  imports MINT-LEMMAS
endmodule
