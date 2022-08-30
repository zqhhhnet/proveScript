// Demo interpreter for the pseudocode of operation of armv8-m instructions

module ARMPSEUDO-SYNTAX-SORTS
  syntax AExp
  syntax AExps
  syntax BExp
  syntax FExp
  syntax Stmt
  syntax Stmts
  syntax Bitstring
  syntax Tuples
  // syntax Array
  syntax QRegsiter
  // syntax Mems
  syntax Operand
  syntax Builtin

endmodule

module ARMPSEUDO-SYNTAX
  imports INT
  imports MINT		// machine integer
  imports BOOL
  imports ARMPSEUDO-SYNTAX-SORTS
  imports ID
  imports STRING
  
  syntax AExp ::= Int
                | Id
                | "(" AExp ")"	[bracket]
                | "-" Int
                | AExp "^" Int	[strict]
                > left:
                  AExp "*" AExp	[strict]
                  AExp "/" AExp	[strict]
                  AExp "DIV" AExp	[strict]
                  AExp "MOD" AExp	[strict]
                > left:
                  AExp "+" AExp	[strict]
                | AExp "-" Int
                > Id "=" AExp 	[strict(2)]
  
  syntax BExp ::= Bool
                | "("  BExp ")"	[bracket]
                | "!" BExp		[strict]
                > AExp "<=" AExp	[strict]
                | AExp "==" AExp	[strict]
                | AExp "!=" AExp	[strict]
                | AExp ">" AExp	[strict]
                | AExp "<" AExp	[strict]
                > left:
                  BExp "&&" BExp	[strict(1)]
                | BExp "||" BExp	[strict(1)]
                
  syntax Builtin ::= add(AExps)	[function]
  
  syntax Stmt ::= AExp ";"
                | "for" Id "=" AExp "to" AExp Stmts	[strict]
                | "if" BExp "then" Stmts	[strict(1)]
                | "if" BExp "then" Stmts
                  "else" Stmts	[strict(1), avoid]
                | "if" BExp "then" Stmts			// need to solve multiple elsif
                  "elsif" BExp "then" Stmts
                  "else" Stmts	[strict(1, 3)]
                | "while" BExp "do" Stmts [strict(1)]
                | "case" AExp "of"				// need to solve multiple when
                  "when" AExp Stmts
                  "when" AExp Stmts
                  "otherwise" Stmts
                | "repeat" Stmts "until" BExp ";"	[strict(2)]
  syntax Stmts ::= List{Stmt, ","}
endmodule

module ARMPSEUDO
  imports ARMPSEUDO-SYNTAX
  
  syntax KResult ::= Int | Bool | String
  
  configuration <T color="yellow">
                  <threads color="orange">
                    <thread multiplicity="*" color="blue">
                      <k color="green"> $PGM:Stmts </k>
                      <env color="LightSkyBlue"> .Map </env>
                      <id color="black"> 0 </id>		// thread id
                    </thread>
                  </threads>
                  <store color="red"> .Map </store>
                </T>
  
  // AExp
  rule <k> X:Id => I ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> I ...</store> [lookup]
  rule - I => 0 -Int I
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2 requires I2 =/=Int 0
  rule I1 + I2 => I1 +Int I2
  rule I1 - I2 => I1 +Int -I2
  
  // BExp
  rule ! T => notBool T
  rule I1 <= I2 => I1 <=Int I2
  rule I1 == I2 => I1 ==Int I2
  rule I1 != I2 => I1 =/=Int I2
  rule I1 < I2 => I1 <Int I2
  rule I1 > I2 => I1 >Int I2
  rule true && B => B
  rule false && _ => false
  rule false || B => B
  rule true || _ => true
  
  // Stmt
  rule _:Int; => .
  // Int assignment
  rule <k> X = I:Int => I ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> (_ => I) ...</store>	[assignment]
  rule if true then S => S
  rule if false then _ => _
  rule if true then S else _ => S
  rule if false then _ else S => S
  rule while B do S => if B then S while B do S else .Stmts	[structural]
  rule repeat S until B ; => S while B do S	[structural]
  rule for X = I to A S => if I <=Int A then S for X = (I => I +Int 1) to A S else .Stmts [structural]
  
endmodule
