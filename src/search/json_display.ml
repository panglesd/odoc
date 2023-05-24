let json_of_id x =
  `Array
    (x |> Odoc_model.Paths.Identifier.fullname
    |> List.map (fun str -> `String str))

let json_of_doc (doc : Odoc_model.Comment.docs) =
  let html = Render.html_of_doc doc in
  `String (Format.asprintf "%a" (Tyxml.Html.pp_elt ()) html)

let display_expression_rhs args res =
  let open Odoc_model.Lang in
  match res with
  | Some res -> (
      " : "
      ^
      match args with
      | TypeDecl.Constructor.Tuple args ->
          let type_ =
            match args with
            | _ :: _ :: _ -> TypeExpr.(Arrow (None, Tuple args, res))
            | [ arg ] -> TypeExpr.(Arrow (None, arg, res))
            | _ -> res
          in
          Render.text_of_type type_
      | TypeDecl.Constructor.Record fields ->
          let fields = Render.text_of_record fields in
          let res = Render.text_of_type res in
          fields ^ " -> " ^ res)
  | None -> (
      match args with
      | TypeDecl.Constructor.Tuple args -> (
          match args with
          | _ :: _ :: _ -> " of " ^ Render.text_of_type (TypeExpr.Tuple args)
          | [ arg ] -> " of " ^ Render.text_of_type arg
          | _ -> "")
      | TypeDecl.Constructor.Record fields ->
          let fields = Render.text_of_record fields in
          " of " ^ fields)
let display_constructor_type args res =
  let open Odoc_model.Lang in
  match args with
  | TypeDecl.Constructor.Tuple args ->
      let type_ =
        match args with
        | _ :: _ :: _ -> TypeExpr.(Arrow (None, Tuple args, res))
        | [ arg ] -> TypeExpr.(Arrow (None, arg, res))
        | _ -> res
      in
      Render.text_of_type type_
  | TypeDecl.Constructor.Record fields ->
      let fields = Render.text_of_record fields in
      let res = Render.text_of_type res in
      fields ^ " -> " ^ res

let of_entry ({ id; doc; extra } : Entry.t) : Odoc_html.Json.json =
  let j_url = `String (Render.url id) in
  let j_id = json_of_id id in
  let doc = json_of_doc doc in
  let kind =
    `String
      (match extra with
      | TypeDecl _ -> "type"
      | Module -> "module"
      | Value _ -> "val"
      | Doc _ -> "doc"
      | Exception _ -> "exn"
      | Class_type _ -> "class type"
      | Method _ -> "method"
      | Class _ -> "class"
      | TypeExtension _ ->
          (* TODO: include type_path and type_params *)
          "type ext"
      | ExtensionConstructor _ -> "extension constructor"
      | ModuleType -> "module type"
      | Constructor _ -> "constructor"
      | Field _ -> "field")
  in
  let rhs =
    match extra with
    | TypeDecl { canonical = _; equation = _; representation = _; txt } ->
        let segments = String.split_on_char '=' txt in
        if List.length segments > 1 then
          segments |> List.tl |> String.concat "=" |> String.trim |> ( ^ ) " = "
          |> Option.some
        else None
    | Constructor { args; res } ->
        Some (" : " ^ display_constructor_type args res)
    | Field { mutable_ = _; type_; parent_type = _ } ->
        Some (" : " ^ Render.text_of_type type_)
    | Exception { args; res } -> Some (display_expression_rhs args res)
    | Value { value = _; type_ } -> Some (" : " ^ Render.text_of_type type_)
    | Module | Doc _ | Class_type _ | Method _ | Class _ | TypeExtension _
    | ExtensionConstructor _ | ModuleType ->
        None
  in
  `Object
    ((match rhs with None -> [] | Some rhs -> [ ("rhs", `String rhs) ])
    @ [ ("id", j_id); ("url", j_url); ("kind", kind); ("doc", doc) ])
