open Astring
open Odoc_model
open Odoc_model.Names
open Or_error

let resolve_and_substitute ~resolver ~make_root input_file =
  let filename = Fs.File.to_string input_file in
  let impl =
    Odoc_loader.read_impl ~make_root (* ~parent *) ~filename
    |> Error.raise_errors_and_warnings
  in
  let env = Resolver.build_compile_env_for_impl resolver impl in
  let compiled =
    Odoc_xref2.Compile.compile_impl ~filename env impl |> Error.raise_warnings
  in
  (* [expand unit] fetches [unit] from [env] to get the expansion of local, previously
     defined, elements. We'd rather it got back the resolved bit so we rebuild an
     environment with the resolved unit.
     Note that this is bad and once rewritten expand should not fetch the unit it is
     working on. *)
  (*    let expand_env = Env.build env (`Unit resolved) in*)
  (*    let expanded = Odoc_xref2.Expand.expand (Env.expander expand_env) resolved in *)
  compiled

let root_of_implementation ~source_id ~module_name ~digest =
  let open Root in
  let result =
    let file = Odoc_file.create_impl module_name in
    let id :> Paths.Identifier.OdocId.t =
      (* Paths.Identifier.Mk.source_page (parent, source_path) *) source_id
    in
    Ok { id; file; digest }
  in
  result

let compile ~resolver ~output ~warnings_options ~source_path ~source_parent_file
    input =
  ( Odoc_file.load source_parent_file >>= fun parent ->
    let err_not_parent () =
      Error (`Msg "Specified source-parent is not a parent of the source.")
    in
    match parent.Odoc_file.content with
    | Odoc_file.Source_tree_content page -> (
        match page.Lang.SourceTree.name with
        | { Paths.Identifier.iv = `Page _; _ } as parent_id ->
            let id = Paths.Identifier.Mk.source_page (parent_id, source_path) in
            if List.exists (Paths.Identifier.equal id) page.source_children then
              Ok id
            else err_not_parent ()
        | { iv = `LeafPage _; _ } -> err_not_parent ())
    | Unit_content _ | Page_content _ | Impl_content _ ->
        Error (`Msg "Specified source-parent should be a page but is a module.")
  )
  >>= fun source_id ->
  let make_root = root_of_implementation ~source_id in
  let result =
    Error.catch_errors_and_warnings (fun () ->
        resolve_and_substitute ~resolver ~make_root input)
  in
  (* Extract warnings to write them into the output file *)
  let _, warnings = Error.unpack_warnings result in
  Error.handle_errors_and_warnings ~warnings_options result >>= fun impl ->
  Odoc_file.save_impl output ~warnings impl;
  Ok ()
