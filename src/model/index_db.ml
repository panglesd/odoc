(* TODO: add from which opam package it comes *)
type entry = { id : Paths.Identifier.Any.t; doc : Comment.docs option }

type index = entry list

(* TODO: make it robust when agregating from multiple package, and multiple
   times the same index *)
let aggregate_index = ( @ )
let aggregate_indexes = List.concat

let add a b = a :: b

let fold = List.fold_left
let iter = List.iter

let empty = []

let is_empty = ( = ) []
