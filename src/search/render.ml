type html = Html_types.div Tyxml.Html.elt

module Of_document = struct
  (** Get plain text doc-comment from a doc comment *)

  let rec source s =
    let token = function
      | Odoc_document.Types.Source.Elt e -> inline e
      | Tag (_, t) -> source t
    in
    String.concat "" @@ List.map token s

  and inline i =
    let one o =
      match o.Odoc_document.Types.Inline.desc with
      | Text t -> t
      | Entity "#45" -> "-"
      | Entity "gt" -> ">"
      | Entity e -> "&" ^ e
      | Linebreak -> "\n"
      | Styled (_, t) -> inline t
      | Link (_, t) -> inline t
      | InternalLink { content; _ } -> inline content
      | Source s -> source s
      | Math m -> m
      | Raw_markup _ -> ""
    in
    String.concat "" @@ List.map one i

  let rec item i =
    match i with
    | Odoc_document.Types.Item.Text t -> block t
    | Heading h -> heading h
    | Declaration { content; _ } -> documented_src content
    | Include { content; _ } -> include_ content

  and block b =
    let one o =
      match o.Odoc_document.Types.Block.desc with
      | Inline i -> inline i
      | Paragraph p -> inline p
      | List (_, bl) -> String.concat "" @@ List.map block bl
      | Description d -> description d
      | Source (_, s) -> source s
      | Math m -> m
      | Verbatim v -> v
      | Raw_markup _ -> ""
| Table _ -> ""
    in
    String.concat "" @@ List.map one b

  and description d =
    let one { Odoc_document.Types.Description.key; definition; _ } =
      inline key ^ block definition
    in
    String.concat "" @@ List.map one d

  and heading { title; _ } = inline title

  and documented_src d =
    let one o =
      match o with
      | Odoc_document.Types.DocumentedSrc.Code c -> source c
      | Documented { code; _ } -> inline code
      | Nested { code; _ } -> documented_src code
      | Subpage _ -> ""
      | Alternative (Expansion { summary; _ }) -> source summary
    in
    String.concat "" @@ List.map one d

  and include_ { summary; _ } = source summary
end

module Of_comments = struct
  (** Get plain text doc-comment from a doc comment *)

  let get_value x = x.Odoc_model.Location_.value

  let rec string_of_doc (doc : Odoc_model.Comment.docs) =
    doc |> List.map get_value
    |> List.map s_of_block_element
    |> String.concat "\n"

  and s_of_block_element (be : Odoc_model.Comment.block_element) =
    match be with
    | `Paragraph (_, is) -> inlines is
    | `Tag _ -> ""
    | `List (_, ls) ->
        List.map (fun x -> x |> List.map get_value |> List.map nestable) ls
        |> List.concat |> String.concat " "
    | `Heading (_, _, h) -> inlines h
    | `Modules _ -> ""
    | `Code_block (_, _, s, _todo) -> s |> get_value
    | `Verbatim (_, v) -> v
    | `Math_block (_, m) -> m
    | `Table _ ->               (* TODO *) ""

  and nestable (n : Odoc_model.Comment.nestable_block_element) =
    s_of_block_element (n :> Odoc_model.Comment.block_element)

  and inlines is =
    is |> List.map get_value |> List.map inline |> String.concat ""

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
end

let text_of_type te =
  let te_text = Odoc_document.ML.type_expr te in
  let te_doc = Odoc_document.Codefmt.render te_text in
  Of_document.source te_doc

let text_of_doc doc = Of_comments.string_of_doc doc

let config =
  Odoc_html.Config.v ~search_result:true ~semantic_uris:false ~indent:false
    ~flat:false ~open_details:false ~as_json:false ~search_files:[] ()

let html_of_doc doc =
  Tyxml.Html.div ~a:[]
  @@ Odoc_html.Generator.doc ~config ~xref_base_uri:""
  @@ Odoc_document.Comment.to_ir doc

let url id =
  match
    Odoc_document.Url.from_identifier ~stop_before:false
      (id :> Odoc_model.Paths.Identifier.t)
  with
  | Ok url ->
      let url = Odoc_html.Link.href ~config ~resolve:(Base "") url in
      url
  | Error _ -> assert false

let text_of_record fields =
  let te_text = Odoc_document.ML.record fields in
  Of_document.documented_src te_text
let text_of_typedecl td =
  let te_text =
    Odoc_document.ML.type_decl (Odoc_model.Lang.Signature.Ordinary, td)
  in
  Of_document.item te_text
