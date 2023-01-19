#if OCAML_VERSION >= (4, 14, 0)

open Odoc_model.Lang.Locations
open Odoc_model.Lang.Source_code.Info

let pos_of_loc loc = (loc.Location.loc_start.pos_cnum, loc.loc_end.pos_cnum)

let string_of_uid uid = Uid.string_of_uid (Uid.of_shape_uid uid)

module Shape_analysis = struct
  let rebuild_env loadpath env =
    try Envaux.env_of_only_summary env
    with Envaux.Error e ->
      Format.printf "Error while trying to rebuild env with env %s from summary: %a\n%!"
            (String.concat " " loadpath)
        Envaux.report_error e;
      env
        | _ -> env

  module Reduce_common = struct
    type env = Env.t

    let fuel = 10

    let find_shape env id =
      Env.shape_of_path ~namespace:Shape.Sig_component_kind.Module env
        (Pident id)
  end

  module Shape_local_reduce = Shape.Make_reduce (struct
    include Reduce_common

    let read_unit_shape ~unit_name:_ = None
  end)

  (* Storing locations of values whose definitions are not exposed by the current
     compilation unit is wasteful. As a first approximation we simply look if the
     defnition's shape is part of the public shapes stored in the CMT. *)
  (* let is_exposed ~public_shapes = *)
  (*   let open Shape in *)
  (*   (\* We gather (once) the uids of all leaf in the public shapes *\) *)
  (*   let rec aux acc = function *)
  (*     | { desc = Leaf; uid = Some uid } -> Uid.Map.add uid () acc *)
  (*     | { desc = Struct map; _ } -> *)
  (*         Item.Map.fold (fun _item shape acc -> aux acc shape) map acc *)
  (*     | _ -> acc *)
  (*   in *)
  (*   let public_uids = aux Uid.Map.empty public_shapes in *)
  (*   (\* If the tested shape is a leaf we check if its uid is public *\) *)
  (*   function *)
  (*   | { desc = Leaf; uid = Some uid } -> Uid.Map.mem uid public_uids *)
  (*   | _ -> true (\* in doubt, store it *\) *)

  let register_loc acc ~loadpath ~env ~loc shape =
    (* let shape = Shape_local_reduce.weak_reduce env shape in *)
    let summary = Env.keep_only_summary env in
    acc := (Unresolved (shape, summary, loadpath), pos_of_loc loc) :: !acc

  let expr ~is_exposed ~loadpath poses { Typedtree.exp_desc; exp_env; _ } =
    match exp_desc with
    | Texp_ident (path, lid, _) -> (
        try
           (* Path.print path *)
          let env = rebuild_env loadpath exp_env in
          let shape =
            Env.shape_of_path ~namespace:Shape.Sig_component_kind.Value env path
          in
          (* Format.printf "Shape is :\n%a\n" Shape.print shape; *)
          if is_exposed shape then ();
          register_loc poses ~env ~loadpath ~loc:lid.loc shape
        with Not_found ->
          Format.printf "No shape for expr %a at %a" Path.print path
            Location.print_loc lid.loc)
    | _ -> ()

  let typ ~is_exposed ~loadpath poses { Typedtree.ctyp_desc; ctyp_env; ctyp_loc; _ } =
    match ctyp_desc with
    | Ttyp_constr (path, lid, _ctyps) -> (
        try
          let env = rebuild_env loadpath ctyp_env in
          let shape =
            Env.shape_of_path ~namespace:Shape.Sig_component_kind.Type env path
          in
          if is_exposed shape then register_loc poses ~loadpath ~env ~loc:ctyp_loc shape
        with Not_found ->
          Format.printf "No shape for type %a at %a" Path.print path
            Location.print_loc lid.loc)
    | _ -> ()
end

module Local_analysis = struct
  let expr poses expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (Pident id, _, _); exp_loc; _ }
      when not exp_loc.loc_ghost ->
        let uniq = { anchor = Ident.unique_name id } in
        poses := (Occurence uniq, pos_of_loc exp_loc) :: !poses
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
  let init poses uid_to_loc =
    Shape.Uid.Tbl.iter
      (fun uid t ->
        let s = string_of_uid uid in
        poses := (Def s, pos_of_loc t) :: !poses)
      uid_to_loc
  let expr poses uid_to_loc expr =
    match expr with
    | { Typedtree.exp_desc = Texp_ident (_, _, value_description); exp_loc; _ }
      -> (
        match Shape.Uid.Tbl.find_opt uid_to_loc value_description.val_uid with
        | None -> ()
        | Some _ ->
            let uid = { anchor = string_of_uid value_description.val_uid } in
            poses := (Occurence uid, pos_of_loc exp_loc) :: !poses)
    | _ -> ()
end

let of_cmt (cmt : Cmt_format.cmt_infos) =
  let ttree = cmt.cmt_annots in
  Load_path.init cmt.cmt_loadpath;
  List.iter (fun x -> Load_path.add_dir ( "/home/user/panglesd-github/odoc/_build/default/"^x)) cmt.cmt_loadpath;
    match ttree with
  | Cmt_format.Implementation structure ->
      let uid_to_loc = cmt.cmt_uid_to_loc in
      let poses = ref [] in
      Global_analysis.init poses uid_to_loc;
      let is_exposed _ = true in
      let expr iterator expr =
        (* Local_analysis.expr poses expr; *)
        ignore Local_analysis.expr;
        Global_analysis.expr poses uid_to_loc expr;
        Shape_analysis.expr ~is_exposed ~loadpath:cmt.cmt_loadpath poses expr;
        Tast_iterator.default_iterator.expr iterator expr
      in
      let typ iterator typ =
        Shape_analysis.typ ~is_exposed ~loadpath:cmt.cmt_loadpath poses typ;
        Tast_iterator.default_iterator.typ iterator typ
      in
      let pat iterator pat =
        (* Local_analysis.pat poses pat; *)
        ignore Local_analysis.pat;
        Tast_iterator.default_iterator.pat iterator pat
      in
      let iterator = { Tast_iterator.default_iterator with expr; pat; typ } in
      (try iterator.structure iterator structure with _ -> failwith "in iterator" );
(* Format.printf "List of collected shapes:\n"; *)
(*       List.iter (function (Unresolved (shape, _summary, _loadpath)),_ -> Format.printf "%a\n" Shape.print shape | _ -> ()) !poses; *)
      !poses
  | _ -> []

#else

let of_cmt _ = []

#endif
