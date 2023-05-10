open Odoc_model.Lang

module Doc = Odoc_document.ML
module ToHtml = Odoc_html.Generator

type any_id = Odoc_model.Paths.Identifier.Any.t

let add t q =
  (* if Identifier.is_internal t.Index_db.id then q else *) Index_db.add t q

let add_entry ~id ~doc ~kind idx =
  let entry = { Index_db.id; kind; doc } in
  add entry idx

let rec unit idx t =
  let open Compilation_unit in
  content t.id idx t.content

and page idx t =
  let open Page in
  docs idx t.content

and content unit_id idx =
  let open Compilation_unit in
  function
  | Module m ->
      let idx = add_entry ~id:(unit_id :> any_id) ~doc:m.doc ~kind:Module idx in
      signature idx m
  | Pack _ -> idx

and signature idx (s : Signature.t) = List.fold_left signature_item idx s.items

and signature_item idx s_item =
  match s_item with
  | Signature.Module (_, m) -> module_ idx m
  | ModuleType mt -> module_type idx mt
  | ModuleSubstitution mod_subst -> module_subst idx mod_subst
  | ModuleTypeSubstitution mt_subst -> module_type_subst idx mt_subst
  | Open _ -> idx
  | Type (_, t_decl) -> type_decl idx t_decl
  | TypeSubstitution t_decl -> type_decl idx t_decl (* TODO check *)
  | TypExt te -> type_extension idx te
  | Exception exc -> exception_ idx exc
  | Value v -> value idx v
  | Class (_, cl) -> class_ idx cl
  | ClassType (_, clt) -> class_type idx clt
  | Include i -> include_ idx i
  | Comment `Stop -> idx
  | Comment (`Docs d) -> docs idx d (* TODO: do not include stopped entries *)

and docs idx d = List.fold_left doc idx d

and doc idx d =
  match d.value with
  | `Paragraph (lbl, _) ->
      add_entry ~id:(lbl :> any_id) ~doc:[ d ] ~kind:(Doc Paragraph) idx
  | `Tag _ -> idx
  | `List (_, ds) ->
      List.fold_left docs idx (ds :> Odoc_model.Comment.docs list)
  | `Heading (_, lbl, _) ->
      add_entry ~id:(lbl :> any_id) ~doc:[ d ] ~kind:(Doc Heading) idx
  | `Modules _ -> idx
  | `Code_block (lbl, _, _) ->
      add_entry ~id:(lbl :> any_id) ~doc:[ d ] ~kind:(Doc CodeBlock) idx
  | `Verbatim (lbl, _) ->
      add_entry ~id:(lbl :> any_id) ~doc:[ d ] ~kind:(Doc Verbatim) idx
  | `Math_block (lbl, _) ->
      add_entry ~id:(lbl :> any_id) ~doc:[ d ] ~kind:(Doc MathBlock) idx

and include_ idx inc =
  let idx = include_decl idx inc.decl in
  let idx = include_expansion idx inc.expansion in
  idx (* TODO *)

and include_decl idx _decl = idx (* TODO *)

and include_expansion idx expansion = signature idx expansion.content

and class_type idx ct =
  let idx =
    let kind =
      Index_db.Class_type
        { virtual_ = ct.virtual_; params = ct.params; expr = ct.expr }
    in
    add_entry ~id:(ct.id :> any_id) ~doc:ct.doc ~kind idx
  in
  let idx = class_type_expr idx ct.expr in
  match ct.expansion with None -> idx | Some cs -> class_signature idx cs

and class_type_expr idx ct_expr =
  match ct_expr with
  | ClassType.Constr (_, _) -> idx
  | ClassType.Signature cs -> class_signature idx cs

and class_signature idx ct_expr =
  List.fold_left class_signature_item idx ct_expr.items

and class_signature_item idx item =
  match item with
  | ClassSignature.Method m ->
      let kind =
        Index_db.Method
          { virtual_ = m.virtual_; private_ = m.private_; type_ = m.type_ }
      in
      add_entry ~id:(m.id :> any_id) ~doc:m.doc ~kind idx
  | ClassSignature.InstanceVariable _ -> idx
  | ClassSignature.Constraint _ -> idx
  | ClassSignature.Inherit _ -> idx
  | ClassSignature.Comment _ -> idx

and class_ idx cl =
  let idx =
    let kind =
      Index_db.Class
        { virtual_ = cl.virtual_; params = cl.params; type_ = cl.type_ }
    in
    add_entry ~id:(cl.id :> any_id) ~doc:cl.doc ~kind idx
  in
  let idx = class_decl idx cl.type_ in
  match cl.expansion with
  | None -> idx
  | Some cl_signature -> class_signature idx cl_signature

