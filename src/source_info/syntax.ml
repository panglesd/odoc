open Odoc_model.Lang.Source_code.Info

let syntax_highlighting_locs src =
  let lexbuf = Lexing.from_string ~with_positions:true src in
  let rec collect lexbuf =
    let tok = Lexer.token_with_comments lexbuf in
    let loc_start, loc_end = (lexbuf.lex_start_p, lexbuf.lex_curr_p) in
    let continue token =
      (token, (loc_start.pos_cnum, loc_end.pos_cnum)) :: collect lexbuf
    in
    match tok with
    | EOF -> []
    | COMMENT (_, loc) ->
        (Comment, (loc.loc_start.pos_cnum, loc.loc_end.pos_cnum))
        :: collect lexbuf
    | DOCSTRING doc ->
        let loc = Docstrings.docstring_loc doc in
        (Docstring, (loc.loc_start.pos_cnum, loc.loc_end.pos_cnum))
        :: collect lexbuf
    | VAL | TYPE | LET | REC | IN | OPEN | NONREC | MODULE | METHOD | LETOP _
    | INHERIT | INCLUDE | OBJECT | FUNCTOR | EXTERNAL | CONSTRAINT | ASSERT
    | AND | END | CLASS | SEMISEMI | SEMI ->
        continue Keyword
    | WITH | WHILE | WHEN | VIRTUAL | TRY | TO | THEN | STRUCT | SIG | PRIVATE
    | OF | NEW | MUTABLE | MATCH | LAZY | IF | FUNCTION | FUN | FOR | EXCEPTION
    | ELSE | DOWNTO | DO | DONE | BEGIN | AS ->
        continue Keyword_other
    | TRUE | FALSE -> continue Boolean_constant
    | STRING _ | CHAR _ | QUOTED_STRING_ITEM _ | QUOTED_STRING_EXPR _ ->
        continue String_constant
    | INT _ | FLOAT _ -> continue Numeric_constant
    | LIDENT "failwith" -> continue Alert
    | UNDERSCORE | UIDENT _ | TILDE | STAR | RPAREN | RBRACKET | RBRACE | QUOTE
    | QUESTION | PREFIXOP _ | PLUSEQ | PLUSDOT | PLUS | PERCENT | OR
    | OPTLABEL _ | MINUSGREATER | MINUSDOT | MINUS | LPAREN | LIDENT _
    | LESSMINUS | LESS | LBRACKETPERCENTPERCENT | LBRACKETPERCENT | LBRACKETLESS
    | LBRACKETGREATER | LBRACKETBAR | LBRACKETATATAT | LBRACKETATAT | LBRACKETAT
    | LBRACKET | LBRACELESS | LBRACE | LABEL _ | INITIALIZER | INFIXOP4 _
    | INFIXOP3 _ | INFIXOP2 _ | INFIXOP1 _ | INFIXOP0 _ | HASHOP _ | HASH
    | GREATERRBRACKET | GREATERRBRACE | GREATER | EQUAL | EOL | DOTOP _ | DOTDOT
    | DOT | COMMA | COLONGREATER | COLONEQUAL | COLONCOLON | COLON | BARRBRACKET
    | BARBAR | BAR | BANG | BACKQUOTE | ANDOP _ | AMPERSAND | AMPERAMPER ->
        collect lexbuf
  in
  collect lexbuf

let highlight src =
  syntax_highlighting_locs src |> List.rev_map (fun (x, y) -> (Syntax x, y))
(* The order won't matter and input can be large *)
