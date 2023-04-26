type html_and_txt = { html : Html_types.div Tyxml.Html.elt; txt : string }

type exception_entry = { (* args : html_and_txt;  *) res : html_and_txt option }

type method_entry = { private_ : bool; virtual_ : bool; type_ : html_and_txt }

type kind =
  | TypeDecl of html_and_txt
  | Module
  | Value of { type_ : html_and_txt }
  | Doc
  | Exception of exception_entry
  | Class_type (* We omit everything in classes for now *)
  | Method of method_entry
  | Class (* We omit everything in classes for now *)
  | TypeExtension (* We omit everything for now *)
  | ExtensionConstructor (* We omit everything for now *)
  | ModuleType
  | Constructor (* We omit everything for now *)
  | Field (* We omit everything for now *)
  | FunctorParameter
  | ModuleSubstitution (* We omit everything for now *)
  | ModuleTypeSubstitution
  | InstanceVariable (* We omit everything for now *)

type json_entry = {
  id : string list;
  url : string;
  doc : html_and_txt;
  kind : kind;
}

(* let json_of_representation = function *)
(*   | Some Index_db.Variant -> `String "Variant" *)
(*   | Some Record -> `String "Record" *)
(*   | Some Extensible -> `String "Extensible" *)
(*   | None -> `Null *)

(* let json_of_type te = *)
(*   let txt = Utils.text_of_type te in *)
(*   let html = Tyxml.Html.div ~a:[] (Utils.html_of_type te) in *)
(*   let html = Format.asprintf "%a" (Tyxml.Html.pp_elt ()) html in *)
(*   `Object [ ("html", `String html); ("txt", `String txt) ] *)

(* let json_of_class_decl _cl = _ *)

(* let json_of_manifest _ = `String "" *)
(* let json_of_args _ = `String "" *)
(* let json_of_res _ = `String "" *)
(* let json_of_expr _ = `String "" *)
(* let json_of_type_params _ = `String "" *)
(* let json_of_doc_kind d = *)
(*   `String *)
(*     (match d with *)
(*     | Index_db.Paragraph -> "Paragraph" *)
(*     | Heading -> "Heading" *)
(*     | CodeBlock -> "CodeBlock" *)
(*     | MathBlock -> "MathBlock" *)
(*     | Verbatim -> "Verbatim") *)
(* let json_of_virtual v = `Bool v *)
(* let json_of_private v = `Bool v *)
(* let json_of_mutable v = `Bool v *)
(* let json_of_params _ = `String "" *)
(* let json_of_type_path _ = `String "" *)

let json_entry_of_entry { Index_db.id; doc; kind } =
  let url = Utils.url id in
  let id = Odoc_model.Paths.Identifier.fullname id in
  let kind =
    match kind with
    | TypeDecl type_decl ->
        let html = Utils.html_of_typedecl type_decl
        and txt = Utils.text_of_typedecl type_decl in
        TypeDecl { html; txt }
        (* Canonical and equation are not represented in JSON format *)
        (* ("type", [ ("representation", json_of_representation representation) ]) *)
    | Module -> Module
    | Value { value = _; type_ } ->
        (* Value is ignored for now *)
        let html = Utils.html_of_type type_
        and txt = Utils.text_of_type type_ in
        Value { type_ = { html; txt } }
    | Doc _ -> Doc
    | Exception { args = _; res = None } ->
        Exception { (* args;  *) res = None }
    | Exception { args = _; res = Some res } ->
        let html = Utils.html_of_type res and txt = Utils.text_of_type res in
        Exception { (* args;  *) res = Some { html; txt } }
    | Class_type _ -> Class_type
    | Method { private_; virtual_; type_ } ->
        let html = Utils.html_of_type type_
        and txt = Utils.text_of_type type_ in
        Method { private_; virtual_; type_ = { html; txt } }
    | Class _ -> Class
    | TypeExtension _ -> TypeExtension
    | ExtensionConstructor _ -> ExtensionConstructor
    | ModuleType -> ModuleType
    | Constructor _ -> Constructor
    | Field _ -> Field
    | FunctorParameter -> FunctorParameter
    | ModuleSubstitution _ -> ModuleSubstitution
    | ModuleTypeSubstitution -> ModuleTypeSubstitution
    | InstanceVariable _ -> InstanceVariable
  in
  let doc =
    let html = Utils.html_of_doc doc and txt = Utils.text_of_doc doc in
    { html; txt }
  in
  { id; url; doc; kind }

