open Or_error
open Odoc_model.Lang
open Odoc_model.Paths

type index_entry = {
  id : Odoc_model.Paths.Identifier.Any.t;
  name : string; (* description : string; *)
  doc : Odoc_model.Comment.docs option;
}

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

type index = index_entry list

let rec unit idx t =
  let open Compilation_unit in
  let idx = content idx t.content in
  {
    id = (t.id :> Identifier.Any.t);
    name = Identifier.RootModule.name t.id;
    doc = None;
  }
  :: idx

and content idx =
  let open Compilation_unit in
  function
  | Module m ->
      let idx = signature idx m in
      idx
  | Pack _ -> idx

and signature idx (s : Signature.t) =
  let idx =
    List.fold_left (fun idx item -> signature_item idx item) idx s.items
  in
  idx

and signature_item idx s_item =
  match s_item with
  | Signature.Module (_, m) -> module_ idx m
  | ModuleType mt -> module_type idx mt
  | ModuleSubstitution _mod_subst -> (* module_subst idx mod_subst *) idx
  | ModuleTypeSubstitution _mt_subst -> (* module_type_subst idx mt_subst *) idx
  | Open _ -> idx
  | Type (_, t_decl) -> type_decl idx t_decl
  | TypeSubstitution t_decl -> type_decl idx t_decl
  | TypExt _ -> idx
  | Exception _ -> idx
  | Value v -> value idx v
  | Class (_, _) -> idx
  | ClassType (_, _) -> idx
  | Include _ -> idx
  | Comment _ -> idx

and value idx v =
  {
    id = (v.id :> Identifier.Any.t);
    name = Identifier.Value.name v.id;
    doc = Some v.doc;
  }
  :: idx

and module_ idx m =
  let idx =
    {
      id = (m.id :> Identifier.Any.t);
      name = Identifier.Module.name m.id;
      doc = Some m.doc;
    }
    :: idx
  in
  let idx =
    match m.type_ with
    | Module.Alias (_, None) -> idx
    | Module.Alias (_, Some s_e) -> simple_expansion idx s_e
    | Module.ModuleType mte -> module_type_expr idx mte
  in
  idx

and type_decl idx td =
  {
    id = (td.id :> Identifier.Any.t);
    name = Identifier.Type.name td.id;
    doc = Some td.doc;
  }
  :: idx

and module_type idx mt =
  let idx =
    {
      id = (mt.id :> Identifier.Any.t);
      name = Identifier.ModuleType.name mt.id;
      doc = Some mt.doc;
    }
    :: idx
  in
  idx

and simple_expansion idx _s_e = idx

and module_type_expr idx _mte = idx

let index_compilation_unit u = unit [] u

let aggregate_index i1 i2 = i1 @ i2

let string_of_entry { id; name; doc } =
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
       name url
       (match doc with
       | None -> ""
       | Some doc ->
           Printf.sprintf {|"comment": "%s"|}
             (String.escaped
             @@ String.map (function '\n' -> ' ' | a -> a)
             @@ string_of_doc doc)))

let save_index ~output index =
  Fs.Directory.mkdir_p (Fs.File.dirname output);
  let oc = open_out_bin (Fs.File.to_string output) in
  output_string oc "var documents = [";
  List.iter
    (fun entry ->
      match string_of_entry entry with
      | Ok entry -> output_string oc (entry ^ "\n")
      | Error _ -> ())
    index;
  output_string oc "] ; \n \n";

  output_string oc
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
  output_string oc
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
  Ok ()

let index ~output ~warnings_options:_ dirs =
  ignore output;
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
  let indexes = List.map index_compilation_unit units in
  let index = List.fold_left aggregate_index [] indexes in
  save_index ~output index
