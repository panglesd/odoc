open Odoc_model.Lang.Source_code.Info

let ocaml =
  {|{
  "name": "OCaml",
  "scopeName": "source.ocaml",
  "fileTypes": ["ml", "eliom", ".ocamlinit"],
  "patterns": [
    { "include": "#directives" },
    { "include": "#comments" },
    { "include": "#strings" },
    { "include": "#characters" },
    { "include": "#attributes" },
    { "include": "#extensions" },
    { "include": "#modules" },
    { "include": "#bindings" },
    { "include": "#operators" },
    { "include": "#keywords" },
    { "include": "#literals" },
    { "include": "#types" },
    { "include": "#identifiers" }
  ],
  "repository": {
    "directives": {
      "patterns": [
        {
          "comment": "line number directive",
          "begin": "^[[:space:]]*(#)[[:space:]]*([[:digit:]]+)",
          "end": "$",
          "beginCaptures": {
            "1": { "name": "keyword.other.ocaml" },
            "2": { "name": "constant.numeric.decimal.integer.ocaml" }
          },
          "contentName": "comment.line.directive.ocaml"
        },
        {
          "comment": "topfind directives",
          "begin": "^[[:space:]]*(#)[[:space:]]*(require|list|camlp4o|camlp4r|predicates|thread)",
          "end": "$",
          "beginCaptures": {
            "1": { "name": "keyword.other.ocaml" },
            "2": { "name": "keyword.other.ocaml" }
          },
          "patterns": [{ "include": "#strings" }]
        },
        {
          "comment": "cppo directives",
          "begin": "^[[:space:]]*(#)[[:space:]]*(define|undef|ifdef|ifndef|if|else|elif|endif|include|warning|error|ext|endext)",
          "end": "$",
          "beginCaptures": {
            "1": { "name": "keyword.other.ocaml" },
            "2": { "name": "keyword.other.ocaml" }
          },
          "patterns": [
            { "name": "keyword.other.ocaml", "match": "\\b(defined)\\b" },
            { "name": "keyword.other.ocaml", "match": "\\\\" },
            { "include": "#comments" },
            { "include": "#strings" },
            { "include": "#characters" },
            { "include": "#keywords" },
            { "include": "#operators" },
            { "include": "#literals" },
            { "include": "#types" },
            { "include": "#identifiers" }
          ]
        }
      ]
    },

    "comments": {
      "patterns": [
        {
          "comment": "empty comment",
          "name": "comment.block.ocaml",
          "match": "\\(\\*\\*\\)"
        },
        {
          "comment": "ocamldoc comment",
          "name": "comment.doc.ocaml",
          "begin": "\\(\\*\\*",
          "end": "\\*\\)",
          "patterns": [
            { "include": "source.ocaml.ocamldoc#markup" },
            { "include": "#strings-in-comments" },
            { "include": "#comments" }
          ]
        },
        {
          "comment": "Cinaps comment",
          "begin": "\\(\\*\\$",
          "end": "\\*\\)",
          "beginCaptures": {"1" : { "name": "comment.cinaps.ocaml" }},
          "endCaptures": {"1" : { "name": "comment.cinaps.ocaml" }},
          "patterns": [{ "include": "$self" }]
        },
        {
          "comment": "block comment",
          "name": "comment.block.ocaml",
          "begin": "\\(\\*",
          "end": "\\*\\)",
          "patterns": [
            { "include": "#strings-in-comments" },
            { "include": "#comments" }
          ]
        }
      ]
    },

    "strings-in-comments": {
      "patterns": [
        {
          "comment": "char literal",
          "match": "'(\\\\)?.'"
        },
        {
          "comment": "string literal",
          "begin": "\"",
          "end": "\"",
          "patterns": [{ "match": "\\\\\\\\" }, { "match": "\\\\\"" }]
        },
        {
          "comment": "quoted string literal",
          "begin": "\\{[[:lower:]_]*\\|",
          "end": "\\|[[:lower:]_]*\\}"
        }
      ]
    },

    "strings": {
      "patterns": [
        {
          "comment": "quoted string literal",
          "name": "string.quoted.braced.ocaml",
          "begin": "\\{(%%?[[:alpha:]_][[:word:]']*(\\.[[:alpha:]_][[:word:]']*)*[[:space:]]*)?[[:lower:]_]*\\|",
          "end": "\\|[[:lower:]_]*\\}",
          "beginCaptures": {
            "1": { "name": "keyword.other.extension.ocaml" }
          }
        },
        {
          "comment": "string literal",
          "name": "string.quoted.double.ocaml",
          "begin": "\"",
          "end": "\"",
          "patterns": [
            {
              "comment": "escaped newline",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\$"
            },
            {
              "comment": "escaped backslash",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\\\\\"
            },
            {
              "comment": "escaped quote or whitespace",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\[\"'ntbr ]"
            },
            {
              "comment": "character from decimal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\[[:digit:]]{3}"
            },
            {
              "comment": "character from hexadecimal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\x[[:xdigit:]]{2}"
            },
            {
              "comment": "character from octal ASCII code",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\o[0-3][0-7]{2}"
            },
            {
              "comment": "unicode character escape sequence",
              "name": "constant.character.escape.ocaml",
              "match": "\\\\u\\{[[:xdigit:]]{1,6}\\}"
            },
            {
              "comment": "printf format string",
              "name": "constant.character.printf.ocaml",
              "match": "%[-0+ #]*([[:digit:]]+|\\*)?(.([[:digit:]]+|\\*))?[lLn]?[diunlLNxXosScCfFeEgGhHBbat!%@,]"
            },
            {
              "comment": "unknown escape sequence",
              "name": "invalid.illegal.unknown-escape.ocaml",
              "match": "\\\\."
            }
          ]
        }
      ]
    },

    "characters": {
      "patterns": [
        {
          "comment": "character literal from escaped backslash",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\\\\\)'",
          "captures": { "1": { "name": "constant.character.escape.ocaml" } }
        },
        {
          "comment": "character literal from escaped quote or whitespace",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\[\"'ntbr ])'",
          "captures": { "1": { "name": "constant.character.escape.ocaml" } }
        },
        {
          "comment": "character literal from decimal ASCII code",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\[[:digit:]]{3})'",
          "captures": { "1": { "name": "constant.character.escape.ocaml" } }
        },
        {
          "comment": "character literal from hexadecimal ASCII code",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\x[[:xdigit:]]{2})'",
          "captures": { "1": { "name": "constant.character.escape.ocaml" } }
        },
        {
          "comment": "character literal from octal ASCII code",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\o[0-3][0-7]{2})'",
          "captures": { "1": { "name": "constant.character.escape.ocaml" } }
        },
        {
          "comment": "character literal from unknown escape sequence",
          "name": "string.quoted.single.ocaml",
          "match": "'(\\\\.)'",
          "captures": {
            "1": { "name": "invalid.illegal.unknown-escape.ocaml" }
          }
        },
        {
          "comment": "character literal",
          "name": "string.quoted.single.ocaml",
          "match": "'.'"
        }
      ]
    },

    "attributes": {
      "begin": "\\[(@|@@|@@@)[[:space:]]*([[:alpha:]_]+(\\.[[:word:]']+)*)",
      "end": "\\]",
      "beginCaptures": {
        "1": { "name": "keyword.operator.attribute.ocaml" },
        "2": {
          "name": "keyword.other.attribute.ocaml",
          "patterns": [
            {
              "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
              "match": "\\."
            }
          ]
        }
      },
      "patterns": [{ "include": "$self" }]
    },

    "extensions": {
      "begin": "\\[(%|%%)[[:space:]]*([[:alpha:]_]+(\\.[[:word:]']+)*)",
      "end": "\\]",
      "beginCaptures": {
        "1": { "name": "keyword.operator.extension.ocaml" },
        "2": {
          "name": "keyword.other.extension.ocaml",
          "patterns": [
            {
              "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
              "match": "\\."
            }
          ]
        }
      },
      "patterns": [{ "include": "$self" }]
    },

   "modules": {
      "patterns": [
        {
          "begin": "\\b(sig)\\b",
          "end": "\\b(end)\\b",
          "beginCaptures": {"1" : { "name": "keyword.other.ocaml" }},
          "endCaptures": {"1" : { "name": "keyword.other.ocaml" }},
          "patterns": [{ "include": "source.ocaml" }]
        },
        {
          "begin": "\\b(struct)\\b",
          "end": "\\b(end)\\b",
          "beginCaptures": {"1" : { "name": "keyword.other.ocaml" }},
          "endCaptures": { "1" : { "name": "keyword.other.ocaml" }},
          "patterns": [{ "include": "$self" }]
        }
      ]
    },

    "bindings": {
      "patterns": [
        {
          "comment": "for loop",
          "match": "\\b(for)[[:space:]]+([[:lower:]_][[:word:]']*)",
          "captures": {
            "1": { "name": "keyword.ocaml" },
            "2": { "name": "entity.name.function.binding.ocaml" }
          }
        },
        {
          "comment": "local open/exception/module",
          "match": "\\b(let)[[:space:]]+(open|exception|module)\\b(?!')",
          "captures": {
            "1": { "name": "keyword.ocaml" },
            "2": { "name": "keyword.ocaml" }
          }
        },
        {
          "comment": "let expression",
          "match": "\\b(let)[[:space:]]+(?!lazy\\b(?!'))(rec[[:space:]]+)?(?!rec\\b(?!'))([[:lower:]_][[:word:]']*)(?![[:word:]'])[[:space:]]*(?!,|::|[[:space:]])",
          "captures": {
            "1": { "name": "keyword.ocaml" },
            "2": { "name": "keyword.ocaml" },
            "3": { "name": "entity.name.function.binding.ocaml" }
          }
        },
        {
          "comment": "using binding operators",
          "match": "\\b(let|and)([$&*+\\-/=>@^|<][!?$&*+\\-/=>@^|%:]*)[[:space:]]*(?!lazy\\b(?!'))([[:lower:]_][[:word:]']*)(?![[:word:]'])[[:space:]]*(?!,|::|[[:space:]])",
          "captures": {
            "1": { "name": "keyword.ocaml" },
            "2": { "name": "keyword.ocaml" },
            "3": { "name": "entity.name.function.binding.ocaml" }
          }
        },
        {
          "comment": "first class module packing",
          "match": "\\([[:space:]]*(val)[[:space:]]+([[:lower:]_][[:word:]']*)",
          "captures": {
            "1": { "name": "keyword.ocaml" },
            "2": { "patterns": [{ "include": "$self" }] }
          }
        },
        {
          "comment": "locally abstract types",
          "match": "(?:\\(|(:))[[:space:]]*(type)((?:[[:space:]]+[[:lower:]_][[:word:]']*)+)",
          "captures": {
            "1": {
              "name": "keyword.other.ocaml punctuation.other.colon punctuation.colon"
            },
            "2": { "name": "keyword.ocaml" },
            "3": { "name": "entity.name.function.binding.ocaml" }
          }
        },
        {
          "comment": "optional labeled argument with type",
          "begin": "(\\?)\\([[:space:]]*([[:lower:]_][[:word:]']*)",
          "beginCaptures": {
            "1": { "name": "variable.parameter.optional.ocaml" },
            "2": { "name": "variable.parameter.optional.ocaml" }
          },
          "end": "\\)",
          "patterns": [{ "include": "$self" }]
        },
        {
          "comment": "labeled argument with type",
          "begin": "(~)\\([[:space:]]*([[:lower:]_][[:word:]']*)",
          "beginCaptures": {
            "1": { "name": "variable.parameter.labeled.ocaml" },
            "2": { "name": "variable.parameter.labeled.ocaml" }
          },
          "end": "\\)",
          "patterns": [{ "include": "$self" }]
        },
        { "include": "source.ocaml.interface#bindings" }
      ]
    },

    "operators": {
      "patterns": [
        {
          "comment": "binding operator",
          "name": "keyword.ocaml",
          "match": "\\b(let|and)[$&*+\\-/=>@^|<][!?$&*+\\-/=>@^|%:]*"
        },
        {
          "comment": "infix symbol",
          "name": "keyword.operator.ocaml",
          "match": "[$&*+\\-/=>@^%<][~!?$&*+\\-/=>@^|%<:.]*"
        },
        {
          "comment": "infix symbol that begins with vertical bar",
          "name": "keyword.operator.ocaml",
          "match": "\\|[~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "vertical bar",
          "name": "keyword.other.ocaml",
          "match": "(?<!\\[)(\\|)(?!\\])"
        },
        {
          "comment": "infix symbol",
          "name": "keyword.operator.ocaml",
          "match": "#[~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "prefix symbol",
          "name": "keyword.operator.ocaml",
          "match": "![~!?$&*+\\-/=>@^|%<:.]*"
        },
        {
          "comment": "prefix symbol",
          "name": "keyword.operator.ocaml",
          "match": "[?~][~!?$&*+\\-/=>@^|%<:.]+"
        },
        {
          "comment": "named operator",
          "name": "keyword.operator.ocaml",
          "match": "\\b(or|mod|land|lor|lxor|lsl|lsr|asr)\\b"
        },
        {
          "comment": "method invocation",
          "name": "keyword.other.ocaml",
          "match": "#"
        },
        {
          "comment": "type annotation",
          "name": "keyword.other.ocaml punctuation.other.colon punctuation.colon",
          "match": ":"
        },
        {
          "comment": "field accessor",
          "name": "keyword.other.ocaml punctuation.other.period punctuation.separator.period",
          "match": "\\."
        },
        {
          "comment": "semicolon separator",
          "name": "keyword.other.ocaml punctuation.separator.terminator punctuation.separator.semicolon",
          "match": ";"
        },
        {
          "comment": "comma separator",
          "name": "keyword.other.ocaml punctuation.comma punctuation.separator.comma",
          "match": ","
        }
      ]
    },

    "keywords": {
      "patterns": [
        {
          "comment": "reserved ocaml keyword",
          "name": "keyword.other.ocaml",
          "match": "\\b(and|as|assert|begin|class|constraint|do|done|downto|else|end|exception|external|for|fun|function|functor|if|in|include|inherit|initializer|lazy|let|match|method|module|mutable|new|nonrec|object|of|open|private|rec|sig|struct|then|to|try|type|val|virtual|when|while|with)\\b(?!')"
        }
      ]
    },

    "literals": {
      "patterns": [
        {
          "comment": "boolean literal",
          "name": "constant.language.boolean.ocaml",
          "match": "\\b(true|false)\\b"
        },

        {
          "comment": "floating point decimal literal with exponent",
          "name": "constant.numeric.decimal.float.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*(\\.[[:digit:]_]*)?[eE][+-]?[[:digit:]][[:digit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "floating point decimal literal",
          "name": "constant.numeric.decimal.float.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*)(\\.[[:digit:]_]*[g-zG-Z]?\\b|\\.)"
        },
        {
          "comment": "floating point hexadecimal literal with exponent part",
          "name": "constant.numeric.hexadecimal.float.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*(\\.[[:xdigit:]_]*)?[pP][+-]?[[:digit:]][[:digit:]_]*[g-zG-Z]?)\\b"
        },
        {
          "comment": "floating point hexadecimal literal",
          "name": "constant.numeric.hexadecimal.float.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*)(\\.[[:xdigit:]_]*[g-zG-Z]?\\b|\\.)"
        },

        {
          "comment": "decimal integer literal",
          "name": "constant.numeric.decimal.integer.ocaml",
          "match": "\\b([[:digit:]][[:digit:]_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "hexadecimal integer literal",
          "name": "constant.numeric.hexadecimal.integer.ocaml",
          "match": "\\b((0x|0X)[[:xdigit:]][[:xdigit:]_]*[lLng-zG-Z]?)\\b"
        },
        {
          "comment": "octal integer literal",
          "name": "constant.numeric.octal.integer.ocaml",
          "match": "\\b((0o|0O)[0-7][0-7_]*[lLng-zG-Z]?)\\b"
        },

        {
          "comment": "binary integer literal",
          "name": "constant.numeric.binary.integer.ocaml",
          "match": "\\b((0b|0B)[0-1][0-1_]*[lLng-zG-Z]?)\\b"
        },

        {
          "comment": "unit literal",
          "name": "constant.language.unit.ocaml",
          "match": "\\(\\)"
        },
        {
          "comment": "parentheses",
          "begin": "\\(",
          "end": "\\)",
          "patterns": [{ "include": "$self" }]
        },

        {
          "comment": "empty array",
          "name": "constant.language.array.ocaml",
          "match": "\\[\\|\\|\\]"
        },
        {
          "comment": "array",
          "begin": "\\[\\|",
          "end": "\\|\\]",
          "patterns": [{ "include": "$self" }]
        },

        {
          "comment": "empty list",
          "name": "constant.language.list.ocaml",
          "match": "\\[\\]"
        },
        {
          "comment": "list",
          "begin": "\\[",
          "end": "]",
          "patterns": [{ "include": "$self" }]
        },
        {
          "comment": "braces",
          "begin": "\\{",
          "end": "\\}",
          "patterns": [{ "include": "$self" }]
        }
      ]
    },

    "types": {
      "patterns": [
        {
          "comment": "type parameter",
          "name": "storage.type.ocaml",
          "match": "'[[:alpha:]][[:word:]']*\\b|'_\\b"
        },
        {
          "comment": "weak type parameter",
          "name": "storage.type.weak.ocaml",
          "match": "'_[[:alpha:]][[:word:]']*\\b"
        },
        {
          "comment": "builtin type",
          "name": "support.type.ocaml",
          "match": "\\b(unit|bool|int|int32|int64|nativeint|float|char|bytes|string)\\b"
        }
      ]
    },

    "identifiers": {
      "patterns": [
        {
          "comment": "wildcard underscore",
          "name": "constant.language.ocaml",
          "match": "\\b_\\b"
        },
        {
          "comment": "capital identifier for constructor, exception, or module",
          "name": "constant.language.capital-identifier.ocaml",
          "match": "\\b[[:upper:]][[:word:]']*('|\\b)"
        },
        {
          "comment": "lowercase identifier",
          "name": "source.ocaml",
          "match": "\\b[[:lower:]_][[:word:]']*('|\\b)"
        },
        {
          "comment": "polymorphic variant tag",
          "name": "constant.language.polymorphic-variant.ocaml",
          "match": "\\`[[:alpha:]][[:word:]']*\\b"
        },
        {
          "comment": "empty list (can be used as a constructor)",
          "name": "constant.language.list.ocaml",
          "match": "\\[\\]"
        }
      ]
    }
  }
}
|}

