#if OCAML_VERSION >= (4, 14, 0)

open Odoc_model.Lang.Source_info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

let ( let= ) m f = match m with Some x -> f x | None -> ()

  let anchor_of_uid uid =
    match Uid.unpack_uid (Uid.of_shape_uid uid) with
    | Some (_, Some id) -> Some (Uid.anchor_of_id id)
    | _ -> None

let rebuild_env loadpath env =
  Load_path.init loadpath;
  try Envaux.env_of_only_summary env
  with Envaux.Error e ->
    Format.printf "Error while trying to rebuild env with env %s from summary: %a\n%!"
          (String.concat " " loadpath)
      Envaux.report_error e;
    env
      | _ -> env
              
module Local_analysis = struct

  let expr poses expr =
    let str = Format.asprintf "%a" Printtyp.type_expr expr.Typedtree.exp_type in
    poses := (Type str, pos_of_loc expr.exp_loc) :: !poses;
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

  let typ poses typ =
    match typ with
    | { Typedtree.ctyp_desc = Ttyp_constr (path, _, _); ctyp_loc; ctyp_env;_ }
      when not ctyp_loc.loc_ghost -> (
        try
          let env = rebuild_env ["";"/home/user/.opam/4.14.0/lib/ocaml"] ctyp_env in
          let shape = Env.shape_of_path ~namespace:Shape.Sig_component_kind.Type env path in
          (match shape.uid with
            | Some uid ->
                let= s = anchor_of_uid uid in
                poses := (Occurence { anchor = s }, pos_of_loc ctyp_loc) :: !poses
            | None -> poses := (Occurence { anchor = "No uid" }, pos_of_loc ctyp_loc) :: !poses)
        with _ ->
          poses := ((Occurence { anchor = "Not found exception" }, pos_of_loc ctyp_loc) :: !poses))
    | _ -> ()

end

module Global_analysis = struct

  (** Generate the anchors that will be pointed to by [lookup_def]. *)
  let init poses uid_to_loc =
    Shape.Uid.Tbl.iter
      (fun uid t ->
        let= s = anchor_of_uid uid in
        poses := (Def s, pos_of_loc t) :: !poses)
      uid_to_loc

  let expr poses uid_to_loc expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (_, _, value_description); exp_loc; _ }
      ->
        (* Only generate anchor if the uid is in the location table. We don't
           link to modules outside of the compilation unit. *)
        let= _ = Shape.Uid.Tbl.find_opt uid_to_loc value_description.val_uid in
        let= anchor = anchor_of_uid value_description.val_uid in
        poses := (Occurence { anchor }, pos_of_loc exp_loc) :: !poses
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
      let typ iterator typ =
        Local_analysis.typ poses typ;
        Tast_iterator.default_iterator.typ iterator typ
      in
      let pat iterator pat =
        Local_analysis.pat poses pat;
        Tast_iterator.default_iterator.pat iterator pat
      in
      let iterator = { Tast_iterator.default_iterator with expr; pat; typ } in
      iterator.structure iterator structure;
      !poses
  | _ -> []

#else

let of_cmt _ = []

#endif
