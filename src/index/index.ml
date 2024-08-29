module H = Hashtbl.Make (Odoc_model.Paths.Identifier.NonSrc)

type key = H.key

module Forest = struct
  type 'a t = 'a item H.t
  and 'a item = { payload : 'a option; children : 'a t }

  let empty_item () = { payload = None; children = H.create 10 }

  let get_parent (id : key) : key option =
    match id.iv with
    | `InstanceVariable (parent, _) -> Some (parent :> key)
    | `Parameter (parent, _) -> Some (parent :> key)
    | `Module (parent, _) -> Some (parent :> key)
    | `ModuleType (parent, _) -> Some (parent :> key)
    | `Method (parent, _) -> Some (parent :> key)
    (* | `AssetFile (parent, _) -> Some (parent :> key) *)
    | `Field (parent, _) -> Some (parent :> key)
    | `Type (parent, _) -> Some (parent :> key)
    | `Label (parent, _) -> Some (parent :> key)
    | `Exception (parent, _) -> Some (parent :> key)
    | `Class (parent, _) -> Some (parent :> key)
    | `Page (Some parent, _) -> Some (parent :> key)
    | `LeafPage (Some parent, _) -> Some (parent :> key)
    | `ClassType (parent, _) -> Some (parent :> key)
    | `Value (parent, _) -> Some (parent :> key)
    | `Constructor (parent, _) -> Some (parent :> key)
    | `Root (Some parent, _) -> Some (parent :> key)
    | `Extension (parent, _) -> Some (parent :> key)
    | `ExtensionDecl (parent, _, _) -> Some (parent :> key)
    | `Result parent -> Some (parent :> key)
    (* | `SourcePage (_, _) *)
    | `CoreException _ | `CoreType _ -> None
    (* | `SourceLocation (_, _) *)
    (* | `SourceLocationInternal (_, _) *)
    (* | `SourceLocationMod _ *)
    | `Page (None, _) | `Root (None, _) | `LeafPage (None, _) -> None

  let rec get_and_create (forest : 'a t) (id : key) : 'a item =
    let do_parent parent =
      let x = get_and_create forest (parent :> key) in
      let current_item =
        try Some (H.find x.children id) with Not_found -> None
      in
      match current_item with Some item -> item | None -> empty_item ()
    in
    match get_parent id with
    | Some parent -> do_parent parent
    | None -> (
        let current_item =
          try Some (H.find forest id) with Not_found -> None
        in
        match current_item with Some item -> item | None -> empty_item ())

  let rec get (forest : 'a t) (id : key) : 'a item option =
    let open Odoc_utils.OptionMonad in
    let htbl =
      match get_parent id with
      | Some parent ->
          get forest (parent :> key) >>= fun { children; _ } -> Some children
      | None -> Some forest
    in
    htbl >>= fun htbl -> try Some (H.find htbl id) with Not_found -> None

  let add (forest : 'a t) (id : key) (payload : 'a) =
    let current_item = get_and_create forest id in
    H.replace forest id { current_item with payload = Some payload }
end

type index_payload = {
  title : Odoc_model.Comment.link_content option;
      (** 0-Title, if there is one *)
  children_order : string list;  (** Order of children *)
}

module rec Sidebar : sig
  type library = {
    name : string;
    units : Odoc_model.Paths.Identifier.RootModule.t list;
  }

  type page_hierarchy = { ph_name : string; pages : index_payload Forest.t }

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
