open Astring
open Odoc_model
open Odoc_model.Names
open Or_error

let compile ~resolver ~output ~warnings_options ~source ~count_occurrences input
    =
  (match source with
  | Some (parent, name) -> (
      Odoc_file.load parent >>= fun parent ->
      let err_not_parent () =
        Error (`Msg "Specified source-parent is not a parent of the source.")
      in
      match parent.Odoc_file.content with
      | Odoc_file.Source_tree_content page -> (
          match page.Lang.SourceTree.name with
          | { Paths.Identifier.iv = `Page _; _ } as parent_id ->
              let id = Paths.Identifier.Mk.source_page (parent_id, name) in
              if List.exists (Paths.Identifier.equal id) page.source_children
              then Ok (Some id)
              else err_not_parent ()
          | { iv = `LeafPage _; _ } -> err_not_parent ())
      | Unit_content _ | Odoc_file.Page_content _ ->
          Error
            (`Msg "Specified source-parent should be a page but is a module."))
  | None -> Ok None)
  >>= fun source_id_opt ->
  handle_file_ext ext >>= fun input_type ->
  let parent =
    match parent_spec with
    | Noparent -> None
    | Explicit (parent, _) -> Some parent
    | Package parent -> Some parent
  in
  let make_root = root_of_compilation_unit ~parent_spec ~hidden ~output in
  let result =
    Error.catch_errors_and_warnings (fun () ->
        resolve_and_substitute ~resolver ~make_root ~hidden ~source_id_opt
          ~cmt_filename_opt ~count_occurrences parent input input_type)
  in
  (* Extract warnings to write them into the output file *)
  let _, warnings = Error.unpack_warnings result in
  Error.handle_errors_and_warnings ~warnings_options result >>= fun unit ->
  Odoc_file.save_unit output ~warnings unit;
  Ok ()
