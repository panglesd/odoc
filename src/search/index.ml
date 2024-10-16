open Odoc_model
open Odoc_utils

type title = Comment.link_content
type page_hierarchy = (Paths.Identifier.Page.t * title) option Tree.t
type page = { p_name : string; p_hierarchy : page_hierarchy }

type lib_hierarchies = Entry.t Tree.t list
type lib = { l_name : string; l_hierarchies : lib_hierarchies }

type t = {
  pages : page list;
  libs : lib list;
  extra : Entry.t Paths.Identifier.Hashtbl.Any.t;
      (** This extra table is used only for search. It was introduced before
          Odoc 3 *)
}
