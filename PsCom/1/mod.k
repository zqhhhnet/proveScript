module MOD
  imports INT
  
  syntax Exp ::= Int
               | "(" Exp ")"   [bracket]
               > Exp "mod" Exp [function]
               | Exp "multi" Exp [function]
               | Exp "div" Exp [function]
               > left:
                 Exp "add" Exp [function]

  rule A mod B => A modInt B	requires A >Int B
  rule A mod B => A 		requires A <=Int B
  rule A multi B => A *Int B
  rule A div B => A /Int B
  rule A add B => A +Int B
endmodule
