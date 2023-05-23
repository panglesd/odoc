open Odoc_model.Lang.Source_info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

module Global_analysis = struct
  type value_implementation = LocalValue of Ident.t | DefJmp of Shape.Uid.t

  type annotation =
    | Definition of Ident.t
    | Value of (Odoc_model.Paths.Path.Value.t, value_implementation) jump_to
    | Module of (Odoc_model.Paths.Path.Module.t, none) jump_to
    | ClassType of (Odoc_model.Paths.Path.ClassType.t, none) jump_to
    | ModuleType of (Odoc_model.Paths.Path.ModuleType.t, none) jump_to
    | Type of (Odoc_model.Paths.Path.Type.t, none) jump_to
    | Constructor of (Odoc_model.Paths.Path.Constructor.t, none) jump_to

  let rec docparent_of_path (path : Path.t) : _ option =
    match path with
    | Pident id
      when true
           (* see comment on last match case for the intriguing [when] clause *)
      ->
        let id_s = Ident.name id in
        if Ident.persistent id then Some (`Root id_s) else None
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (_, _) ->
        (* When resolving Path, [odoc] currently assert it contains no
           functor. So we cannot use [docparent_of_path i] *)
        None
    (* Pextra_ty *)
    | _ ->
        (* OCaml 5.1 introduced new kinds of paths, using the [Pextra_ty]
           constructor, that we do not support for now. In order to avoid cppo
           compatibility code, we use a wildcard and not the explicit
           constructor. In order to avoid the "this match case is unused"
           warning on OCaml < 5.1 we added a [when true] condition to one of the
           previous match case *)
        None

  (* Types path (for instance) cannot be just `Root _, it needs to be `Dot. An
     ocaml path to a type whose ident is persistent will always start with a
     `Dot, but the typer does not know that. So, we need this function. *)
  let childpath_of_path (path : Path.t) =
    match path with
    | Pident _ when true (* See comment above *) ->
        None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (_i, _) ->
        (* When resolving Path, [odoc] currently assert it contains no
           functor. So we cannot use [childpath_of_path i] *)
        None
    | _ -> None

  let expr uid_to_loc poses expr =
    let exp_loc = expr.Typedtree.exp_loc in
    if exp_loc.loc_ghost then ()
    else
      match expr.exp_desc with
      | Texp_ident (p, _, value_description) -> (
          let implementation =
            match
              Shape.Uid.Tbl.find_opt uid_to_loc value_description.val_uid
            with
            | Some _ -> Some (DefJmp value_description.val_uid)
            | None -> (
                match p with Pident id -> Some (LocalValue id) | _ -> None)
          in
          let documentation = childpath_of_path p in
          match (implementation, documentation) with
          | None, None -> ()
          | _ ->
              poses :=
                (Value { documentation; implementation }, pos_of_loc exp_loc)
                :: !poses)
      | Texp_construct (l, { cstr_res; _ }, _) -> (
          let desc = Compat.get_type_desc cstr_res in
          match desc with
          | Types.Tconstr (p, _, _) ->
              let implementation = None in
              let documentation =
                match childpath_of_path p with
                | None -> None
                | Some ref_ -> Some (`Dot (ref_, Longident.last l.txt))
              in
              poses :=
                ( Constructor { implementation; documentation },
                  pos_of_loc exp_loc )
                :: !poses
          | _ -> ())
      | _ -> ()

  let pat env (type a) poses : a Compat.pattern -> unit = function
    | { Typedtree.pat_desc; pat_loc; _ } when not pat_loc.loc_ghost ->
        let () =
          match Compat.get_pattern_construct_info pat_desc with
          | Some (l, cstr_res) -> (
              let desc = Compat.get_type_desc cstr_res in
              match desc with
              | Types.Tconstr (p, _, _) ->
                  let implementation = None in
                  let documentation =
                    match childpath_of_path p with
                    | None -> None
                    | Some ref_ -> Some (`Dot (ref_, Longident.last l.txt))
                  in
                  poses :=
                    ( Constructor { implementation; documentation },
                      pos_of_loc pat_loc )
                    :: !poses
              | _ -> ())
          | None -> ()
        in
        let maybe_localvalue id loc =
          match Ident_env.identifier_of_loc env loc with
          | None -> Some (Definition id, pos_of_loc loc)
          | Some _ -> None
        in
        let () =
          match pat_desc with
          | Tpat_var (id, loc) -> (
              match maybe_localvalue id loc.loc with
              | Some x -> poses := x :: !poses
              | None -> ())
          | Tpat_alias (_, id, loc) -> (
              match maybe_localvalue id loc.loc with
              | Some x -> poses := x :: !poses
              | None -> ())
          | _ -> ()
        in
        ()
    | _ -> ()

  let module_expr poses mod_expr =
    match mod_expr with
    | { Typedtree.mod_desc = Tmod_ident (p, _); mod_loc; _ }
      when not mod_loc.loc_ghost ->
        let documentation = docparent_of_path p in
        let implementation = None in
        poses :=
          (Module { implementation; documentation }, pos_of_loc mod_loc)
          :: !poses
    | _ -> ()

  let class_type poses cltyp =
    match cltyp with
    | { Typedtree.cltyp_desc = Tcty_constr (p, _, _); cltyp_loc; _ }
      when not cltyp_loc.loc_ghost ->
        let implementation = None in
        let documentation = childpath_of_path p in
        poses :=
          (ClassType { implementation; documentation }, pos_of_loc cltyp_loc)
          :: !poses
    | _ -> ()

  let module_type poses mty_expr =
    match mty_expr with
    | { Typedtree.mty_desc = Tmty_ident (p, _); mty_loc; _ }
      when not mty_loc.loc_ghost ->
        let implementation = None in
        let documentation = childpath_of_path p in
        poses :=
          (ModuleType { implementation; documentation }, pos_of_loc mty_loc)
          :: !poses
    | _ -> ()

  let core_type poses ctyp_expr =
    match ctyp_expr with
    | { Typedtree.ctyp_desc = Ttyp_constr (p, _, _); ctyp_loc; _ }
      when not ctyp_loc.loc_ghost ->
        let implementation = None in
        let documentation = childpath_of_path p in
        poses :=
          (Type { implementation; documentation }, pos_of_loc ctyp_loc)
          :: !poses
    | _ -> ()
end

let of_cmt env uid_to_loc structure =
  let poses = ref [] in
  let module_expr iterator mod_expr =
    Global_analysis.module_expr poses mod_expr;
    Compat.Tast_iterator.default_iterator.module_expr iterator mod_expr
  in
  let expr iterator e =
    Global_analysis.expr uid_to_loc poses e;
    Compat.Tast_iterator.default_iterator.expr iterator e
  in
  let pat iterator e =
    Global_analysis.pat env poses e;
    Compat.Tast_iterator.default_iterator.pat iterator e
  in
  let typ iterator ctyp_expr =
    Global_analysis.core_type poses ctyp_expr;
    Compat.Tast_iterator.default_iterator.typ iterator ctyp_expr
  in
  let module_type iterator mty =
    Global_analysis.module_type poses mty;
    Compat.Tast_iterator.default_iterator.module_type iterator mty
  in
  let class_type iterator cl_type =
    Global_analysis.class_type poses cl_type;
    Compat.Tast_iterator.default_iterator.class_type iterator cl_type
  in
  let iterator =
    {
      Compat.Tast_iterator.default_iterator with
      expr;
      pat;
      module_expr;
      typ;
      module_type;
      class_type;
    }
  in
  iterator.structure iterator structure;
  !poses