and class_decl idx cl_decl =
  match cl_decl with
  | Class.ClassType expr -> class_type_expr idx expr
  | Class.Arrow (_, _, decl) -> class_decl idx decl

and exception_ idx exc =
  let kind = Index_db.Exception { args = exc.args; res = exc.res } in
  add_entry ~id:(exc.id :> any_id) ~doc:exc.doc ~kind idx

and type_extension idx te =
  match te.constructors with
  | [] -> idx
  | c :: _ ->
      (* Type extension do not have an ID yet... we use the first constructor for the url. *)
      let idx =
        let kind =
          Index_db.TypeExtension
            {
              type_path = te.type_path;
              type_params = te.type_params;
              private_ = te.private_;
            }
        in
        add_entry ~id:(c.id :> any_id) ~doc:te.doc ~kind idx
      in
      List.fold_left extension_constructor idx te.constructors

and extension_constructor idx ext_constr =
  let kind =
    Index_db.ExtensionConstructor
      { args = ext_constr.args; res = ext_constr.res }
  in
  add_entry ~id:(ext_constr.id :> any_id) ~doc:ext_constr.doc ~kind idx

and module_subst idx _mod_subst = idx

and module_type_subst idx _mod_subst = idx

and value idx v =
  let kind = Index_db.Value { value = v.value; type_ = v.type_ } in
  add_entry ~id:(v.id :> any_id) ~doc:v.doc ~kind idx

and module_ idx m =
  let idx =
    let kind = Index_db.Module in
    add_entry ~id:(m.id :> any_id) ~doc:m.doc ~kind idx
  in
  let idx =
    match m.type_ with
    | Module.Alias (_, None) -> idx
    | Module.Alias (_, Some s_e) -> simple_expansion idx s_e
    | Module.ModuleType mte -> module_type_expr idx mte
  in
  idx

and type_decl idx td =
  let kind = Index_db.TypeDecl td in
  let idx =
    let open Odoc_model.Lang.TypeDecl in
    match td.representation with
    | None -> idx
    | Some (Representation.Variant li) ->
        List.fold_left (constructor td.id) idx li
    | Some (Representation.Record fields) ->
        List.fold_left (field td.id) idx fields
    | Some Representation.Extensible -> idx
  in
  add_entry ~id:(td.id :> any_id) ~doc:td.doc ~kind idx

and constructor id_parent idx constructor =
  let idx =
    match constructor.args with
    | TypeDecl.Constructor.Tuple _ -> idx
    | TypeDecl.Constructor.Record fields ->
        (* TODO : fix parent type *)
        List.fold_left (field id_parent) idx fields
  in
  let args = constructor.args in
  let res =
    match constructor.res with
    | Some res -> res
    | None ->
        TypeExpr.Constr
          ( `Identifier
              ((id_parent :> Odoc_model.Paths.Identifier.Path.Type.t), false),
            [] )
  in
  let kind = Index_db.Constructor { args; res } in
  add_entry ~id:(constructor.id :> any_id) ~doc:constructor.doc ~kind idx

and field id_parent idx field =
  let parent_type =
    TypeExpr.Constr
      ( `Identifier
          ((id_parent :> Odoc_model.Paths.Identifier.Path.Type.t), false),
        [] )
  in
  let kind =
    Index_db.Field
      { mutable_ = field.mutable_; type_ = field.type_; parent_type }
  in
  add_entry ~id:(field.id :> any_id) ~doc:field.doc ~kind idx

and module_type idx mt =
  let idx =
    let kind = Index_db.ModuleType in
    add_entry ~id:(mt.id :> any_id) ~doc:mt.doc ~kind idx
  in
  match mt.expr with
  | None -> idx
  | Some mt_expr -> module_type_expr idx mt_expr

and simple_expansion idx s_e =
  match s_e with
  | ModuleType.Signature sg -> signature idx sg
  | ModuleType.Functor (_, s_e) -> simple_expansion idx s_e

and module_type_expr idx mte =
  match mte with
  | ModuleType.Signature s -> signature idx s
  | Functor (fp, mt_expr) ->
      let idx = functor_parameter idx fp in
      let idx = module_type_expr idx mt_expr in
      idx
  | With { w_expansion = Some sg; _ } -> simple_expansion idx sg
  | TypeOf { t_expansion = Some sg; _ } -> simple_expansion idx sg
  | Path { p_expansion = Some sg; _ } -> simple_expansion idx sg
  | Path _ -> idx
  | With _ -> idx
  | TypeOf _ -> idx

and functor_parameter idx fp =
  match fp with
  | FunctorParameter.Unit -> idx
  | FunctorParameter.Named n -> module_type_expr idx n.expr

let compilation_unit u = unit Index_db.empty u

let page p = page Index_db.empty p
