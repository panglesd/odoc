open Odoc_model.Lang
open Odoc_model.Paths
open Types

let rec unit idx t =
  let open Compilation_unit in
  let idx = content idx t.content in
  {
    Types.id = (t.id :> Identifier.Any.t);
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

and signature idx (s : Signature.t) = List.fold_left signature_item idx s.items

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
      Types.id = (m.id :> Identifier.Any.t);
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

let compilation_unit u = unit [] u

(* TODO: make it robust when agregating from multiple package, and multiple
   times the same index *)
let aggregate_index = ( @ )
let aggregate_indexes = List.concat
