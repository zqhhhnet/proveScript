module ARMV8-CONVERSIONS-SYNTAX
  imports FLOAT-SYNTAX
  imports FLOAT
  imports INT
  imports MINT
  imports STRING
  imports BOOL
  
  syntax Bool ::= isPositiveZero(Float)	[function]
  syntax Bool ::= isNegativeZero(Float)	[function]
  syntax Bool ::= isZero(Float)		[function]
  
  syntax Float ::= GetInfinity(Int, Int)	[function]
  syntax Float ::= GetNaN(Int, Int)		[function]
  syntax Float ::= MinimumNormalizedFloat(Int, Int)	[function]
  syntax Float ::= SignBitToSign(Int, Int, Int)	[function]
  syntax Float ::= ExponentBitsToExponentMultiplier(Int, Int, Int) [function]
  syntax Float ::= MantissaBitsToFixedPoint(Int, Int, Int, Int) [function]
  syntax Float ::= MIntSegmentsToFloatNormalized(Int, Int, Int, Int, Int) [function]
  syntax Float ::= MIntSegmentsToFloatDenormalized(Int, Int, Int, Int, Int) [function]
  syntax Float ::= MIntToFloatImpl(Int, Int, Int, Int, Int) [function]
  syntax Float ::= MInt2Float(MInt, Int, Int) [function]
  syntax Float ::= Float2Double(Float) [function]
  syntax Float ::= Double2Float(Float) [function]
  syntax Float ::= Half2Float(Float) [function]
  syntax Float ::= SignMultFloat(Float) [function]
  syntax Float ::= ExponentMultFloat(Float) [function]
  syntax Float ::= roundAwayFromZero(Float) [function]
  syntax Float ::= roundToZero(Float) [function]
  syntax Float ::= Float2Half(Float, Int) [function]
  syntax Float ::= negateFloat(Float) [function]
  
  syntax Int ::= MinimumFloatingPointExponent(Int) [function]
               | MantissaFloat(Float) [function]
               | MIntToSignBit(MInt) [function]
               | MIntToExponentBits(MInt, Int) [function]
               | MIntToMantissaBits(MInt, Int, Int) [function]
               | MaxExponent(Int) [function]
               | MaxExponentBits(Int) [function]
               | MinExponent(Int) [function]
               | ExponentBitsToExponent(Int, Int) [function]
               | ExponentBitVectorFloat(Float) [function]
               | SignBit(Float) [function]
               | ConvertExponent(Int) [function]
               | ConvertMantissa(Float) [function]
               | CorrectionFromZero(Int) [function]
  
  syntax MInt ::= Float2MInt(Float, Int) [function]

  
endmodule

