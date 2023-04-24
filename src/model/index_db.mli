type entry = { id : Paths.Identifier.Any.t; doc : Comment.docs option }
type index

val aggregate_index : index -> index -> index
val aggregate_indexes : index list -> index
val add : entry -> index -> index

val fold : ('acc -> entry -> 'acc) -> 'acc -> index -> 'acc
val iter : (entry -> unit) -> index -> unit
val empty : index
val is_empty : index -> bool
