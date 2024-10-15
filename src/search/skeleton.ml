open Odoc_model.Lang
open Odoc_model.Paths

type 'a node = { entry : 'a; children : 'a node list }

module Entry = struct
  type t = Entry.t

  let of_comp_unit (u : Compilation_unit.t) =
    let has_expansion = true in
    let doc = match u.content with Pack _ -> [] | Module m -> m.doc in
    Entry.entry ~id:u.id ~doc ~kind:(Module { has_expansion })

  let of_module (m : Module.t) =
    let has_expansion =
      match m.type_ with Alias (_, None) -> false | _ -> true
    in
    Entry.entry ~id:m.id ~doc:m.doc ~kind:(Module { has_expansion })

  let of_module_type (mt : ModuleType.t) =
    let has_expansion =
      match mt.expr with
      | Some expr -> (
          match expr with
          | Signature _ -> true
          | Functor _ -> true
          | Path { p_expansion = Some _; _ } -> true
          | With { w_expansion = Some _; _ } -> true
          | TypeOf { t_expansion = Some _; _ } -> true
          | _ -> false)
      | _ -> true
    in
    Entry.entry ~id:mt.id ~doc:mt.doc ~kind:(ModuleType { has_expansion })

  let of_type_decl (td : TypeDecl.t) =
    let kind =
      Entry.TypeDecl
        {
          canonical = td.canonical;
          equation = td.equation;
          representation = td.representation;
        }
    in
    let td_entry = Entry.entry ~id:td.id ~doc:td.doc ~kind in
    (* TODO: add [of_constructor] *)
    td_entry

  let of_exception (exc : Exception.t) =
    let res =
      match exc.res with
      | None -> TypeExpr.Constr (Odoc_model.Predefined.exn_path, [])
      | Some x -> x
    in
    let kind = Entry.Exception { args = exc.args; res } in
    Entry.entry ~id:exc.id ~doc:exc.doc ~kind

  let of_value (v : Value.t) =
    let kind = Entry.Value { value = v.value; type_ = v.type_ } in
    Entry.entry ~id:v.id ~doc:v.doc ~kind
end

let if_non_hidden id f =
  if Identifier.is_hidden (id :> Identifier.t) then [] else f ()

let entry_of_item i f =
  match Entry.entries_of_item i with [] -> [] | e :: _ -> f e

let rec unit (u : Compilation_unit.t) =
  let entry = Entry.of_comp_unit u in
  let children =
    match u.content with
    | Pack _ -> []
    | Module m -> signature (u.id :> Identifier.LabelParent.t) m
  in
  { entry; children }

and signature id (s : Signature.t) =
  List.concat_map (signature_item (id :> Identifier.LabelParent.t)) s.items

and signature_item id s_item =
  match s_item with
  | Module (_, m) -> module_ (m.id :> Identifier.LabelParent.t) m
  | ModuleType mt -> module_type (mt.id :> Identifier.LabelParent.t) mt
  | ModuleSubstitution _ -> []
  | ModuleTypeSubstitution _ -> []
  | Open _ -> []
  | Type (_, t_decl) -> type_decl t_decl
  | TypeSubstitution _ -> []
  | TypExt te -> type_extension te
  | Exception exc -> exception_ exc
  | Value v -> value v
  | Class (_, cl) -> class_ (cl.id :> Identifier.LabelParent.t) cl
  | ClassType (_, clt) -> class_type (clt.id :> Identifier.LabelParent.t) clt
  | Include i -> include_ id i
  | Comment d -> docs id d

and module_ id m =
  if_non_hidden m.id @@ fun () ->
  let entry = Entry.of_module m in
  let children =
    match m.type_ with
    | Alias (_, None) -> []
    | Alias (_, Some s_e) -> simple_expansion id s_e
    | ModuleType mte -> module_type_expr id mte
  in
  [ { entry; children } ]

and module_type id mt =
  if_non_hidden mt.id @@ fun () ->
  let entry = Entry.of_module_type mt in
  let children =
    match mt.expr with
    | None -> []
    | Some mt_expr -> module_type_expr id mt_expr
  in
  [ { entry; children } ]

and leaf id l =
  let id :> Identifier.t = id in
  let entry =
    match Entry.entries_of_item l with
    | [] ->
        {
          Entry.id;
          doc = [];
          kind =
            Method { private_ = true; virtual_ = true; type_ = TypeExpr.Any };
        }
    | a :: _ -> a
  in
  let children = [] in
  { entry; children }

and type_decl td =
  if_non_hidden td.id @@ fun () ->
  let entry = Entry.of_type_decl td in
  [ { entry; children = [] } ]

and type_extension _te = [ (* leaf te.id (Extension te) *) ]

and exception_ exc =
  if_non_hidden exc.id @@ fun () ->
  let entry = Entry.of_exception exc in
  [ { entry; children = [] } ]

and value v =
  if_non_hidden v.id @@ fun () -> (* [ leaf (v.id :> Identifier.t) (Value v) ] *)

and class_ id cl =
  if_non_hidden cl.id @@ fun () ->
  entry_of_item (Class cl) @@ fun entry ->
  let children =
    match cl.expansion with
    | None -> []
    | Some cl_signature -> class_signature id cl_signature
  in
  [ { entry; children } ]

and class_type id ct =
  (* This check is important because [is_internal] does not work on children of
     internal items. This means that if [Fold] did not make this check here,
     it would be difficult to filter for internal items afterwards. This also
     applies to the same check in functions bellow. *)
  if_non_hidden ct.id @@ fun () ->
  entry_of_item (ClassType ct) @@ fun entry ->
  let children =
    match ct.expansion with None -> [] | Some cs -> class_signature id cs
  in
  [ { entry; children } ]

and include_ id inc = signature id inc.expansion.content

and docs id d = [ leaf (id :> Identifier.t) (Doc (id, d)) ]

and simple_expansion id s_e =
  match s_e with
  | Signature sg -> signature id sg
  | Functor (p, s_e) ->
      let _extra_entries = functor_parameter p in
      simple_expansion id s_e

and module_type_expr id mte =
  match mte with
  | Signature s -> signature id s
  | Functor (fp, mt_expr) ->
      let _extra_entries = functor_parameter fp in
      module_type_expr id mt_expr
  | With { w_expansion = Some sg; _ } -> simple_expansion id sg
  | TypeOf { t_expansion = Some sg; _ } -> simple_expansion id sg
  | Path { p_expansion = Some sg; _ } -> simple_expansion id sg
  | Path { p_expansion = None; _ } -> []
  | With { w_expansion = None; _ } -> []
  | TypeOf { t_expansion = None; _ } -> []

and class_signature id ct_expr =
  List.concat_map (class_signature_item id) ct_expr.items

and class_signature_item id item =
  match item with
  | Method m -> [ leaf (m.id :> Identifier.t) (Method m) ]
  | InstanceVariable _ -> []
  | Constraint _ -> []
  | Inherit _ -> []
  | Comment d -> docs id d

and functor_parameter fp =
  match fp with
  | Unit -> []
  | Named n -> module_type_expr (n.id :> Identifier.LabelParent.t) n.expr

let from_unit u = unit u

let from_page _p = None
