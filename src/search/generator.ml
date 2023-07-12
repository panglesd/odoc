module Html = Tyxml.Html

open Odoc_model
open Lang
open Printf

let type_from_path : Paths.Path.Type.t -> string =
 fun path ->
  match path with
  | `Identifier (id, _) -> Paths.Identifier.name id
  | `Dot (_prefix, suffix) -> sprintf "%s" suffix
  | `Resolved _ when Paths.Path.is_hidden (path :> Paths.Path.t) -> "TODO"
  | `Resolved rp ->
      let id = Paths.Path.Resolved.identifier (rp :> Paths.Path.Resolved.t) in
      let name = Paths.Identifier.name id in
      sprintf "%s" name

let rec format_type_path ~delim (params : TypeExpr.t list) path =
  let enclose =
    match delim with `brackets -> sprintf "(%s)" | _ -> sprintf "[%s]"
  in
  match params with
  | [] -> path
  | [ param ] ->
      let args = type_expr ~needs_parentheses:true param in
      sprintf "%s %s" args path
  | params ->
      let params = List.map type_expr params in
      let args = sprintf "(%s)" (String.concat ", " params) in
      enclose @@ sprintf "%s %s" args path

and type_expr ?(needs_parentheses = false) (t : TypeExpr.t) =
  match t with
  | Var s -> sprintf "'%s" s
  | Any -> "_"
  | Alias (te, alias) ->
      let res =
        Printf.sprintf "%s as %s" (type_expr ~needs_parentheses:true te) alias
      in
      if needs_parentheses then "(" ^ res ^ ")" else res
  | Arrow (None, src, dst) ->
      let res =
        Printf.sprintf "%s -> %s"
          (type_expr ~needs_parentheses:true src)
          (type_expr dst)
      in
      if needs_parentheses then "(" ^ res ^ ")" else res
  | Arrow (Some (Label lbl), src, dst) ->
      let res =
        Printf.sprintf "%s:%s -> %s" lbl
          (type_expr ~needs_parentheses:true src)
          (type_expr dst)
      in
      if not needs_parentheses then res else "(" ^ res ^ ")"
  | Arrow (Some (Optional lbl), src, dst) ->
      let res =
        Printf.sprintf "?%s:%s -> %s" lbl
          (type_expr ~needs_parentheses:true src)
          (type_expr dst)
      in
      if not needs_parentheses then res else "(" ^ res ^ ")"
  | Tuple lst ->
      let ts = List.map (type_expr ~needs_parentheses:true) lst in
      let res = String.concat " * " ts in
      if not needs_parentheses then res else "(" ^ res ^ ")"
  | Constr (args, link) ->
      format_type_path ~delim:`parens link (type_from_path args)
  | Polymorphic_variant _ -> "{TODO Polymorphic variant}"
  | Object _ -> "{TODO Object}"
  | Class (_, _) -> "{TODO Class}"
  | Poly (_, _) -> "{TODO Poly}"
  | Package _ -> "{TODO Package}"

let display_constructor_args args =
  let open Odoc_model.Lang in
  match args with
  | TypeDecl.Constructor.Tuple args ->
      (match args with
      | _ :: _ :: _ -> Some TypeExpr.(Tuple args)
      | [ arg ] -> Some arg
      | _ -> None)
      |> Option.map type_expr
  | TypeDecl.Constructor.Record fields -> Some (Render.text_of_record fields)

let constructor_rhs ~args ~res =
  let args = display_constructor_args args in
  let res = Option.map type_expr res in
  match (args, res) with
  | None, None -> ""
  | None, Some res -> " : " ^ res
  | Some args, None -> " of " ^ args
  | Some args, Some res -> " : " ^ args ^ " -> " ^ res

let field_rhs Entry.{ mutable_ = _; type_; parent_type = _ } =
  " : " ^ type_expr type_

