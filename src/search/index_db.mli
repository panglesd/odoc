type index

val aggregate_index : index -> index -> index
val aggregate_indexes : index list -> index
val add : Types.index_entry -> index -> index

val fold : ('acc -> Types.index_entry -> 'acc) -> 'acc -> index -> 'acc
val iter : (Types.index_entry -> unit) -> index -> unit
val empty : index
