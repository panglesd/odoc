(* Internal module, not exposed *)

val parse :
  Warning.t list ref ->
  Token.t Loc.with_location Stream.t ->
  Ast.t * Warning.t list

val parse_ref_in_string :
  Warning.t list ref ->
  Token.ref_in_string Loc.with_location Stream.t ->
  Ast.ref_in_string * Warning.t list
