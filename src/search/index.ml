open Odoc_model.Lang
open Odoc_model.Paths
open Types

let add t q = if Identifier.is_internal t.id then q else t :: q

let rec unit idx t =
  let open Compilation_unit in
  let idx = content idx t.content in
  add { Types.id = (t.id :> Identifier.Any.t); doc = None } idx

and content idx =
  let open Compilation_unit in
  function
  | Module m ->
      let idx = signature idx m in
      idx
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
  | Comment _ -> idx (* TODO: do not include stopped entries *)

and include_ idx _inc = idx (* TODO *)

and class_type idx ct =
  let idx = add { id = (ct.id :> Identifier.Any.t); doc = Some ct.doc } idx in
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
      add { id = (m.id :> Identifier.Any.t); doc = Some m.doc } idx
  | ClassSignature.InstanceVariable _ -> idx
  | ClassSignature.Constraint _ -> idx
  | ClassSignature.Inherit _ -> idx
  | ClassSignature.Comment _ -> idx

and class_ idx cl =
  let idx = add { id = (cl.id :> Identifier.Any.t); doc = Some cl.doc } idx in
  let idx = class_decl idx cl.type_ in
  match cl.expansion with
  | None -> idx
  | Some cl_signature -> class_signature idx cl_signature

and class_decl idx cl_decl =
  match cl_decl with
  | Class.ClassType expr -> class_type_expr idx expr
  | Class.Arrow (_, _, decl) -> class_decl idx decl

and exception_ idx exc =
  add { id = (exc.id :> Identifier.Any.t); doc = Some exc.doc } idx

and type_extension idx te =
  match te.constructors with
  | [] -> idx
  | c :: _ ->
      let idx =
        add { id = (c.id :> Identifier.Any.t); doc = Some te.doc } idx
      in
      List.fold_left extension_constructor idx te.constructors

and extension_constructor idx ext_constr =
  add
    { id = (ext_constr.id :> Identifier.Any.t); doc = Some ext_constr.doc }
    idx

and module_subst idx _mod_subst = idx

and module_type_subst idx _mod_subst = idx

(* contacter la fourrière
              icap ? déclarer animal perdu

              ordre de malt
              magdalena

              "bons plans entre voisins du quartier"/page facebook

              paroisse saint joseph
   45.186605756550044, 5.717968307671358
*)

and value idx v = add { id = (v.id :> Identifier.Any.t); doc = Some v.doc } idx

and module_ idx m =
  let idx =
    add { Types.id = (m.id :> Identifier.Any.t); doc = Some m.doc } idx
  in
  let idx =
    match m.type_ with
    | Module.Alias (_, None) -> idx
    | Module.Alias (_, Some s_e) -> simple_expansion idx s_e
    | Module.ModuleType mte -> module_type_expr idx mte
  in
  idx

and type_decl idx td =
  add { id = (td.id :> Identifier.Any.t); doc = Some td.doc } idx

and module_type idx { id; doc; canonical = _; expr } =
  let idx = add { id = (id :> Identifier.Any.t); doc = Some doc } idx in
  match expr with None -> idx | Some mt_expr -> module_type_expr idx mt_expr

and simple_expansion idx _s_e = idx

and module_type_expr idx mte =
  match mte with
  | ModuleType.Path _ -> idx
  | ModuleType.Signature s -> signature idx s
  | ModuleType.Functor (fp, mt_expr) ->
      let idx = functor_parameter idx fp in
      let idx = module_type_expr idx mt_expr in
      idx
  | ModuleType.With _ -> idx (* TODO *)
  | ModuleType.TypeOf _ -> idx (* TODO *)

and functor_parameter idx fp =
  match fp with
  | FunctorParameter.Unit -> idx
  | FunctorParameter.Named n -> module_type_expr idx n.expr

let compilation_unit u = unit [] u

(* TODO: make it robust when agregating from multiple package, and multiple
   times the same index *)
let aggregate_index = ( @ )
let aggregate_indexes = List.concat