let ocaml_grammar = TmLanguage.of_yojson_exn (Yojson.Basic.from_string ocaml)

let t =
  let t = TmLanguage.create () in
  TmLanguage.add_grammar t ocaml_grammar;
  t

let rec highlight_tokens start i spans = function
  | [] -> (spans, start + i)
  | tok :: toks ->
      let j = TmLanguage.ending tok in
      assert (j > i);
      let scope =
        match TmLanguage.scopes tok with
        | [] -> []
        | scope :: _ ->
            List.concat_map
              (fun scope -> String.split_on_char ' ' scope)
              [ scope ]
            |> List.concat_map (fun scope -> String.split_on_char '.' scope)
        (* let scopes = TmLanguage.scopes tok in *)
        (* List.concat_map (fun scope -> String.split_on_char ' ' scope) scopes *)
        (* |> List.concat_map (fun scope -> String.split_on_char '.' scope) *)
      in

      highlight_tokens start j ((scope, (start + i, start + j)) :: spans) toks

let highlight_string t grammar stack str =
  let lines = String.split_on_char '\n' str in
  let rec loop i stack acc = function
    | [] -> List.rev acc
    | line :: lines ->
        (* Some patterns don't work if there isn't a newline *)
        let line = line ^ "\n" in
        let tokens, stack = TmLanguage.tokenize_exn t grammar stack line in
        let spans, tot = highlight_tokens i 0 [] tokens in
        loop tot stack (spans :: acc) lines
  in
  List.concat @@ loop 0 stack [] lines

