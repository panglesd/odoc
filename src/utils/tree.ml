type 'a t = { entry : 'a; children : 'a forest }
and 'a forest = 'a t list

let leaf entry = { entry; children = [] }

let rec fold_t fun_ acc { entry; children } =
  let acc = fun_ acc entry in
  fold_f fun_ acc children

and fold_f fun_ acc f = List.fold_left (fold_t fun_) acc f

let rec iter_t fun_ { entry; children } =
  let () = fun_ entry in
  iter_f fun_ children

and iter_f fun_ f = List.iter (iter_t fun_) f

let rec map_t fun_ { entry; children } =
  let entry = fun_ entry in
  let children = map_f fun_ children in
  { entry; children }

and map_f fun_ f = List.map (map_t fun_) f

let rec filter_map_t fun_ { entry; children } =
  match fun_ entry with
  | None -> None
  | Some entry ->
      let children = filter_map_f fun_ children in
      Some { entry; children }

and filter_map_f fun_ f = List.filter_map (filter_map_t fun_) f
