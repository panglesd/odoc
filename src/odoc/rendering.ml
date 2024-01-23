open Odoc_document
open Or_error

let measure f =
  let start = Unix.gettimeofday () in
  let res = f () in
  (res, Unix.gettimeofday () -. start)

let documents_of_unit ~warnings_options ~syntax ~renderer ~extra unit =
  Odoc_model.Error.catch_warnings (fun () ->
      renderer.Renderer.extra_documents ~syntax extra (CU unit))
  |> Odoc_model.Error.handle_warnings ~warnings_options
  >>= fun extra_docs ->
  Ok (Renderer.document_of_compilation_unit ~syntax unit :: extra_docs)

let documents_of_page ~warnings_options ~syntax ~renderer ~extra page =
  Odoc_model.Error.catch_warnings (fun () ->
      renderer.Renderer.extra_documents ~syntax extra (Page page))
  |> Odoc_model.Error.handle_warnings ~warnings_options
  >>= fun extra_docs -> Ok (Renderer.document_of_page ~syntax page :: extra_docs)

let documents_of_odocl ~warnings_options ~renderer ~extra ~syntax input =
  Odoc_file.load input >>= fun unit ->
  let res, time_documenting =
    measure @@ fun () ->
    match unit.content with
    | Odoc_file.Page_content odoctree ->
        documents_of_page ~warnings_options ~syntax ~renderer ~extra odoctree
    | Source_tree_content srctree ->
        Ok (Renderer.documents_of_source_tree ~syntax srctree)
    | Unit_content odoctree ->
        documents_of_unit ~warnings_options ~syntax ~renderer ~extra odoctree
  in
  res >>= fun res -> Ok (res, time_documenting)

let documents_of_input ~renderer ~extra ~resolver ~warnings_options ~syntax
    input =
  let output = Fs.File.(set_ext ".odocl" input) in
  let odocl, time_linking =
    measure @@ fun () ->
    Odoc_link.from_odoc ~resolver ~warnings_options input output
  in
  odocl >>= fun odocl ->
  let res, time_documenting =
    measure @@ fun () ->
    match odocl with
    | `Source_tree st -> Ok (Renderer.documents_of_source_tree ~syntax st)
    | `Page page -> Ok [ Renderer.document_of_page ~syntax page ]
    | `Module m ->
        documents_of_unit ~warnings_options ~syntax ~renderer ~extra m
  in
  res >>= fun res -> Ok (res, time_linking, time_documenting)

let render_document renderer ~output:root_dir ~extra_suffix ~extra doc =
  let pages = renderer.Renderer.render extra doc in
  Renderer.traverse pages ~f:(fun filename content ->
      let filename =
        match extra_suffix with
        | Some s -> Fpath.add_ext s filename
        | None -> filename
      in
      let filename = Fpath.normalize @@ Fs.File.append root_dir filename in
      let directory = Fs.File.dirname filename in
      Fs.Directory.mkdir_p directory;
      let oc = open_out (Fs.File.to_string filename) in
      let fmt = Format.formatter_of_out_channel oc in
      Format.fprintf fmt "%t@?" content;
      close_out oc)

let render_odoc ~resolver ~warnings_options ~syntax ~renderer ~output extra file
    =
  let extra_suffix = None in
  let docs =
    documents_of_input ~renderer ~extra ~resolver ~warnings_options ~syntax file
  in
  docs >>= fun (docs, time_linking, time_documenting) ->
  let (), time_rendering =
    measure @@ fun () ->
    List.iter (render_document renderer ~output ~extra_suffix ~extra) docs
  in
  Ok (time_linking, time_rendering, time_documenting)

let generate_odoc ~syntax ~warnings_options ~renderer ~output ~extra_suffix
    extra file =
  documents_of_odocl ~warnings_options ~renderer ~extra ~syntax file
  >>= fun (docs, time_documenting) ->
  let (), time_rendering =
    measure @@ fun () ->
    List.iter (render_document renderer ~output ~extra_suffix ~extra) docs
  in

  Ok (time_documenting, time_rendering)

let targets_odoc ~resolver ~warnings_options ~syntax ~renderer ~output:root_dir
    ~extra odoctree =
  let docs =
    if Fpath.get_ext odoctree = ".odoc" then
      documents_of_input ~renderer ~extra ~resolver ~warnings_options ~syntax
        odoctree
      >>= fun (d, _, _) -> Ok d
    else
      documents_of_odocl ~warnings_options ~renderer ~extra ~syntax odoctree
      >>= fun (d, _) -> Ok d
  in
  docs >>= fun docs ->
  List.iter
    (fun doc ->
      let pages = renderer.Renderer.render extra doc in
      Renderer.traverse pages ~f:(fun filename _content ->
          let filename = Fpath.normalize @@ Fs.File.append root_dir filename in
          Format.printf "%a\n" Fpath.pp filename))
    docs;
  Ok ()
