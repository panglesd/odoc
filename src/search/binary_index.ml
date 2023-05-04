let render_index index ppf =
  let str = Marshal.to_string index [] in
  Format.fprintf ppf "%s" str
