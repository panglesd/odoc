type index = Types.index_entry list

(* TODO: make it robust when agregating from multiple package, and multiple
   times the same index *)
let aggregate_index = ( @ )
let aggregate_indexes = List.concat

let add a b = a :: b

let fold = List.fold_left
let iter = List.iter

let empty = []