let typedecl_params ?(delim = `parens) params =
  let format_param { TypeDecl.desc; variance; injectivity } =
    let desc =
      match desc with TypeDecl.Any -> [ "_" ] | Var s -> [ "'"; s ]
    in
    let var_desc =
      match variance with
      | None -> desc
      | Some TypeDecl.Pos -> "+" :: desc
      | Some TypeDecl.Neg -> "-" :: desc
    in
    let final = if injectivity then "!" :: var_desc else var_desc in
    String.concat "" final
  in
  match params with
  | [] -> None
  | [ x ] -> Some (format_param x)
  | lst ->
      let params = String.concat ", " (List.map format_param lst) in
      Some
        ((match delim with `parens -> "(" | `brackets -> "[")
        ^ params
        ^ match delim with `parens -> ")" | `brackets -> "]")

let type_decl_constraint (typ, typ') =
  "constraint" ^ " " ^ type_expr typ ^ " = " ^ type_expr typ'

let typedecl_params_of_entry Entry.{ kind; _ } =
  match kind with
  | Entry.TypeDecl { txt = _; canonical = _; equation; representation = _ } ->
      typedecl_params equation.params
  | _ -> None

let typedecl_repr ~private_ (repr : TypeDecl.Representation.t) =
  let constructor ~id ~args ~res =
    let name = Comment.Identifier.name id in
    name ^ constructor_rhs ~args ~res
  in
  let private_ = if private_ then "private " else "" in
  "= " ^ private_
  ^
  match repr with
  | Extensible -> ".."
  | Variant constructors ->
      constructors
      |> List.map (fun TypeDecl.Constructor.{ id; args; res; _ } ->
             constructor ~id ~args ~res)
      |> String.concat " | "
  | Record record -> Render.text_of_record record

let typedecl_rhs Entry.{ equation; representation; _ } =
  let TypeDecl.Equation.{ private_; manifest; constraints; _ } = equation in
  let repr =
    representation
    |> Option.map (typedecl_repr ~private_)
    |> Option.value ~default:""
  in
  let manifest =
    match manifest with None -> "" | Some typ -> " = " ^ type_expr typ
  in
  let constraints =
    match constraints with
    | [] -> ""
    | _ :: _ ->
        " " ^ (constraints |> List.map type_decl_constraint |> String.concat " ")
  in
  match repr ^ manifest ^ constraints with "" -> None | r -> Some r

let constructor_rhs Entry.{ args; res } = constructor_rhs ~args ~res:(Some res)

(** Kinds *)

let kind_doc = "doc"

let kind_typedecl = "type"

let kind_module = "mod"

let kind_exception = "exn"

let kind_class_type = "class"
let kind_class = "class"

let kind_method = "meth"

let kind_extension_constructor = "cons"

let kind_module_type = "sig"

let kind_constructor = "cons"

let kind_field = "field"

let kind_value = "val"

let kind_extension = "ext"

let string_of_kind =
  let open Entry in
  function
  | Constructor _ -> kind_constructor
  | Field _ -> kind_field
  | ExtensionConstructor _ -> kind_extension_constructor
  | TypeDecl _ -> kind_typedecl
  | Module -> kind_module
  | Value _ -> kind_value
  | Exception _ -> kind_exception
  | Class_type _ -> kind_class_type
  | Method _ -> kind_method
  | Class _ -> kind_class
  | TypeExtension _ -> kind_extension
  | ModuleType -> kind_module_type
  | Doc _ -> kind_doc

let value_rhs (t : Entry.value_entry) = " : " ^ type_expr t.type_

let html_of_strings ~kind ~prefix_name ~name ~rhs ~typedecl_params ~doc =
  let open Tyxml.Html in
  let kind = code ~a:[ a_class [ "entry-kind" ] ] [ txt kind ]
  and prefix_name =
    span
      ~a:[ a_class [ "prefix-name" ] ]
      [
        txt
          ((match typedecl_params with None -> "" | Some p -> p ^ " ")
          ^ prefix_name ^ ".");
      ]
  and name = span ~a:[ a_class [ "entry-name" ] ] [ txt name ]
  and rhs =
    match rhs with
    | None -> []
    | Some rhs -> [ code ~a:[ a_class [ "entry_rhs" ] ] [ txt rhs ] ]
  in
  [
    kind;
    code ~a:[ a_class [ "entry-title" ] ] ([ prefix_name; name ] @ rhs);
    div ~a:[ a_class [ "entry-comment" ] ] [ Unsafe.data doc ];
  ]

let rhs_of_kind (entry : Entry.kind) =
  match entry with
  | TypeDecl td -> typedecl_rhs td
  | Value t -> Some (value_rhs t)
  | Constructor t | ExtensionConstructor t | Exception t ->
      Some (constructor_rhs t)
  | Field f -> Some (field_rhs f)
  | Module | Class_type _ | Method _ | Class _ | TypeExtension _ | ModuleType
  | Doc _ ->
      None

let title_of_id id =
  let fullname = Paths.Identifier.fullname id in
  let prefix_name, name =
    let rev_fullname = List.rev fullname in
    ( rev_fullname |> List.tl |> List.rev |> String.concat ".",
      List.hd rev_fullname )
  in
  (prefix_name, name)
let html_of_doc doc =
  let config =
    Odoc_html.Config.v ~search_result:true ~semantic_uris:false ~indent:false
      ~flat:false ~open_details:false ~as_json:false ()
  in
  Tyxml.Html.div ~a:[]
  @@ Odoc_html.Generator.doc ~config ~xref_base_uri:""
  @@ Odoc_document.Comment.to_ir doc

let html_string_of_doc doc =
  doc |> html_of_doc |> Format.asprintf "%a" (Html.pp_elt ())
let html_of_entry (entry : Entry.t) =
  let Entry.{ id; doc; kind } = entry in
  let rhs = rhs_of_kind kind in
  let prefix_name, name = title_of_id id in
  let doc = html_string_of_doc doc in
  let kind = string_of_kind kind in
  let typedecl_params = typedecl_params_of_entry entry in
  html_of_strings ~kind ~prefix_name ~name ~rhs ~doc ~typedecl_params

let with_html entry = Entry.{ entry; html = html_of_entry entry }