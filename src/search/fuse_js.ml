let ( >>= ) x f = match x with Ok v -> f v | Error _ as e -> e

(** Get plain text doc-comment from a doc comment *)

let get_value x = x.Odoc_model.Location_.value

let rec string_of_doc (doc : Odoc_model.Comment.docs) =
  doc |> List.map get_value |> List.map s_of_block_element |> String.concat " "

and s_of_block_element (be : Odoc_model.Comment.block_element) =
  match be with
  | `Paragraph (_, is) -> inlines is
  | `Tag _ -> ""
  | `List (_, ls) ->
      List.map (fun x -> x |> List.map get_value |> List.map nestable) ls
      |> List.concat |> String.concat " "
  | `Heading (_, _, h) -> inlines h
  | `Modules _ -> ""
  | `Code_block (_, _, s) -> s |> get_value
  | `Verbatim (_, v) -> v
  | `Math_block (_, m) -> m

and nestable (n : Odoc_model.Comment.nestable_block_element) =
  s_of_block_element (n :> Odoc_model.Comment.block_element)

and inlines is = is |> List.map get_value |> List.map inline |> String.concat ""

and inline (i : Odoc_model.Comment.inline_element) =
  match i with
  | `Code_span s -> s
  | `Word w -> w
  | `Math_span m -> m
  | `Space -> " "
  | `Reference (_, c) -> link_content c
  | `Link (_, c) -> link_content c
  | `Styled (_, b) -> inlines b
  | `Raw_markup (_, _) -> ""

and link_content l =
  l |> List.map get_value
  |> List.map non_link_inline_element
  |> String.concat ""

and non_link_inline_element (n : Odoc_model.Comment.non_link_inline_element) =
  inline (n :> Odoc_model.Comment.inline_element)

let string_of_entry { Odoc_model.Index_db.id; doc } =
  Odoc_document.Url.from_identifier ~stop_before:false id >>= fun url ->
  let config =
    Odoc_html.Config.v ~semantic_uris:true ~indent:false ~flat:false
      ~open_details:false ~as_json:false ~with_search:false ()
  in
  let name =
    match id.iv with `Label _ -> "" | _ -> Odoc_model.Paths.Identifier.name id
  in
  let prefixname = Odoc_model.Paths.Identifier.prefixname id in
  let kind =
    match id.iv with
    | `InstanceVariable _ -> "instance variable"
    | `Parameter _ -> "parameter"
    | `Module _ -> "module"
    | `ModuleType _ -> "module type"
    | `Method _ -> "method"
    | `Field _ -> "field"
    | `Result _ -> "result"
    | `Label _ -> "label"
    | `Type _ -> "type"
    | `Exception _ -> "exception"
    | `Class _ -> "class"
    | `Page _ -> "page"
    | `LeafPage _ -> "leaf page"
    | `CoreType _ -> "core type"
    | `ClassType _ -> "class type"
    | `Value _ -> "val"
    | `CoreException _ -> "core exception"
    | `Constructor _ -> "constructor"
    | `Extension _ -> "extension"
    | `Root _ -> "root"
  in
  let url = Odoc_html.Link.href ~config ~resolve:(Base "") url in
  let json =
    `Object
      [
        ("name", `String name);
        ("prefixname", `String prefixname);
        ("kind", `String kind);
        ("url", `String url);
        ( "comment",
          match doc with None -> `Null | Some c -> `String (string_of_doc c) );
      ]
  in
  Ok (Odoc_html.Json.to_string json)

let render_index index ppf =
  if not (Odoc_model.Index_db.is_empty index) then (
    Format.fprintf ppf "[";
    Odoc_model.Index_db.iter
      (fun entry ->
        match string_of_entry entry with
        | Ok entry -> Format.fprintf ppf "%s,\n" entry
        | Error _ -> ())
      index;
    Format.fprintf ppf "]")
