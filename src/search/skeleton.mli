(** Skeletons are a hierarchy organized map *)

open Odoc_model.Lang

type 'a node = { entry : 'a; children : 'a node list }

val from_unit : Compilation_unit.t -> Entry.t node option

val from_page : Page.t -> Entry.t node option
