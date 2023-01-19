#if OCAML_VERSION >= (4, 14, 0)

open Odoc_model
open Odoc_model.Paths
open Odoc_model.Names
module Kind = Shape.Sig_component_kind

let ( >>= ) m f = match m with Some x -> f x | None -> None

type t = Shape.t

(** Project an identifier into a shape. *)
let rec shape_of_id lookup_shape :
    [< Identifier.t_pv ] Identifier.id -> Shape.t option =
  let proj parent kind name =
    let item = Shape.Item.make name kind in
    match shape_of_id lookup_shape (parent :> Identifier.t) with
    | Some shape -> Some (Shape.proj shape item)
    | None -> None
  in
  fun id ->
    match id.iv with
    | `Root (_, name) ->
        lookup_shape (ModuleName.to_string name) >>= fun (_, shape) ->
        Some shape
    | `Module (parent, name) ->
        proj parent Kind.Module (ModuleName.to_string name)
    | `Result parent ->
        (* Apply the functor to an empty signature. This doesn't seem to cause
           any problem, as the shape would stop resolve on an item inside the
           result of the function, which is what we want. *)
        shape_of_id lookup_shape (parent :> Identifier.t) >>= fun parent ->
        Some (Shape.app parent ~arg:(Shape.str Shape.Item.Map.empty))
    | `ModuleType (parent, name) ->
        proj parent Kind.Module_type (ModuleTypeName.to_string name)
    | `Type (parent, name) -> proj parent Kind.Type (TypeName.to_string name)
    | `Value (parent, name) -> proj parent Kind.Value (ValueName.to_string name)
    | `Extension (parent, name) ->
        proj parent Kind.Extension_constructor (ExtensionName.to_string name)
    | `Exception (parent, name) ->
        proj parent Kind.Extension_constructor (ExceptionName.to_string name)
    | `Class (parent, name) -> proj parent Kind.Class (ClassName.to_string name)
    | `ClassType (parent, name) ->
        proj parent Kind.Class_type (ClassTypeName.to_string name)
    | `Page _ | `LeafPage _ | `Label _ | `CoreType _ | `CoreException _
    | `Constructor _ | `Field _ | `Method _ | `InstanceVariable _ | `Parameter _
      ->
        (* Not represented in shapes. *)
        None

module MkId = Identifier.Mk

let comp_unit_of_uid = function
  | Shape.Uid.Compilation_unit s -> Some s
  | Item { comp_unit; _ } -> Some comp_unit
  | _ -> None

let lookup_def lookup_unit id =
  match shape_of_id lookup_unit id with
  | None -> None
  | Some query ->
      let module Reduce = Shape.Make_reduce (struct
        type env = unit
        let fuel = 10
        let read_unit_shape ~unit_name =
          match lookup_unit unit_name with
          | Some (_, shape) -> Some shape
          | None -> None
        let find_shape _ _ = raise Not_found
      end) in
      let result = try Some (Reduce.reduce () query) with Not_found -> None in
      result >>= fun result ->
      result.uid >>= fun uid ->
      let anchor = Uid.string_of_uid (Uid.of_shape_uid uid) in
      let anchor = { Odoc_model.Lang.Locations.anchor } in
      comp_unit_of_uid uid >>= fun unit_name ->
      lookup_unit unit_name >>= fun (unit, _) ->
      Some (unit.Lang.Compilation_unit.id, anchor)

let lookup_shape lookup_unit (shape, env, loadpath) =
  List.iter Load_path.add_dir loadpath;
  List.iter (fun x -> Load_path.add_dir ( "/home/user/panglesd-github/odoc/_build/default/"^x)) loadpath;
  let module Reduce = Shape.Make_reduce (struct
    type env = Env.t
    let fuel = 10
    let read_unit_shape ~unit_name =
      match lookup_unit unit_name with
      | Some (_, shape) -> Some shape
      | None -> None
    let find_shape env id =
      let rebuild_env env =
        try Envaux.env_of_only_summary env
        with Envaux.Error e ->
          Format.printf "Error while trying to rebuild env from summary and env %s: %a\n%!"
            (String.concat " " loadpath)
            Envaux.report_error e;
          env
      in
      (* When partial reduction is performed only the summary of the env is stored
         on the filesystem. We need to reconstitute the complete envoronment but we do it only if we need it. *)
      let env = rebuild_env env in
      Env.shape_of_path ~namespace:Shape.Sig_component_kind.Module env
        (Pident id)
  end) in
  try 
  let result = try Some (Reduce.reduce env shape) with Not_found -> None in
  result >>= fun result ->
  result.uid >>= fun uid ->
  let anchor = Uid.string_of_uid (Uid.of_shape_uid uid) in
  let anchor = { Odoc_model.Lang.Locations.anchor } in
  comp_unit_of_uid uid >>= fun unit_name ->
  lookup_unit unit_name >>= fun (unit, _) ->
  Some (unit.Lang.Compilation_unit.id, anchor) with _ -> None

let of_cmt (cmt : Cmt_format.cmt_infos) = cmt.cmt_impl_shape

#else

type t = unit

let lookup_def _ _id = None
let of_cmt _ = Some ()

#endif
