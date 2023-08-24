open Odoc_parser

type sexp = Sexplib0.Sexp.t = Atom of string | List of sexp list

module Location_to_sexp = struct
  let point : Loc.point -> sexp =
   fun { line; column } ->
    List [ Atom (string_of_int line); Atom (string_of_int column) ]

  let span : Loc.span -> sexp =
   fun { file; start; end_ } -> List [ Atom file; point start; point end_ ]

  let at : ('a -> sexp) -> 'a Loc.with_location -> sexp =
   fun f { location; value } -> List [ span location; f value ]
end

module Ast_to_sexp = struct
  (* let at = Location_to_sexp.at *)
  type at = { at : 'a. ('a -> sexp) -> 'a Loc.with_location -> sexp }

  let loc_at = { at = Location_to_sexp.at }
  let str s = Atom s
  let opt f s = match s with Some s -> List [ f s ] | None -> List []

  let block at : _ -> sexp = function
    | `Txt s -> List [ Atom "Txt"; Atom s ]
    | `Simple_reference s_loc ->
        List [ Atom "reference"; at.at (fun x -> Atom x) s_loc ]
    | `Reference_with_replacement_text (target_loc, txt) ->
        List
          [
            Atom "reference_with_text";
            at.at (fun x -> Atom x) target_loc;
            Atom txt;
          ]
    | `Simple_link target_loc ->
        List [ Atom "link"; at.at (fun x -> Atom x) target_loc ]
    | `Link_with_replacement_text (target_loc, txt) ->
        List
          [
            Atom "link_with_text"; at.at (fun x -> Atom x) target_loc; Atom txt;
          ]
  let ris at f = List (List.map (block at) f)
end

let error err = Atom (Odoc_parser.Warning.to_string err)

let parser_output formatter (ast, warnings) =
  let value = Ast_to_sexp.(ris loc_at ast) in
  let warnings = List (List.map error warnings) in
  let output =
    List [ List [ Atom "output"; value ]; List [ Atom "warnings"; warnings ] ]
  in
  Sexplib0.Sexp.pp_hum formatter output;
  Format.pp_print_flush formatter ()

let test ?(location = { Loc.line = 1; column = 0 }) str =
  let dummy_filename = "f.ml" in
  let location =
    {
      Lexing.pos_fname = dummy_filename;
      pos_lnum = location.line;
      pos_bol = 0;
      pos_cnum = location.column;
    }
  in
  let ast = Odoc_parser.parse_ref_in_string ~location ~text:str in
  Format.printf "%a" parser_output ast

[@@@ocaml.warning "-32"]

let%expect_test _ =
  let module Trivial = struct
    let empty =
      test "";
      [%expect "((output ()) (warnings ()))"]

    let space =
      test " ";
      [%expect {|((output ((Txt " "))) (warnings ()))|}]

    let simple_ref =
      test {|blabla
blibli {!ref_} bloblo|};
      [%expect
        {|
        ((output
          ((Txt  "blabla\
                \nblibli ")
           (reference ((f.ml (2 7) (2 14)) ref_)) (Txt " bloblo")))
         (warnings ()))|}]
    let ref_with_text =
      test {|blabla
blibli {{!ref_}replacement text} bloblo|};
      [%expect
        {|
        ((output
          ((Txt  "blabla\
                \nblibli ")
           (reference_with_text ((f.ml (2 7) (2 15)) ref_) "replacement text")
           (Txt " bloblo")))
         (warnings ()))|}]
    let simple_ref =
      test {|blabla
blibli {!ref_} bloblo|};
      [%expect
        {|
        ((output
          ((Txt  "blabla\
                \nblibli ")
           (reference ((f.ml (2 7) (2 14)) ref_)) (Txt " bloblo")))
         (warnings ()))|}]
    let simple_ref =
      test {|blabla
blibli {!ref_} bloblo|};
      [%expect
        {|
        ((output
          ((Txt  "blabla\
                \nblibli ")
           (reference ((f.ml (2 7) (2 14)) ref_)) (Txt " bloblo")))
         (warnings ()))|}]
  end in
  ()
