open Odoc_search
open Or_error

let compile ~resolver:_ ~parent:_ ~output ~warnings_options:_ dirs =
  dirs
  |> List.fold_left
       (fun acc dir ->
         acc >>= fun acc ->
         Odoc_file.load_dir dir >>= fun units -> Ok (units @ acc))
       (Ok [])
  >>= fun units ->
  let units =
    List.filter_map
      (function
        | { Odoc_file.content = Unit_content (unit, _); _ } when not unit.hidden
          ->
            Some (`Unit unit)
        | { Odoc_file.content = Page_content page; _ } -> Some (`Page page)
        | _ -> None)
      units
  in
  let indexes =
    List.map
      (function `Page p -> Index.page p | `Unit u -> Index.compilation_unit u)
      units
  in
  let index = Index_db.aggregate_indexes indexes in
  let output =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    let oc = open_out_bin (Fs.File.to_string output) in
    Format.formatter_of_out_channel oc
  in
  Ok (Odoc_search.Json_index.render_index index output)
