open Or_error

let handle_file file ~f =
  Odoc_file.load file
  |> Result.map @@ fun unit' ->
     match unit' with
     | { Odoc_file.content = Unit_content unit; _ } -> Some (f unit)
     | _ -> None

let fold_dirs ~dirs ~f ~init =
  dirs
  |> List.fold_left
       (fun acc dir ->
         acc >>= fun acc ->
         Fs.Directory.fold_files_rec_result ~ext:"odocl"
           (fun acc file ->
             file |> handle_file ~f:(f acc) >>= function
             | None -> Ok acc
             | Some acc -> Ok acc)
           acc dir)
       (Ok init)

module H = Hashtbl.Make (Odoc_model.Paths.Identifier)

let count ~dst ~warnings_options:_ directories =
  let htbl = H.create 100 in
  let f () (unit : Odoc_model.Lang.Compilation_unit.t) =
    let () =
      List.iter
        (function
          | Odoc_model.Lang.Source_info.ModulePath (`Resolved p as p'), _ ->
              let id = Odoc_model.Paths.Path.Resolved.(identifier (p :> t)) in
              let old_value =
                match H.find_opt htbl id with Some n -> n | None -> 0
              in
              if not Odoc_model.Paths.Path.(is_hidden (p' : Module.t :> t)) then
                H.replace htbl id (old_value + 1)
          | ValuePath (`Resolved p as p'), _ ->
              let id = Odoc_model.Paths.Path.Resolved.(identifier (p :> t)) in
              let old_value =
                match H.find_opt htbl id with Some n -> n | None -> 0
              in
              if not Odoc_model.Paths.Path.(is_hidden (p' : Value.t :> t)) then
                H.replace htbl id (old_value + 1)
          | ClassPath (`Resolved p as p'), _ ->
              let id = Odoc_model.Paths.Path.Resolved.(identifier (p :> t)) in
              let old_value =
                match H.find_opt htbl id with Some n -> n | None -> 0
              in
              if not Odoc_model.Paths.Path.(is_hidden (p' : ClassType.t :> t))
              then H.replace htbl id (old_value + 1)
          | MtyPath (`Resolved p as p'), _ ->
              let id = Odoc_model.Paths.Path.Resolved.(identifier (p :> t)) in
              let old_value =
                match H.find_opt htbl id with Some n -> n | None -> 0
              in
              if not Odoc_model.Paths.Path.(is_hidden (p' : ModuleType.t :> t))
              then H.replace htbl id (old_value + 1)
          | TypePath (`Resolved p as p'), _ ->
              let id = Odoc_model.Paths.Path.Resolved.(identifier (p :> t)) in
              let old_value =
                match H.find_opt htbl id with Some n -> n | None -> 0
              in
              if not Odoc_model.Paths.Path.(is_hidden (p' : Type.t :> t)) then
                H.replace htbl id (old_value + 1)
          | _ -> ())
        (match unit.source_info with None -> [] | Some i -> i.infos)
    in
    ()
  in
  fold_dirs ~dirs:directories ~f ~init:() >>= fun () ->
  Fs.Directory.mkdir_p (Fs.File.dirname dst);
  let oc = open_out_bin (Fs.File.to_string dst) in
  Marshal.to_channel oc htbl [];
  Ok ()
