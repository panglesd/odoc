open Astring
open Odoc_json_index
open Or_error
open Odoc_model

module H = Odoc_model.Paths.Identifier.Hashtbl.Any

let handle_file file ~unit ~page ~occ =
  match Fpath.basename file with
  | s when String.is_prefix ~affix:"index-" s ->
      Odoc_file.load_index file >>= fun (_sidebar, index) -> Ok (occ index)
  | _ -> (
      Odoc_file.load file >>= fun unit' ->
      match unit' with
      | { Odoc_file.content = Unit_content unit'; _ } when unit'.hidden ->
          Error (`Msg "Hidden units are ignored when generating an index")
      | { Odoc_file.content = Unit_content unit'; _ }
      (* when not unit'.hidden *) ->
          Ok (unit unit')
      | { Odoc_file.content = Page_content page'; _ } -> Ok (page page')
      | _ ->
          Error
            (`Msg
              "Only pages and unit are allowed as input when generating an \
               index"))

let parse_input_file input =
  let is_sep = function '\n' | '\r' -> true | _ -> false in
  Fs.File.read input >>= fun content ->
  let files =
    String.fields ~empty:false ~is_sep content |> List.rev_map Fs.File.of_string
  in
  Ok files

let parse_input_files input =
  List.fold_left
    (fun acc file ->
      acc >>= fun acc ->
      parse_input_file file >>= fun files -> Ok (files :: acc))
    (Ok []) input
  >>= fun files -> Ok (List.concat files)

let compile_to_json ~output ~warnings_options ~occurrences files =
  let output_channel =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    open_out_bin (Fs.File.to_string output)
  in
  let output = Format.formatter_of_out_channel output_channel in
  let print f first up =
    if not first then Format.fprintf output ",";
    f output up;
    false
  in
  Format.fprintf output "[";
  let index () =
    List.fold_left
      (fun acc file ->
        match
          handle_file
            ~unit:(print (Json_search.unit ?occurrences) acc)
            ~page:(print Json_search.page acc)
            ~occ:(print Json_search.index acc)
            file
        with
        | Ok acc -> acc
        | Error (`Msg m) ->
            Error.raise_warning ~non_fatal:true
              (Error.filename_only "%s" m (Fs.File.to_string file));
            acc)
      true files
  in
  let result = Error.catch_warnings index in
  result |> Error.handle_warnings ~warnings_options >>= fun (_ : bool) ->
  Format.fprintf output "]";
  Ok ()

let compile_to_marshall ~output ~warnings_options sidebar files =
  let final_index = H.create 10 in
  let unit u =
    Odoc_model.Fold.unit
      ~f:(fun () item ->
        let entries = Odoc_search.Entry.entries_of_item item in
        List.iter
          (fun entry -> H.add final_index entry.Odoc_search.Entry.id entry)
          entries)
      () u
  in
  let page p =
    Odoc_model.Fold.page
      ~f:(fun () item ->
        let entries = Odoc_search.Entry.entries_of_item item in
        List.iter
          (fun entry -> H.add final_index entry.Odoc_search.Entry.id entry)
          entries)
      () p
  in
  let index i = H.iter (H.add final_index) i in
  let index () =
    List.fold_left
      (fun acc file ->
        match handle_file ~unit ~page ~occ:index file with
        | Ok acc -> acc
        | Error (`Msg m) ->
            Error.raise_warning ~non_fatal:true
              (Error.filename_only "%s" m (Fs.File.to_string file));
            acc)
      () files
  in
  let result = Error.catch_warnings index in
  result |> Error.handle_warnings ~warnings_options >>= fun () ->
  Ok (Odoc_file.save_index output (sidebar, final_index))

let read_occurrences file =
  let ic = open_in_bin file in
  let htbl : Odoc_occurrences.Table.t = Marshal.from_channel ic in
  htbl

open Odoc_model.Lang.Sidebar

let build_forest (l : (_ * _ * string list) list) : forest_payload Forest.tree =
  let rec add forest path payload =
    match path with
    | [] -> (
        match forest with
        | Forest.Leaf _ ->
            (* TODO: raise warning, multiple pages at the same place *)
            Forest.Leaf payload
        | Node (None, children)
          when Odoc_model.Lang.StringMap.cardinal children = 0 ->
            Leaf payload
        | Node (_, children) ->
            (* TODO: raise warning, if payload from the node is not None:
               multiple pages at the same place *)
            Node (Some payload, children))
    | seg :: path -> (
        match forest with
        | Leaf payload ->
            Node
              ( Some payload,
                Odoc_model.Lang.StringMap.singleton seg
                  (add
                     (Node (None, Odoc_model.Lang.StringMap.empty))
                     path payload) )
        | Node (p, children) ->
            let children =
              Odoc_model.Lang.StringMap.update seg
                (function
                  | None ->
                      let child =
                        add
                          (Node (None, Odoc_model.Lang.StringMap.empty))
                          path payload
                      in
                      Some child
                  | Some forest ->
                      let child = add forest path payload in
                      Some child)
                children
              (* | [] -> _ :: acc *)
              (* | (name, _) :: _ when not (String.equal name seg) -> _ *)
              (* | (_, c) :: q -> *)
              (*     (seg, add c path payload) :: List.rev_append q acc *)
            in
            Node (p, children))
  in
  let payloads = (* List.map (fun (a, b, _) -> (a, b)) *) l in
  let path_of_id (id : Paths.Identifier.Page.t) =
    let rec path_of_id (id : Paths.Identifier.Page.t option) =
      match id with
      | None -> []
      | Some id -> (
          match id.iv with
          | `Page (parent, name) | `LeafPage (parent, name) ->
              let name = Names.PageName.to_string name in
              if String.equal name "index" then
                path_of_id (parent :> Paths.Identifier.Page.t option)
              else name :: path_of_id (parent :> Paths.Identifier.Page.t option)
          )
    in

    List.rev (path_of_id (Some id))
  in
  let (* unsorted_ *) forest =
    List.fold_left
      (fun forest ((id, _, _) as payload) ->
        let path = path_of_id id in
        add forest path payload)
      (Forest.Node (None, Odoc_model.Lang.StringMap.empty))
      payloads
  in
  (* let rec sort_subforest forest (path, order) = *)
  (*   match (path, forest) with *)
  (*   | [], Forest.Leaf _ -> *)
  (*       forest (\* TODO: warn on toc order on a non index page *\) *)
  (*   | _ :: _, Leaf _ -> assert false *)
  (*   | [], Node (_, _) -> _ *)
  (*   | p :: path, Node (_, _) -> _ *)
  (* in *)
  (* let sortings = *)
  (*   List.map (fun (id, _, sorting) -> (path_of_id id, sorting)) l *)
  (* in *)
  (* let forest = List.fold_left sort_subforest unsorted_forest sortings in *)
  forest

let compile out_format ~output ~warnings_options ~occurrences ~lib_roots
    ~page_roots ~inputs_in_file ~odocls =
  let current_dir = Fs.File.dirname output in
  parse_input_files inputs_in_file >>= fun files ->
  let files = List.rev_append odocls files in
  let occurrences =
    match occurrences with
    | None -> None
    | Some occurrences -> Some (read_occurrences (Fpath.to_string occurrences))
  in
  let resolver =
    Resolver.create ~important_digests:false ~directories:[]
      ~roots:
        (Some
           {
             page_roots;
             lib_roots;
             current_lib = None;
             current_package = None;
             current_dir;
           })
      ~open_modules:[]
  in
  (* if files = [] && then Error (`Msg "No .odocl files were included") *)
  (* else *)
  let pages =
    List.map
      (fun (page_root, _) ->
        let pages = Resolver.all_pages ~root:page_root resolver in
        (* let pages = *)
        (*   List.map *)
        (*     (fun (page_id, title) -> *)
        (*       let title = *)
        (*         match title with *)
        (*         | None -> *)
        (*             [ *)
        (*               Odoc_model.Location_.at *)
        (*                 (Odoc_model.Location_.span []) *)
        (*                 (`Word (Odoc_model.Paths.Identifier.name page_id)); *)
        (*             ] *)
        (*         | Some x -> x *)
        (*       in *)
        (*       (title, page_id)) *)
        (*     pages *)
        (* in *)
        let pages = build_forest pages in
        { page_name = page_root; pages })
      page_roots
  in
  let libraries =
    List.map
      (fun (library, _) ->
        { name = library; units = Resolver.all_units ~library resolver })
      lib_roots
  in
  let includes_rec =
    List.rev_append (List.map snd page_roots) (List.map snd lib_roots)
  in
  let files =
    List.rev_append files
      (includes_rec
      |> List.map (fun include_rec ->
             Fs.Directory.fold_files_rec ~ext:"odocl"
               (fun files file -> file :: files)
               [] include_rec)
      |> List.concat)
  in
  let content = { pages; libraries } in
  match out_format with
  | `JSON -> compile_to_json ~output ~warnings_options ~occurrences files
  | `Marshall -> compile_to_marshall ~output ~warnings_options content files
