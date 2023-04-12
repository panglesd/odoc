open Odoc_model.Paths

(* TODO: add from which opam package it comes *)
type index_entry = {
  id : Identifier.Any.t;
  doc : Odoc_model.Comment.docs option;
}

type index = index_entry list

type renderer = Format.formatter -> unit
