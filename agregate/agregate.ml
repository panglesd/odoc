open Bos

let get_ok = function Ok x -> x | Error _ -> assert false

let result_dir = Fpath.v "_build/default/doc/landmarks/"

type extracted_entry = {
  location : string;
  name : string;
  calls : int;
  time : float;
  sys_time : float;
  allocated_bytes : float;
}

module M = Map.Make (struct
  type t = string * string
  let compare = compare
end)

let () =
  let results = OS.Dir.contents result_dir |> get_ok in
  let results =
    List.map (fun f -> Yojson.Basic.from_file (Fpath.to_string f)) results
  in
  let results =
    List.map
      (fun json ->
        let open Yojson.Basic.Util in
        let l = member "nodes" json |> to_list in
        List.map
          (fun json ->
            {
              location = member "location" json |> to_string;
              name = member "name" json |> to_string;
              calls = member "calls" json |> to_int;
              time = member "time" json |> to_float;
              sys_time = member "sys_time" json |> to_float;
              allocated_bytes = member "allocated_bytes" json |> to_float;
            })
          l)
      results
  in
  let merge_entry a b =
    {
      a with
      calls = a.calls + b.calls;
      time = a.time +. b.time;
      sys_time = a.sys_time +. b.sys_time;
      allocated_bytes = a.allocated_bytes +. b.allocated_bytes;
    }
  in
  let agregate acc entry =
    let id = (entry.name, entry.location) in
    let entry =
      match M.find_opt id acc with
      | Some entry' -> merge_entry entry entry'
      | None -> entry
    in
    M.add id entry acc
  in
  let nodes = List.fold_left (List.fold_left agregate) M.empty results in
  let aggregated =
    nodes |> M.bindings |> List.map snd
    |> List.sort (fun a b -> Float.compare b.time a.time)
  in
  List.iter
    (fun { location; name; calls; time; sys_time; allocated_bytes } ->
      Printf.printf "%S, %S, %d, %f, %f, %f\n" location name calls time sys_time
        allocated_bytes)
    aggregated