module ARMV8-CONVERSIONS
  imports ARMV8-CONVERSIONS-SYNTAX
  
  // Bool
  rule isPositiveZero(F:Float) => true
    requires SignBit(F) ==Int 0 andBool MantissaFloat(F) ==Int 0 andBool ExponentBitVectorFloat(F) ==Int 0
  rule isPositiveZero(F:Float) => false
    requires notBool( SignBit(F) ==Int 0 andBool MantissaFloat(F) ==Int 0 andBool ExponentBitVectorFloat(F) ==Int 0)
  
  rule isNegativeZero(F:Float) => true
    requires SignBit(F) ==Int 1 andBool MantissaFloat(F) ==Int 0 andBool ExponentBitVectorFloat(F) ==Int 0
  rule isNegativeZero(F:Float) => false
    requires notBool( SignBit(F) ==Int 1 andBool MantissaFloat(F) ==Int 0 andBool ExponentBitVectorFloat(F) ==Int 0)
    
  rule isZero(F:Float) => true
    requires isPositiveZero(F) orBool isNegativeZero(F)
  rule isZero(F:Float) => false
    requires notBool ( isPositiveZero(F) orBool isNegativeZero(F) )
  
  // Float
  rule GetInfinity(Mlen, Elen) => roundFloat(2.0 ^Float 1000000.0, Mlen, Elen)
  rule GetNaN(Mlen, Elen) => roundFloat(0.0, Mlen, Elen)
  rule MinimumNormalizedFloat(P, E) => roundFloat(2.0, P, E) ^Float Int2Float(MinimumFloatingPointExponent(E), P, E)
  rule SignBitToSign(M, E, B) => Int2Float(1 -Int (B *Int 2), M, E)
  
  rule ExponentBitsToExponentMultiplier(Mlen, Elen, E) 
    => 
  roundFloat(2.0, Mlen, Elen) ^Float Int2Float(ExponentBitsToExponent(Elen, E), Mlen, Elen)
  
  rule MantissaBitsToFixedPoint(Mlen, Elen, M, I) //I=1 for normalized, I=0 for denormalized.
    =>
  Int2Float((I <<Int (Mlen -Int 1)) |Int M, Mlen, Elen) /Float 
  (
    roundFloat(2.0, Mlen, Elen) ^Float
    Int2Float(Mlen -Int 1, Mlen, Elen)
  )
  
  rule MIntSegmentsToFloatNormalized(Mlen, Elen, S, E, M)
    =>
    roundFloat(
  SignBitToSign(Mlen, Elen, S) *Float
  ExponentBitsToExponentMultiplier(Mlen, Elen, E) *Float
  MantissaBitsToFixedPoint(Mlen, Elen, M, 1), Mlen, Elen)
  
  rule MIntSegmentsToFloatDenormalized(Mlen, Elen, S, _, M)
    =>
    roundFloat(
  SignBitToSign(Mlen, Elen, S) *Float
  ExponentBitsToExponentMultiplier(Mlen, Elen, MinExponent(Elen)) *Float
  MantissaBitsToFixedPoint(Mlen, Elen, M, 0), Mlen, Elen)
  
  rule MIntToFloatImpl(Mlen, Elen, S, E, 0) 
    => 
  SignBitToSign(Mlen, Elen, S) *Float roundFloat(GetInfinity(Mlen, Elen), Mlen, Elen) 
  requires E ==Int MaxExponentBits(Elen)
  
  rule MIntToFloatImpl(Mlen, Elen, _, E, M) => roundFloat(GetNaN(Mlen, Elen), Mlen, Elen) 
  requires E ==Int MaxExponentBits(Elen) andBool M >Int 0

  rule MIntToFloatImpl(Mlen, Elen, S, E, M) 
    => 
  MIntSegmentsToFloatNormalized(Mlen, Elen, S, E, M)
  requires E >Int 0 andBool E <Int MaxExponentBits(Elen)

  rule MIntToFloatImpl(Mlen, Elen, S, 0, M) 
    => 
  MIntSegmentsToFloatDenormalized(Mlen, Elen, S, 0, M)
  
  rule MInt2Float(MI, M, E) => MIntToFloatImpl(M, E, 
    MIntToSignBit(MI),
    MIntToExponentBits(MI, E),
    MIntToMantissaBits(MI, E, M)
  )
  requires bitwidthMInt(MI) ==Int M +Int E andBool M >=Int 2 andBool E >=Int 2
  
  rule Float2Double(F) => roundFloat(F, 53, 11)
  rule Double2Float(F) => roundFloat(F, 24, 8)
  rule Half2Float(F) => roundFloat(F, 24, 8)
  
  rule SignMultFloat(F) => roundFloat(1.0, precisionFloat(F), exponentBitsFloat(F)) requires F >=Float roundFloat(0.0, precisionFloat(F), exponentBitsFloat(F))
  rule SignMultFloat(F) => roundFloat(-1.0, precisionFloat(F), exponentBitsFloat(F)) requires F <Float roundFloat(0.0, precisionFloat(F), exponentBitsFloat(F))
  
  rule ExponentMultFloat(F) => Int2Float(2, precisionFloat(F), exponentBitsFloat(F)) ^Float Int2Float(exponentFloat(F), precisionFloat(F), exponentBitsFloat(F))
  
  rule roundAwayFromZero(F) => MInt2Float(mi(16, (SignBit(F) <<Int 15) |Int (ConvertExponent(exponentFloat(F)) <<Int 10) |Int (ConvertMantissa(F) +Int CorrectionFromZero(MantissaFloat(F) &Int ((1 <<Int precisionFloat(F) -Int 11) -Int 1)))), 11, 5)
  
  rule roundToZero(F) => MInt2Float(mi(16, (SignBit(F) <<Int 15) |Int (ConvertExponent(exponentFloat(F)) <<Int 10) |Int ConvertMantissa(F)), 11, 5)
  
  rule Float2Half(F, 0) => roundFloat(F, 11, 5) 

