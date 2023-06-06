open Odoc_model.Lang.Source_info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

module Global_analysis = struct
  let rec docparent_of_path (path : Path.t) :
      Odoc_model.Paths.Path.Module.t option =
    match path with
    | Pident id ->
        let id_s = Ident.name id in
        if Ident.persistent id then Some (`Root id_s)
        else (* Some (`Dot (`Root modname, id_s)) *) None
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> docparent_of_path i

  (* Types path (for instance) cannot be just `Root _, it needs to be `Dot. An
     ocaml path to a type whose ident is persistent will always start with a
     `Dot, but the typer does not know that. So, we need this function. *)
  let rec childpath_of_path (path : Path.t) =
    match path with
    | Pident _ -> None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> childpath_of_path i

  let expr poses expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (p, _, _); exp_loc; _ } -> (
        match childpath_of_path p with
        | None -> ()
        | Some ref_ -> poses := (ValuePath ref_, pos_of_loc exp_loc) :: !poses)
    | _ -> ()

  let module_expr poses mod_expr =
    match mod_expr with
    | { Typedtree.mod_desc = Tmod_ident (p, _); mod_loc; _ } -> (
        match docparent_of_path p with
        | None -> ()
        | Some ref_ -> poses := (ModulePath ref_, pos_of_loc mod_loc) :: !poses)
    | _ -> ()

  let class_type poses cltyp =
    match cltyp with
    | { Typedtree.cltyp_desc = Tcty_constr (p, _, _); cltyp_loc; _ } -> (
        match childpath_of_path p with
        | None -> ()
        | Some p -> poses := (ClassPath p, pos_of_loc cltyp_loc) :: !poses)
    | _ -> ()

  let module_type poses mty_expr =
    match mty_expr with
    | { Typedtree.mty_desc = Tmty_ident (p, _); mty_loc; _ } -> (
        match childpath_of_path p with
        | None -> ()
        | Some p -> poses := (MtyPath p, pos_of_loc mty_loc) :: !poses)
    | _ -> ()

  let core_type poses ctyp_expr =
    match ctyp_expr with
    | { Typedtree.ctyp_desc = Ttyp_constr (p, _, _); ctyp_loc; _ } -> (
        match childpath_of_path p with
        | None -> ()
        | Some p -> poses := (TypePath p, pos_of_loc ctyp_loc) :: !poses)
    | _ -> ()
end

let of_cmt (cmt : Cmt_format.cmt_infos) =
  let ttree = cmt.cmt_annots in
  match ttree with
  | Cmt_format.Implementation structure ->
      let poses = ref [] in
      let module_expr iterator mod_expr =
        Global_analysis.module_expr poses mod_expr;
        Tast_iterator.default_iterator.module_expr iterator mod_expr
      in
      let expr iterator e =
        Global_analysis.expr poses e;
        Tast_iterator.default_iterator.expr iterator e
      in
      let typ iterator ctyp_expr =
        Global_analysis.core_type poses ctyp_expr;
        Tast_iterator.default_iterator.typ iterator ctyp_expr
      in
      let module_type iterator mty =
        Global_analysis.module_type poses mty;
        Tast_iterator.default_iterator.module_type iterator mty
      in
      let class_type iterator cl_type =
        Global_analysis.class_type poses cl_type;
        Tast_iterator.default_iterator.class_type iterator cl_type
      in
      let iterator =
        {
          Tast_iterator.default_iterator with
          expr;
          module_expr;
          typ;
          module_type;
          class_type;
        }
      in
      iterator.structure iterator structure;
      !poses
  | _ -> []
