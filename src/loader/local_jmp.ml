#if OCAML_VERSION >= (4, 14, 0)

open Odoc_model.Lang.Source_info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

let ( let= ) m f = match m with Some x -> f x | None -> ()

module Local_analysis = struct
  let expr poses expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (Pident id, _, _); exp_loc; _ }
      when not exp_loc.loc_ghost ->
        let anchor = Ident.unique_name id in
        poses := (Occurence { anchor }, pos_of_loc exp_loc) :: !poses
    | _ -> ()
  let pat poses (type a) : a Typedtree.general_pattern -> unit = function
    | {
        pat_desc = Tpat_var (id, _stringloc) | Tpat_alias (_, id, _stringloc);
        pat_loc;
        _;
      }
      when not pat_loc.loc_ghost ->
        let uniq = Ident.unique_name id in
        poses := (Def uniq, pos_of_loc pat_loc) :: !poses
    | _ -> ()
end

module Global_analysis = struct
  let anchor_of_uid uid =
    match Uid.unpack_uid (Uid.of_shape_uid uid) with
    | Some (_, Some id) -> Some (Uid.anchor_of_id id)
    | _ -> None

  (** Generate the anchors that will be pointed to by [lookup_def]. *)
  let init poses uid_to_loc =
    Shape.Uid.Tbl.iter
      (fun uid t ->
        let= s = anchor_of_uid uid in
        poses := (Def s, pos_of_loc t) :: !poses)
      uid_to_loc

  let rec ref_of_path (path : Path.t) : Odoc_model.Paths.Reference.LabelParent.t option =
    match path with
    | Pident id ->
        if Ident.persistent id then Some (`Root (Ident.name id, `TModule))
        else None
    | Pdot (i, l) -> (
        match ref_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> ref_of_path i

  let expr poses uid_to_loc expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (p, _, value_description); exp_loc; _ }
      ->
        (
          match ref_of_path p with
          | None ->
              (* Only generate link to anchor if the uid is in the location table. *)
              let= _ = Shape.Uid.Tbl.find_opt uid_to_loc value_description.val_uid in
              let= anchor = anchor_of_uid value_description.val_uid in
              poses := (Occurence { anchor }, pos_of_loc exp_loc) :: !poses
          | Some ref_ ->
              poses := (Ref (ref_ :> Odoc_model.Paths.Reference.t), pos_of_loc exp_loc) :: !poses)
    | _ -> ()

  let rec docparent_of_path (path : Path.t) : Odoc_model.Paths.Path.Module.t option =
    match path with
    | Pident id ->
        if Ident.persistent id then Some (`Root (Ident.name id))
        else None
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> docparent_of_path i

  let modulepath_of_path path = (docparent_of_path path)

  let rec classpath_of_path (path : Path.t) =
    match path with
    | Pident _ -> None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> classpath_of_path i

  let rec mtypath_of_path (path : Path.t) =
    match path with
    | Pident _ -> None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> mtypath_of_path i

  let module_expr poses mod_expr =
    match mod_expr with
    | { Typedtree.mod_desc = Tmod_ident (p, _); mod_loc; _ }
      ->
        (
          match modulepath_of_path p with
          | None -> ()
          | Some ref_ ->
              poses := (ModulePath ref_, pos_of_loc mod_loc) :: !poses)
    | _ -> ()

  let _class_expr poses cl_expr =
    match cl_expr with
    | { Typedtree.cl_desc = Tcl_ident (p, _, _); cl_loc; _ }
      ->
        (
          match classpath_of_path p with
          | None -> ()
          | Some p -> 
              poses := (ClassPath p, pos_of_loc cl_loc) :: !poses)
    | _ -> ()

  let _modtype poses mty_expr =
    match mty_expr with
    | { Typedtree.mty_desc = Tmty_ident (p, _); mty_loc; _ }
      ->
        (
          match mtypath_of_path p with
          | None -> ()
          | Some p -> 
              poses := (MtyPath p, pos_of_loc mty_loc) :: !poses)
    | _ -> ()

  let core_type poses ctyp_expr =
    match ctyp_expr with
    | { Typedtree.ctyp_desc = Ttyp_constr (p, _, _); ctyp_loc; _ }
      ->
        (
          match mtypath_of_path p with
          | None -> ()
          | Some p ->
              poses := (TypePath p, pos_of_loc ctyp_loc) :: !poses)
    | _ -> ()
end

let of_cmt (cmt : Cmt_format.cmt_infos) =
  let ttree = cmt.cmt_annots in
  match ttree with
  | Cmt_format.Implementation structure ->
      let uid_to_loc = cmt.cmt_uid_to_loc in
      let poses = ref [] in
      Global_analysis.init poses uid_to_loc;
      let expr iterator expr =
        Local_analysis.expr poses expr;
        Global_analysis.expr poses uid_to_loc expr;
        Tast_iterator.default_iterator.expr iterator expr
      in
      let pat iterator pat =
        Local_analysis.pat poses pat;
        Tast_iterator.default_iterator.pat iterator pat
      in
      let module_expr iterator mod_expr =
        Global_analysis.module_expr poses mod_expr;
        Tast_iterator.default_iterator.module_expr iterator mod_expr
      in
      let typ iterator ctyp_expr =
        Global_analysis.core_type poses ctyp_expr;
        Tast_iterator.default_iterator.typ iterator ctyp_expr
      in
      let iterator = { Tast_iterator.default_iterator with expr; pat ; module_expr ; typ } in
      iterator.structure iterator structure;
      !poses
  | _ -> []

#else

let of_cmt _ = []

#endif