(* let syntax_highlighting_locs src = *)
(*   let lexbuf = Lexing.from_string ~with_positions:true src in *)
(*   let rec collect lexbuf = *)
(*     let tok = Lexer.token_with_comments lexbuf in *)
(*     let loc_start, loc_end = (lexbuf.lex_start_p, lexbuf.lex_curr_p) in *)
(*     let continue token = *)
(*       (token, (loc_start.pos_cnum, loc_end.pos_cnum)) :: collect lexbuf *)
(*     in *)
(*     match tok with *)
(*     | EOF -> [] *)
(*     | COMMENT (_, loc) -> *)
(*         (Comment, (loc.loc_start.pos_cnum, loc.loc_end.pos_cnum)) *)
(*         :: collect lexbuf *)
(*     | DOCSTRING doc -> *)
(*         let loc = Docstrings.docstring_loc doc in *)
(*         (Docstring, (loc.loc_start.pos_cnum, loc.loc_end.pos_cnum)) *)
(*         :: collect lexbuf *)
(*     | VAL | TYPE | LET | REC | IN | OPEN | NONREC | MODULE | METHOD | LETOP _ *)
(*     | INHERIT | INCLUDE | OBJECT | FUNCTOR | EXTERNAL | CONSTRAINT | ASSERT *)
(*     | AND | END | CLASS | SEMISEMI | SEMI -> *)
(*         continue Keyword *)
(*     | WITH | WHILE | WHEN | VIRTUAL | TRY | TO | THEN | STRUCT | SIG | PRIVATE *)
(*     | OF | NEW | MUTABLE | MATCH | LAZY | IF | FUNCTION | FUN | FOR | EXCEPTION *)
(*     | ELSE | DOWNTO | DO | DONE | BEGIN | AS -> *)
(*         continue Keyword_other *)
(*     | TRUE | FALSE -> continue Boolean_constant *)
(*     | STRING _ | CHAR _ | QUOTED_STRING_ITEM _ | QUOTED_STRING_EXPR _ -> *)
(*         continue String_constant *)
(*     | INT _ | FLOAT _ -> continue Numeric_constant *)
(*     | LIDENT "failwith" -> continue Alert *)
(*     | UNDERSCORE | UIDENT _ | TILDE | STAR | RPAREN | RBRACKET | RBRACE | QUOTE *)
(*     | QUESTION | PREFIXOP _ | PLUSEQ | PLUSDOT | PLUS | PERCENT | OR *)
(*     | OPTLABEL _ | MINUSGREATER | MINUSDOT | MINUS | LPAREN | LIDENT _ *)
(*     | LESSMINUS | LESS | LBRACKETPERCENTPERCENT | LBRACKETPERCENT | LBRACKETLESS *)
(*     | LBRACKETGREATER | LBRACKETBAR | LBRACKETATATAT | LBRACKETATAT | LBRACKETAT *)
(*     | LBRACKET | LBRACELESS | LBRACE | LABEL _ | INITIALIZER | INFIXOP4 _ *)
(*     | INFIXOP3 _ | INFIXOP2 _ | INFIXOP1 _ | INFIXOP0 _ | HASHOP _ | HASH *)
(*     | GREATERRBRACKET | GREATERRBRACE | GREATER | EQUAL | EOL | DOTOP _ | DOTDOT *)
(*     | DOT | COMMA | COLONGREATER | COLONEQUAL | COLONCOLON | COLON | BARRBRACKET *)
(*     | BARBAR | BAR | BANG | BACKQUOTE | ANDOP _ | AMPERSAND | AMPERAMPER -> *)
(*         collect lexbuf *)
(*   in *)
(*   collect lexbuf *)

let new_syntax src = highlight_string t ocaml_grammar TmLanguage.empty src

let highlight src =
  (* syntax_highlighting_locs src |> List.rev_map (fun (x, y) -> (Syntax x, y)) *)
  new_syntax src |> List.rev_map (fun (x, y) -> (Syntax x, y))
(* The order won't matter and input can be large *)
