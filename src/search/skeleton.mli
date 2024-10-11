(** Skeletons are a hierarchy organized map *)

type node = { entry : Entry.t; children : node list }

val unit : Odoc_model.Lang.Compilation_unit.t -> node option
