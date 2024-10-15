(** Skeletons are a hierarchy organized map *)

open Odoc_model.Lang
open Odoc_utils

val from_unit : Compilation_unit.t -> Entry.t Tree.t

val from_page : Page.t -> Entry.t Tree.t option
