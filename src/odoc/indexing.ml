open Odoc_search
open Or_error

let compile ~binary ~resolver:_ ~parent:_ ~output ~warnings_options:_ dirs =
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
            Some (* `Unit  *) unit
        | { Odoc_file.content = Page_content _page; _ } ->
            (* Some (`Page page) *) None
        | _ -> None)
      units
  in
  let output_channel =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    open_out_bin (Fs.File.to_string output)
  in
  ignore binary;
  let output = Format.formatter_of_out_channel output_channel in
  let () =
    List.iter (Json_value.unit output)
      (* (function `Page p -> Index.page p | `Unit u -> Index.compilation_unit u) *)
      units
  in
  Ok ()
