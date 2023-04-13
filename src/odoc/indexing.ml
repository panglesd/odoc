open Odoc_search
open Or_error

let index ~output ~warnings_options:_ dirs =
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
            Some unit
        | _ -> None)
      units
  in
  let indexes = List.map Index.compilation_unit units in
  let index = Index.aggregate_indexes indexes in
  let output =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    let oc = open_out_bin (Fs.File.to_string output) in
    Format.formatter_of_out_channel oc
  in
  Ok (Sherlodoc.render_index index output)
