open Odoc_search
open Astring
open Odoc_model
open Odoc_model.Names
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
  let index = Index_db.aggregate_indexes indexes in
  let output =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    let oc = open_out_bin (Fs.File.to_string output) in
    Format.formatter_of_out_channel oc
  in
  Ok (Fuse_js.render_index index output)

let compile ~resolver:_ ~parent:_ ~output ~warnings_options:_ dirs =
  let root_name = Compile.name_of_output ~prefix:"index-" output in
  let page_name = PageName.make_std root_name in
  let name = Odoc_model.Paths.Identifier.Mk.leaf_page (None, page_name) in
  let digest =
    Digest.string @@ String.concat @@ List.map Fs.Directory.to_string dirs
  in
  let root =
    let file = Root.Odoc_file.create_page root_name in
    { Root.id = (name :> Paths.Identifier.OdocId.t); file; digest }
  in
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
      (function
        | `Page p ->
            Format.printf "AAAAA\n%!";
            Index.page p
        | `Unit u ->
            Format.printf "BBBBB\n%!";
            Index.compilation_unit u)
      units
  in
  let index = Index_db.aggregate_indexes indexes in
  let lang = Odoc_model.Lang.Index.{ name; root; index; digest } in
  Ok (Odoc_file.save_index output root ~warnings:[] lang)

(* let output = *)
(*   Fs.Directory.mkdir_p (Fs.File.dirname output); *)
(*   let oc = open_out_bin (Fs.File.to_string output) in *)
(*   Format.formatter_of_out_channel oc *)
(* in *)
(* Ok (Fuse_js.render_index index output) *)

let generate ~output ~warnings_options:_ input =
  let output =
    Fs.Directory.mkdir_p (Fs.File.dirname output);
    let oc = open_out_bin (Fs.File.to_string output) in
    Format.formatter_of_out_channel oc
  in
  Odoc_file.load input >>= fun unit ->
  match unit.content with
  | Index_content content ->
      Odoc_search.Fuse_js.render_index content.index output;
      Ok ()
  | Source_tree_content _ -> Error (`Msg "Index expected")
  | Page_content _ -> Error (`Msg "Index expected")
  | Unit_content _ -> Error (`Msg "Index expected")
