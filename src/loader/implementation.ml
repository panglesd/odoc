(* open Odoc_model.Lang.Source_info *)

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

(* type annotations = *)
(*   | LocalDefinition of Ident.t *)
(*   | LocalValue of Ident.t *)
(*   | DefJmp of Shape.Uid.t *)

let counter =
  let c = ref 0 in
  fun () ->
    incr c;
    !c

module Analysis = struct
  open Typedtree
  open Odoc_model.Paths

  type env = Ident_env.t (* * Location.t Shape.Uid.Tbl.t *)

  let env_wrap : (Ident_env.t -> Ident_env.t) -> env -> env =
   fun f (env(* , uid_to_loc *)) -> (f env(* , uid_to_loc *))

  let get_env : env -> Ident_env.t = fun (env(* , _ *)) -> env

  let _get_uid_to_loc : (* env *) Location.t Shape.Uid.Tbl.t -> Location.t Shape.Uid.Tbl.t =
   fun ((* _,  *)uid_to_loc) -> uid_to_loc

  let rec structure env parent str =
    let env' = env_wrap (Ident_env.add_structure_tree_items parent str) env in
    List.iter (structure_item env' parent) str.str_items

  and signature env parent sg =
    let env' = env_wrap (Ident_env.add_signature_tree_items parent sg) env in
    List.iter (signature_item env' parent) sg.sig_items

  and signature_item env parent item =
    match item.sig_desc with
    | Tsig_module mb -> module_declaration env parent mb
    | Tsig_recmodule mbs -> module_declarations env parent mbs
    | Tsig_modtype mtd -> module_type_declaration env parent mtd
    | Tsig_modtypesubst mtd -> module_type_declaration env parent mtd
    | Tsig_value _ | Tsig_type _ | Tsig_typesubst _ | Tsig_typext _
    | Tsig_exception _ | Tsig_modsubst _ | Tsig_open _ | Tsig_include _
    | Tsig_class _ | Tsig_class_type _ | Tsig_attribute _ ->
        ()

  (* and type_declaration _env _parent _td = [] *)

  and module_declaration env _parent md =
    match md.md_id with
    | None -> ()
    | Some mb_id ->
        let id = Ident_env.find_module_identifier (get_env env) mb_id in
        module_type env (id :> Identifier.Signature.t) md.md_type

  and module_declarations env parent mds =
    List.iter (module_declaration env parent) mds

  and module_type_declaration env _parent mtd =
    let id = Ident_env.find_module_type (get_env env) mtd.mtd_id in
    match mtd.mtd_type with
    | None -> ()
    | Some mty -> module_type env (id :> Identifier.Signature.t) mty

  and structure_item env parent item =
    match item.str_desc with
    | Tstr_module mb -> module_binding env parent mb
    | Tstr_recmodule mbs -> module_bindings env parent mbs
    | Tstr_modtype mtd -> module_type_decl env parent mtd
    | Tstr_open _ | Tstr_value _ | Tstr_class _ | Tstr_eval _
    | Tstr_class_type _ | Tstr_include _ | Tstr_attribute _ | Tstr_primitive _
    | Tstr_type _ | Tstr_typext _ | Tstr_exception _ ->
        ()

  and module_type_decl env _parent mtd =
    let id = Ident_env.find_module_type (get_env env) mtd.mtd_id in
    match mtd.mtd_type with
    | None -> ()
    | Some mty -> module_type env (id :> Identifier.Signature.t) mty

  and module_type env (parent : Identifier.Signature.t) mty =
    match mty.mty_desc with
    | Tmty_signature sg -> signature env (parent : Identifier.Signature.t) sg
    | Tmty_with (mty, _) -> module_type env parent mty
    | Tmty_functor (_, t) -> module_type env parent t
    | Tmty_ident _ | Tmty_alias _ | Tmty_typeof _ -> ()

  and module_bindings env parent mbs = List.iter (module_binding env parent) mbs

  and module_binding env _parent mb =
    match mb.mb_id with
    | None -> ()
    | Some id ->
        let id = Ident_env.find_module_identifier (get_env env) id in
        let id = (id :> Identifier.Module.t) in
        let inner =
          match unwrap_module_expr_desc mb.mb_expr.mod_desc with
          | Tmod_ident (_p, _) -> ()
          | _ ->
              let id = (id :> Identifier.Signature.t) in
              module_expr env id mb.mb_expr
        in
        inner

  and module_expr env parent mexpr =
    match mexpr.mod_desc with
    | Tmod_ident _ -> ()
    | Tmod_structure str -> structure env parent str
    | Tmod_functor (parameter, res) ->
        let open Odoc_model.Names in
        let env =
          match parameter with
          | Unit -> env
          | Named (id_opt, _, arg) -> (
              match id_opt with
              | Some id ->
                  let env =
                    env_wrap
                      (Ident_env.add_parameter parent id
                         (ModuleName.of_ident id))
                      env
                  in
                  let id = Ident_env.find_module_identifier (get_env env) id in
                  module_type env (id :> Identifier.Signature.t) arg;
                  env
              | None -> env)
        in
        module_expr env (Odoc_model.Paths.Identifier.Mk.result parent) res
    | Tmod_constraint (me, _, constr, _) ->
        let () =
          match constr with
          | Tmodtype_implicit -> ()
          | Tmodtype_explicit mt -> module_type env parent mt
        in
        module_expr env parent me
    | _ -> ()

  and unwrap_module_expr_desc = function
    | Tmod_constraint (mexpr, _, Tmodtype_implicit, _) ->
        unwrap_module_expr_desc mexpr.mod_desc
    | desc -> desc
end

let postprocess_poses source_id poses uid_to_id uid_to_loc : Odoc_model.Lang.Source_info.infos =
  let local_def_anchors =
    List.filter_map
      (function
        | Occurrences.Global_analysis.Definition id, _ ->
            let name =
              Odoc_model.Names.LocalName.make_std
                (Printf.sprintf "local_%s_%d" (Ident.name id) (counter ()))
            in
            let identifier =
              Odoc_model.Paths.Identifier.Mk.source_location_int
                (source_id, name)
            in
            Some (id, identifier)
        | _ -> None)
      poses
  in
  let poses =
    List.map
      (function
        | Occurrences.Global_analysis.Definition id, loc ->
            ( Odoc_model.Lang.Source_info.Definition
                (List.assoc id local_def_anchors),
              loc )
        | Value ({ Odoc_model.Lang.Source_info.implementation; _ } as v), loc ->
            let implementation =
              match implementation with
              | Some (LocalValue uniq) -> (
                  match List.assoc_opt uniq local_def_anchors with
                  | Some anchor -> Some anchor
                  | None -> None)
              | Some (DefJmp x) -> (
                  match Shape.Uid.Map.find_opt x uid_to_id with
                  | Some id -> Some id
                  | None -> None)
              | None -> None
            in
            (Value { v with implementation }, loc)
        | Module m, loc -> (Module m, loc)
        | Class m, loc -> (Class m, loc)
        | ModuleType m, loc -> (ModuleType m, loc)
        | Type m, loc -> (Type m, loc)
        | Constructor m, loc -> (Constructor m, loc))
      poses
  in
  let defs =
    Shape.Uid.Map.fold
      (fun uid id acc ->
        let loc_opt = Shape.Uid.Tbl.find_opt uid_to_loc uid in
        match loc_opt with
        | Some loc ->
            (Odoc_model.Lang.Source_info.Definition id, pos_of_loc loc) :: acc
        | _ -> acc)
      uid_to_id []
  in
  defs @ poses

let anchor_of_identifier id =
  let open Odoc_document.Url in
  let open Odoc_model.Paths in
  let open Odoc_model.Names in
  let rec anchor_of_identifier acc (id : Identifier.t) =
    let continue anchor parent =
      anchor_of_identifier (anchor :: acc) (parent :> Identifier.t)
    in
    let anchor kind name =
      Printf.sprintf "%s-%s" (Anchor.string_of_kind kind) name
    in
    match id.iv with
    | `InstanceVariable (parent, name) ->
        let anchor = anchor `Val (InstanceVariableName.to_string name) in
        continue anchor parent
    | `Parameter (parent, name) as iv ->
        let arg_num =
          Identifier.FunctorParameter.functor_arg_pos { id with iv }
        in
        let kind = `Parameter arg_num in
        let anchor = anchor kind (ModuleName.to_string name) in
        continue anchor parent
    | `Module (parent, name) ->
        let anchor = anchor `Module (ModuleName.to_string name) in
        continue anchor parent
    | `SourceDir _ -> assert false
    | `ModuleType (parent, name) ->
        let anchor = anchor `ModuleType (ModuleTypeName.to_string name) in
        continue anchor parent
    | `Method (parent, name) ->
        let anchor = anchor `Method (MethodName.to_string name) in
        continue anchor parent
    | `AssetFile _ -> assert false
    | `Field (parent, name) ->
        let anchor = anchor `Field (FieldName.to_string name) in
        continue anchor parent
    | `SourceLocationMod _ -> assert false
    | `Result parent -> anchor_of_identifier acc (parent :> Identifier.t)
    | `SourceLocationInternal _ -> assert false
    | `Type (parent, name) ->
        let anchor = anchor `Type (TypeName.to_string name) in
        continue anchor parent
    | `Label _ -> assert false
    | `Exception (parent, name) ->
        let anchor = anchor `Exception (ExceptionName.to_string name) in
        continue anchor parent
    | `Class (parent, name) ->
        let anchor = anchor `Class (ClassName.to_string name) in
        continue anchor parent
    | `Page _ -> assert false
    | `LeafPage _ -> assert false
    | `CoreType _ -> assert false
    | `SourceLocation _ -> assert false
    | `ClassType (parent, name) ->
        let anchor = anchor `ClassType (ClassTypeName.to_string name) in
        continue anchor parent
    | `SourcePage _ -> assert false
    | `Value (parent, name) ->
        let anchor = anchor `Val (ValueName.to_string name) in
        continue anchor parent
    | `CoreException _ -> assert false
    | `Constructor (parent, name) ->
        let anchor = anchor `Constructor (ConstructorName.to_string name) in
        continue anchor parent
    | `Root _ ->
        (* We do not need to include the "container" root module in the anchor
           to have unique anchors. *)
        acc
    | `Extension (parent, name) ->
        let anchor = anchor `Extension (ExtensionName.to_string name) in
        continue anchor parent
  in
  anchor_of_identifier [] id |> String.concat "."

let of_cmt (source_id : Odoc_model.Paths.Identifier.SourcePage.t)
    (id : Odoc_model.Paths.Identifier.RootModule.t)
    (structure : Typedtree.structure)
    (uid_to_loc : Warnings.loc Types.Uid.Tbl.t) =
  let env = Ident_env.empty () in
  let () =
    Analysis.structure (env(* , uid_to_loc *))
      (id :> Odoc_model.Paths.Identifier.Signature.t)
      structure
    (* |> List.rev *)
    (* Information are accumulated in a list. We need to have the
       first info first in the list, to assign anchors with increasing
       numbers, so that adding some content at the end of a file does
       not modify the anchors for existing anchors. *)
  in
  let uid_to_loc_map = Shape.Uid.Tbl.to_map uid_to_loc in
  let uid_to_id : Odoc_model.Paths.Identifier.SourceLocation.t Shape.Uid.Map.t =
    Shape.Uid.Map.filter_map
      (fun uid loc ->
        if loc.Location.loc_ghost then None
        else
          let identifier = Ident_env.identifier_of_loc env loc in
          let anchor =
            match identifier with
            | Some x ->
                Some
                  (Odoc_model.Names.DefName.make_std (anchor_of_identifier x))
            | None -> (
                match uid with
                | Compilation_unit _ -> None
                | Item _ ->
                    let name =
                      Odoc_model.Names.DefName.make_std
                        (Printf.sprintf "def_%d" (counter ()))
                    in
                    Some name
                | _ -> None)
          in
          match anchor with
          | Some a ->
              Some
                (Odoc_model.Paths.Identifier.Mk.source_location (source_id, a)
                  :> Odoc_model.Paths.Identifier.SourceLocation.t)
          | None -> None)
      uid_to_loc_map
  in
  (uid_to_id, env)
(* (uid_to_id, postprocess_poses source_id vs uid_to_id uid_to_loc) *)

let read_cmt_infos source_id_opt id cmt_info ~count_occurrences =
  match Odoc_model.Compat.shape_of_cmt_infos cmt_info with
  | Some shape -> (
      let uid_to_loc = cmt_info.cmt_uid_to_loc in
      match (source_id_opt, count_occurrences, cmt_info.cmt_annots) with
      | Some source_id, _, Implementation impl ->
          let map, _env = of_cmt source_id id impl uid_to_loc in
          (* Occurrence infos are used in source rendering, for jump to
             documentation. *)
          let occ_infos = Occurrences.of_cmt uid_to_loc impl in
          let source_infos = postprocess_poses source_id occ_infos map uid_to_loc in
          (* let source_infos = List.rev_append source_infos occ_infos in *)
          ( Some (shape, map),
            Some
              {
                Odoc_model.Lang.Source_info.id = Some source_id;
                infos = source_infos;
              } )
      | None, true, Implementation _impl ->
          (* let occ_infos = Occurrences.of_cmt impl in *)
          ( None,
            Some { Odoc_model.Lang.Source_info.id = None; infos = [] } )
      | _, _, _ -> (Some (shape, Odoc_model.Compat.empty_map), None))
  | None -> (None, None)