/*  rule Float2Half(F, 1) => GetNaN(11, 5) requires isNaN(F)
  rule Float2Half(F, 1) => GetNaN(11, 5) requires F >Float maxValueFloat(precisionFloat(F), exponentBitsFloat(F))
  rule Float2Half(F, 1) => --Float GetInfinity(11, 5) requires F <Float --Float maxValueFloat(precisionFloat(F), exponentBitsFloat(F))*/ 
  

  rule Float2Half(F, 1) => roundToZero(F) requires notBool signFloat(F) 
  rule Float2Half(F, 1) => roundAwayFromZero(F) requires signFloat(F)
  
  rule Float2Half(F, 2) => roundAwayFromZero(F) requires notBool signFloat(F) 
  rule Float2Half(F, 2) => roundToZero(F) requires signFloat(F)
  rule Float2Half(F, 3) => roundToZero(F)
  
  rule negateFloat(F) => --Float F
  
  // Int
  rule MinimumFloatingPointExponent(E) => 2 -Int (2 ^Int (E -Int 1))
  
  rule MantissaFloat(F) => 0 requires isInfinite(F) // Infinities' mantissas must be zero.

  // The following value, chosen for the mantissa of a NaN, is arbitrary and
  // may differ from the corresponsing representation in machine.
  rule MantissaFloat(F) => 1 requires isNaN(F)
  
  rule MantissaFloat(F) => MantissaFloat(absFloat(F) +Float MinimumNormalizedFloat(precisionFloat(F), exponentBitsFloat(F)))
  requires absFloat(F) <Float MinimumNormalizedFloat(precisionFloat(F), exponentBitsFloat(F)) 

  rule MantissaFloat(F) => Float2Int(
    roundFloat(absFloat(F), precisionFloat(F), exponentBitsFloat(F) +Int 2) 
    *Float (roundFloat(2.0, precisionFloat(F), exponentBitsFloat(F) +Int 2) ^Float Int2Float(precisionFloat(F) -Int 1 -Int exponentFloat(F), precisionFloat(F), exponentBitsFloat(F) +Int 2))
  ) &Int ((1 <<Int (precisionFloat(F) -Int 1)) -Int 1) [owise]
  // First, get rid of the sign bit.  
  // Next, multiply by 2^-Exponent to zero the exponent (getting a fixed point of 1.MantissaBits)
  // Then multiply by 2^#NumMantissaBits (Getting a float of 1(MantissaBits).0)
  // Then, convert to an int.
  // Then Mask out the uppermost 1.  This yields an int containing the Mantissa of the original float.
  
  rule MIntToSignBit(MI) => uvalueMInt(extractMInt(MI, 0, 1)) 
  
  rule MIntToExponentBits(M, E) => uvalueMInt(extractMInt(M, 1, 1 +Int E))
  
  rule MIntToMantissaBits(MI, E, M) => uvalueMInt(extractMInt(MI, 1 +Int E, E +Int M)) 
  
  rule MaxExponent(I) => 1 <<Int (I -Int 1) 
  
  rule MaxExponentBits(I) => (1 <<Int I) -Int 1
  
  rule MinExponent(I) => 2 -Int MaxExponent(I)
  
  rule ExponentBitsToExponent(Elen, E) => minInt(maxInt(E -Int MaxExponent(Elen) +Int 1, MinExponent(Elen)), MaxExponent(Elen))
  
  rule ExponentBitVectorFloat(F) => 0 requires absFloat(F) <Float MinimumNormalizedFloat(precisionFloat(F), exponentBitsFloat(F))
  rule ExponentBitVectorFloat(F) => (1 <<Int exponentBitsFloat(F)) -Int 1 requires isInfinite(F) orBool isNaN(F)
  rule ExponentBitVectorFloat(F) => exponentFloat(F) +Int (1 <<Int (exponentBitsFloat(F) -Int 1)) -Int 1 [owise] 
  
  rule SignBit(F) => 0 requires notBool signFloat(F)
  rule SignBit(F) => 1 requires signFloat(F)
  
  // MInt
  rule Float2MInt(F, 16) => mi(16, (SignBit(F) <<Int 15) |Int (ExponentBitVectorFloat(F) <<Int 10) |Int MantissaFloat(F)) 
    requires precisionFloat(F) ==Int 11 andBool exponentBitsFloat(F) ==Int 5

  rule Float2MInt(F, 32) => mi(32, (SignBit(F) <<Int 31) |Int (ExponentBitVectorFloat(F) <<Int 23) |Int MantissaFloat(F))
    requires precisionFloat(F) ==Int 24 andBool exponentBitsFloat(F) ==Int 8

  rule Float2MInt(F, 64) => mi(64, (SignBit(F) <<Int 63) |Int (ExponentBitVectorFloat(F) <<Int 52) |Int MantissaFloat(F))
    requires precisionFloat(F) ==Int 53 andBool exponentBitsFloat(F) ==Int 11
  
endmodule
