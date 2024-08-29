module CPH = Odoc_model.Paths.Identifier.Hashtbl.ContainerPage
module LPH = Odoc_model.Paths.Identifier.Hashtbl.LeafPage

type page = Odoc_model.Paths.Identifier.Page.t
type leaf_page = Odoc_model.Paths.Identifier.LeafPage.t
type container_page = Odoc_model.Paths.Identifier.ContainerPage.t

module PageForest = struct
  type 'a t = { leafs : 'a LPH.t; dirs : 'a t CPH.t }

  let empty_t () = { leafs = LPH.create 10; dirs = CPH.create 10 }

  let get_parent id : container_page option =
    let id :> page = id in
    match id.iv with
    | `Page (Some parent, _) -> Some parent
    | `LeafPage (Some parent, _) -> Some parent
    | `Page (None, _) | `LeafPage (None, _) -> None

  let rec get_or_create (forest : 'a t) (id : container_page) : 'a t =
    let parent_dirs =
      match get_parent id with
      | Some parent -> get_or_create forest parent |> fun x -> x.dirs
      | None -> forest.dirs
    in
    let current_item =
      try Some (CPH.find parent_dirs id) with Not_found -> None
    in
    match current_item with
    | Some item -> item
    | None ->
        let new_ = empty_t () in
        CPH.add parent_dirs id new_;
        new_

  let rec get_leaf (forest : 'a t) (id : leaf_page) : 'a option =
    let open Odoc_utils.OptionMonad in
    let parents_leaf =
      match get_parent id with
      | Some parent -> get_dir forest parent >>= fun { leafs; _ } -> Some leafs
      | None -> Some forest.leafs
    in
    parents_leaf >>= fun leafs ->
    try Some (LPH.find leafs id) with Not_found -> None

  and get_dir (forest : 'a t) (id : container_page) : 'a t option =
    let open Odoc_utils.OptionMonad in
    let parents_dirs =
      match get_parent id with
      | Some parent -> get_dir forest parent >>= fun { dirs; _ } -> Some dirs
      | None -> Some forest.dirs
    in
    parents_dirs >>= fun dirs ->
    try Some (CPH.find dirs id) with Not_found -> None

  let add (forest : 'a t) (id : leaf_page) (payload : 'a) =
    let container =
      match get_parent id with
      | Some parent -> get_or_create forest parent
      | None -> forest
    in
    LPH.replace container.leafs id payload
end

type index_payload = {
  title : Odoc_model.Comment.link_content;
      (** 0-Title, if there is one, otherwise the identifier name *)
  children_order : Odoc_model.Paths.Identifier.Page.t list option;
      (** Order of children *)
}

module rec Sidebar : sig
  type library = {
    name : string;
    units : Odoc_model.Paths.Identifier.RootModule.t list;
  }

  type page_hierarchy = { ph_name : string; pages : index_payload PageForest.t }

  type t = { pages : page_hierarchy list; libraries : library list }
end =
  Sidebar

module rec Index : sig
  type 'a t = {
    sidebar :
      (* (\* Odoc_model.Lang.Sidebar.t *\) index_payload Forest.t *) Sidebar.t;
    index : 'a Odoc_model.Paths.Identifier.Hashtbl.Any.t;
  }
end =
  Index
