let ( >>= ) x f = match x with Ok v -> f v | Error _ as e -> e

(** Get plain text doc-comment from a doc comment *)

let get_value x = x.Odoc_model.Location_.value

let rec string_of_doc (doc : Odoc_model.Comment.docs) =
  doc |> List.map get_value |> List.map s_of_block_element |> String.concat " "

and s_of_block_element (be : Odoc_model.Comment.block_element) =
  match be with
  | `Paragraph is -> inlines is
  | `Tag _ -> ""
  | `List (_, ls) ->
      List.map (fun x -> x |> List.map get_value |> List.map nestable) ls
      |> List.concat |> String.concat " "
  | `Heading (_, _, h) -> link_content h
  | `Modules _ -> ""
  | `Code_block (_, s) -> s |> get_value
  | `Verbatim v -> v
  | `Math_block m -> m

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

let string_of_entry { Types.id; doc } =
  Odoc_document.Url.from_identifier ~stop_before:false id >>= fun url ->
  let config =
    Odoc_html.Config.v ~semantic_uris:true ~indent:false ~flat:false
      ~open_details:false ~as_json:false ()
  in
  let url = Odoc_html.Link.href ~config ~resolve:(Base "") url in
  Ok
    (Printf.sprintf
       {|
 {
   "name": "%s",
   "url": "%s",
   %s
 },
    |}
       (Odoc_model.Paths.Identifier.name id)
       url
       (match doc with
       | None -> ""
       | Some doc ->
           Printf.sprintf {|"comment": "%s"|}
             (String.escaped
             @@ String.map (function '\n' -> ' ' | a -> a)
             @@ string_of_doc doc)))

let render_index index ppf =
  Format.fprintf ppf "var documents = [";
  List.iter
    (fun entry ->
      match string_of_entry entry with
      | Ok entry -> Format.fprintf ppf "%s" (entry ^ "\n")
      | Error _ -> ())
    index;
  Format.fprintf ppf "] ; \n \n";

  Format.fprintf ppf
    {|
  var idx = lunr(function () {
    this.ref('url')
    this.field('name')
    this.field('comment')

    documents.forEach(function (doc) {
      this.add(doc)
    }, this)
  })
  |};
  Format.fprintf ppf
    {|
  const options = { keys: ['name', 'comment'] };
  var idx_fuse = new Fuse(documents, options);

document.querySelector(".search-bar").addEventListener("input", (event) => {
    let results = idx_fuse.search(event.target.value);
    let search_result = document.querySelector(".search-result");
    search_result.innerHTML = "";
    let f = (entry) => {
        let container = document.createElement("a");
        container.style = "display:flex; margin: 10px;"
        let name = document.createElement("div");
        name.style = "padding-right: 10px;"
        name.innerText = entry.item.name;
        let comment = document.createElement("div");
        comment.innerText = entry.item.comment;
        container.href = base_url + entry.item.url;
        container.appendChild(name);
        container.appendChild(comment);
        search_result.appendChild(container);
    } ;
    results.map(f);
});

|};
  ()
