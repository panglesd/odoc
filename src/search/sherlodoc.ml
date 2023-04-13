let render_index (idx : Types.index) ppf =
  let x = Marshal.to_string idx [] in
  match Base64.encode x with
  | Ok x -> Format.fprintf ppf "%s" x
  | Error _ -> failwith "no"
