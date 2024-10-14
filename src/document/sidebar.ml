open Odoc_utils
open Types

let sidebar_toc_entry id content =
  let href =
    (id :> Odoc_model.Paths.Identifier.t)
    |> Url.from_identifier ~stop_before:false
    |> Result.get_ok
  in
  let target = Target.Internal (Resolved href) in
  inline @@ Inline.Link { target; content; tooltip = None }

module Toc : sig
  type t

  val of_lang : Odoc_model.Sidebar.PageToc.t -> t

  val of_skeleton : Odoc_index.Skeleton.node -> t

  val to_sidebar : Url.Path.t -> t -> Block.t

  (* val prune : t -> Url.Path.t -> t option *)
end = struct
  type t = Item of (Url.t * Inline.one) option * t list

  module Sidebar = Odoc_model.Sidebar
  open Odoc_model.Paths

  let of_lang (dir : Sidebar.PageToc.t) =
    let rec of_lang ~parent_id ((content, index) : Sidebar.PageToc.t) =
      let title, parent_id =
        match index with
        | Some (index_id, title) ->
            (Some title, Some (index_id :> Identifier.Page.t))
        | None -> (None, (parent_id :> Identifier.Page.t option))
      in
      let entries =
        List.filter_map
          (fun id ->
            match id with
            | id, Sidebar.PageToc.Entry title ->
                (* TODO warn on non empty children order if not index page somewhere *)
                let payload =
                  let path =
                    Url.from_identifier ~stop_before:false
                      (id : Identifier.Page.t :> Identifier.t)
                    |> Result.get_ok
                  in
                  let content = Comment.link_content title in
                  Some (path, sidebar_toc_entry id content)
                in
                Some (Item (payload, []))
            | id, Sidebar.PageToc.Dir dir ->
                Some (of_lang ~parent_id:(Some id) dir))
          content
      in
      let payload =
        match (title, parent_id) with
        | None, _ | _, None -> None
        | Some title, Some parent_id ->
            let path =
              Url.from_identifier ~stop_before:false (parent_id :> Identifier.t)
              |> Result.get_ok
            in
            let content = Comment.link_content title in
            Some (path, sidebar_toc_entry parent_id content)
      in
      Item (payload, entries)
    in
    of_lang ~parent_id:None dir

  let prune url current_url =
    let rec is_prefix (url1 : Url.Path.t) (url2 : Url.Path.t) =
      if url1 = url2 then true
      else
        match url2 with
        | { parent = Some parent; _ } -> is_prefix url1 parent
        | { parent = None; _ } -> false
    in
    let parent_path (url : Url.Path.t) =
      match url with { parent = Some parent; _ } -> parent | _ -> url
    in
    let parent (url : Url.t) =
      match url with
      | { anchor = ""; page = { parent = Some parent; _ }; _ } -> parent
      | { page; _ } -> page
    in
    (* let is_comparable u1 u2 = is_prefix u1 u2 || is_prefix u2 u1 in *)
    parent_path current_url = parent url
    || is_prefix url.page current_url
    || parent url = current_url

  let rec to_sidebar (current_url : Url.Path.t) (Item (name, content)) =
    let content =
      List.filter
        (fun (Item (name, _)) ->
          match name with None -> false | Some (u, _) -> prune u current_url)
        content
    in
    let convert ((url : Url.t), b) =
      let link =
        let is_parent (url : Url.t) (current_url : Url.Path.t) =
          match url.page.parent with None -> false | Some p -> p = current_url
        in
        if url.page = current_url && String.equal url.anchor "" then
          { b with Inline.attr = [ "current_unit" ] }
        else if
          is_parent url current_url
          || ((not (String.equal url.anchor "")) && url.page = current_url)
        then { b with Inline.attr = [ "in_current_unit" ] }
        else b
      in
      Types.block @@ Inline [ link ]
    in
    let name =
      match name with
      | Some v -> convert v
      | None -> block (Block.Inline [ inline (Text "root") ])
    in
    let content =
      match content with
      | [] -> []
      | _ :: _ ->
          let content = List.map (to_sidebar current_url) content in
          [ block (Block.List (Block.Unordered, content)) ]
    in
    name :: content

  let rec of_skeleton ({ entry; children } : Odoc_index.Skeleton.node) =
    let stop_before =
      match entry.kind with
      | Module { has_expansion } -> not has_expansion
      | _ -> false
    in
    let path = Url.from_identifier ~stop_before entry.id in
    let name = Odoc_model.Paths.Identifier.name entry.id in
    let payload =
      match path with
      | Ok path ->
          let content =
            let target = Target.Internal (Resolved path) in
            inline
              (Link { target; content = [ inline (Text name) ]; tooltip = None })
          in
          Some (path, content)
      | Error _ -> None
    in
    let children =
      List.filter
        (function
          | {
              Odoc_index.Skeleton.entry =
                { kind = Module _ | Class_type _ | Class _ | ModuleType; _ };
              _;
            } ->
              true
          | _ -> false)
        children
    in
    let entries = List.map of_skeleton children in
    Item (payload, entries)
end

type pages = { name : string; pages : Toc.t }
type library = { name : string; units : Toc.t }

type t = { pages : pages list; libraries : library list }

let of_lang (v : Odoc_index.Index.t) =
  let { Odoc_index.Index.sidebar = v; index } = v in
  let pages =
    let page_hierarchy { Odoc_model.Sidebar.hierarchy_name; pages } =
      let hierarchy = Toc.of_lang pages in
      Some { name = hierarchy_name; pages = hierarchy }
    in
    Odoc_utils.List.filter_map page_hierarchy v.pages
  in
  let units =
    (* let item id = *)
    (*   let content = [ inline @@ Text (Odoc_model.Paths.Identifier.name id) ] in *)
    (*   (Url.Path.from_identifier id, sidebar_toc_entry id content) *)
    (* in *)
    (* let units = *)
    (*   List.map *)
    (*     (fun { Odoc_model.Sidebar.units; name } -> *)
    (*       let units = List.map item units in *)
    (*       { name; units }) *)
    (*     v.libraries *)
    (* in *)
    (* units *)
    List.map (fun sk -> { units = Toc.of_skeleton sk; name = "yo" }) index
  in
  { pages; libraries = units }

let to_block (sidebar : t) path =
  let { pages; libraries } = sidebar in
  let title t =
    block
      (Inline [ inline (Inline.Styled (`Bold, [ inline (Inline.Text t) ])) ])
  in
  let pages =
    Odoc_utils.List.concat_map
      ~f:(fun (p : pages) ->
        let pages = Toc.to_sidebar path p.pages in
        let pages = [ block (Block.List (Block.Unordered, [ pages ])) ] in
        let pages = [ title @@ p.name ^ "'s Pages" ] @ pages in
        pages)
      pages
  in
  let units =
    let units =
      List.map
        (fun { units; name } ->
          (* match Toc.prune units path with *)
          (* | Some units -> *)
          let units = Toc.to_sidebar path units in
          let units = [ block (Block.List (Block.Unordered, [ units ])) ] in
          let units = [ title @@ name ^ "'s Units" ] @ units in
          units
          (* | None -> [] *)
          (* [ *)
          (*   title name; *)
          (*   block (List (Block.Unordered, [ List.map render_entry units ])); *)
          (* ] *))
        libraries
    in
    let units = block (Block.List (Block.Unordered, units)) in
    [ title "Libraries"; units ]
  in
  pages @ units