(* let html = *)
(*   `String *)
(*     (ignore doc_html; *)
(*      (\* Tyxml.render html *\) *)
(*      "") *)
(* in *)
(* let url = `String url in *)
(* (\* let url = *\) *)
(* (\*   let config = *\) *)
(* (\*     Odoc_html.Config.v ~semantic_uris:false ~indent:false ~flat:false *\) *)
(* (\*       ~open_details:false ~as_json:false ~with_search:false () *\) *)
(* (\*   in *\) *)
(* (\*   Odoc_html.Link.href ~config ~resolve:(Base "") url *\) *)
(* (\* in *\) *)
(* let doc_words = `Array (List.map (fun x -> `String x) doc_words) in *)
(* let json = *)
(*   `Object *)
(*     [ *)
(*       ("id", id); *)
(*       ("url", url); *)
(*       ("kind", kind_json); *)
(*       ("doc_words", doc_words); *)
(*       ("doc_html", html); *)
(*     ] *)
(* in *)
(* json *)

let json_of_json_entry : json_entry -> Odoc_html.Json.json =
 fun { id; url; doc; kind } ->
  let json_of_html_and_txt { txt; html } =
    let html = Format.asprintf "%a" (Tyxml.Html.pp_elt ()) html in
    `Object [ ("txt", `String txt); ("html", `String html) ]
  in
  let kind =
    match kind with
    | TypeDecl type_ ->
        `Object
          [ ("kind", `String "TypeDecl"); ("type", json_of_html_and_txt type_) ]
    | Module -> `Object [ ("kind", `String "Module") ]
    | Value { type_ } ->
        `Object
          [ ("kind", `String "Value"); ("type", json_of_html_and_txt type_) ]
    | Doc -> `Object [ ("kind", `String "Doc") ]
    | Exception { res = None } ->
        `Object [ ("kind", `String "Exception"); ("res", `Null) ]
    | Exception { res = Some res } ->
        `Object
          [ ("kind", `String "Exception"); ("res", json_of_html_and_txt res) ]
    | Class_type -> `Object [ ("kind", `String "Class_type") ]
    | Method { private_; virtual_; type_ } ->
        `Object
          [
            ("kind", `String "Method");
            ("private", `Bool private_);
            ("virtual", `Bool virtual_);
            ("type", json_of_html_and_txt type_);
          ]
    | Class -> `Object [ ("kind", `String "Class") ]
    | TypeExtension -> `Object [ ("kind", `String "Type_extension") ]
    | ExtensionConstructor ->
        `Object [ ("kind", `String "Extension_constructor") ]
    | ModuleType -> `Object [ ("kind", `String "ModuleType") ]
    | Constructor -> `Object [ ("kind", `String "Constructor") ]
    | Field -> `Object [ ("kind", `String "Field") ]
    | FunctorParameter -> `Object [ ("kind", `String "FunctorParameter") ]
    | ModuleSubstitution -> `Object [ ("kind", `String "ModuleSubstitution") ]
    | ModuleTypeSubstitution ->
        `Object [ ("kind", `String "ModuleTypeSubstitution") ]
    | InstanceVariable -> `Object [ ("kind", `String "InstanceVariable") ]
  in
  let id = `Array (List.map (fun x -> `String x) id) in
  let url = `String url in
  let doc = json_of_html_and_txt doc in
  `Object [ ("id", id); ("url", url); ("doc", doc); ("kind", kind) ]

let render_index index ppf =
  let array =
    index |> List.map json_entry_of_entry |> List.map json_of_json_entry
  in
  let json = `Array array in
  let str = Odoc_html.Json.to_string json in
  Format.fprintf ppf "%s\n" str
