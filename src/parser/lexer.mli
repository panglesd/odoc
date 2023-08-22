(* Internal module, not exposed *)

type input = {
  file : string;
  offset_to_location : int -> Loc.point;
  warnings : Warning.t list ref;
  lexbuf : Lexing.lexbuf;
}

val token : input -> Lexing.lexbuf -> Token.t Loc.with_location

val ref_in_string :
  input -> Lexing.lexbuf -> Token.ref_in_string Loc.with_location
