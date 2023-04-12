open Odoc_model.Lang

val compilation_unit : Compilation_unit.t -> Types.index
val aggregate_index : Types.index -> Types.index -> Types.index
val aggregate_indexes : Types.index list -> Types.index
