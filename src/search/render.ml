type html = Html_types.div Tyxml.Html.elt
(** A module to help users of the index to manipulate its values  *)

let html_of_type te =
  let te_text = Odoc_document.ML.type_expr te in
  let te_doc = Odoc_document.Codefmt.render te_text in
  let html = Odoc_html.Generator.source te_doc in
  (html :> html)

let html_of_typedecl te =
  let te_text =
    Odoc_document.ML.type_decl (Odoc_model.Lang.Signature.Ordinary, te)
  in
  let html = Odoc_html.Generator.items [ te_text ] in
  Tyxml.Html.Unsafe.node "div" ~a:[] html (* TODO: fix unsafe *)

let config =
  Odoc_html.Config.v ~search_result:true ~semantic_uris:false ~indent:false
    ~flat:false ~open_details:false ~as_json:false ~with_search:false ()

let html_of_doc doc =
  Tyxml.Html.div ~a:[]
  @@ Odoc_html.Generator.doc ~config ~xref_base_uri:""
  @@ Odoc_document.Comment.to_ir doc

module String_of = struct
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

let text_of_type te =
  let te_text = Odoc_document.ML.type_expr te in
  let te_doc = Odoc_document.Codefmt.render te_text in
  String_of.source te_doc

let text_of_typedecl td =
  let te_text =
    Odoc_document.ML.type_decl (Odoc_model.Lang.Signature.Ordinary, td)
  in
  String_of.item te_text

let text_of_doc doc = Comments.string_of_doc doc

let url id =
  match
    Odoc_document.Url.from_identifier ~stop_before:false
      (id :> Odoc_model.Paths.Identifier.t)
  with
  | Ok url ->
      let url = Odoc_html.Link.href ~config ~resolve:(Base "") url in
      url
  | Error _ -> assert false
