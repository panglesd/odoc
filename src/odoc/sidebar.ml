open Or_error
open Odoc_utils

let toc_to_json
    (e : (Odoc_document.Url.t * Odoc_document.Types.Inline.one) option) :
    Json.json =
  match e with
  | None -> `Null
  | Some (url, inline) ->
      let config =
        Odoc_html.Config.v ~semantic_uris:true ~indent:true ~flat:false
          ~open_details:false ~as_json:true ~remap:[] ()
      in
      let kind =
        Format.asprintf "%a" Odoc_document.Url.Anchor.pp_kind url.kind
      in
      let href =
        Odoc_html.Link.href ~config ~resolve:(Odoc_html.Link.Base "") url
      in
      let inline =
        Odoc_html.Generator.inline ~config ~xref_base_uri:"" [ inline ]
      in
      let inline =
        String.concat ""
        @@ List.map (Format.asprintf "%a" (Tyxml.Html.pp_elt ())) inline
      in
      `Object
        [
          ("url", `String href);
          ("kind", `String kind);
          ("content", `String inline);
        ]

let pages_to_json ({ name; pages } : Odoc_document.Sidebar.pages) =
  `Object
    [ ("name", `String name); ("pages", Tree.to_json_t toc_to_json pages) ]

let libs_to_json ({ name; units } : Odoc_document.Sidebar.library) =
  `Object
    [ ("name", `String name); ("pages", Tree.to_json_f toc_to_json units) ]

let sidebar_to_json ({ pages; libraries } : Odoc_document.Sidebar.t) =
  let pages = List.map pages_to_json pages in
  let libraries = List.map libs_to_json libraries in
  `Object [ ("pages", `Array pages); ("libraries", `Array libraries) ]

let compile_to_json ~output sidebar =
  let json = sidebar_to_json sidebar in
  let text = Json.to_string json in
  let output_channel =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    open_out_bin (Fs.File.to_string output)
  in
  let output = Format.formatter_of_out_channel output_channel in
  Format.fprintf output "%s" text

let generate ~marshall ~output ~warnings_options:_ ~index =
  Odoc_file.load_index index >>= fun index ->
  let sidebar = Odoc_document.Sidebar.of_lang index in
  match marshall with
  | `JSON -> Ok (compile_to_json ~output sidebar)
  | `Marshall -> Ok (Odoc_file.save_sidebar output sidebar)
