open Odoc_model.Lang.Source_info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

module Global_analysis = struct
  let rec docparent_of_path modname (path : Path.t) :
      Odoc_model.Paths.Path.Module.t option =
    match path with
    | Pident id ->
        let id_s = Ident.name id in
        if Ident.persistent id then Some (`Root id_s)
        else Some (`Dot (`Root modname, id_s))
    | Pdot (i, l) -> (
        match docparent_of_path modname i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> docparent_of_path modname i

  let modulepath_of_path path = docparent_of_path path

  let rec classpath_of_path modname (path : Path.t) =
    match path with
    | Pident _ -> None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path modname i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> classpath_of_path modname i

  let rec mtypath_of_path modname (path : Path.t) =
    match path with
    | Pident _ -> None (* is never persistent *)
    | Pdot (i, l) -> (
        match docparent_of_path modname i with
        | None -> None
        | Some i -> Some (`Dot (i, l)))
    | Papply (i, _) -> mtypath_of_path modname i

  let module_expr modname poses mod_expr =
    match mod_expr with
    | { Typedtree.mod_desc = Tmod_ident (p, _); mod_loc; _ } -> (
        match modulepath_of_path modname p with
        | None -> ()
        | Some ref_ -> poses := (ModulePath ref_, pos_of_loc mod_loc) :: !poses)
    | _ -> ()

  let _class_expr modname poses cl_expr =
    match cl_expr with
    | { Typedtree.cl_desc = Tcl_ident (p, _, _); cl_loc; _ } -> (
        match classpath_of_path modname p with
        | None -> ()
        | Some p -> poses := (ClassPath p, pos_of_loc cl_loc) :: !poses)
    | _ -> ()

  let _modtype modname poses mty_expr =
    match mty_expr with
    | { Typedtree.mty_desc = Tmty_ident (p, _); mty_loc; _ } -> (
        match mtypath_of_path modname p with
        | None -> ()
        | Some p -> poses := (MtyPath p, pos_of_loc mty_loc) :: !poses)
    | _ -> ()

  let core_type modname poses ctyp_expr =
    match ctyp_expr with
    | { Typedtree.ctyp_desc = Ttyp_constr (p, _, _); ctyp_loc; _ } -> (
        match mtypath_of_path modname p with
        | None -> ()
        | Some p -> poses := (TypePath p, pos_of_loc ctyp_loc) :: !poses)
    | _ -> ()
end

let of_cmt (cmt : Cmt_format.cmt_infos) =
  let ttree = cmt.cmt_annots in
  match ttree with
  | Cmt_format.Implementation structure ->
      let modname = cmt.cmt_modname in
      let poses = ref [] in
      let module_expr iterator mod_expr =
        Global_analysis.module_expr modname poses mod_expr;
        Tast_iterator.default_iterator.module_expr iterator mod_expr
      in
      let typ iterator ctyp_expr =
        Global_analysis.core_type modname poses ctyp_expr;
        Tast_iterator.default_iterator.typ iterator ctyp_expr
      in
      let iterator = { Tast_iterator.default_iterator with module_expr; typ } in
      iterator.structure iterator structure;
      !poses
  | _ -> []
