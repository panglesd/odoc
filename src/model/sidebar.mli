module Id = Paths.Identifier

module PageToc : sig
  type title = Comment.link_content

  type index = Id.Page.t * title
  type t = (Id.Page.t * content) list * index option
  and content = Entry of title | Dir of t

  val of_list :
    (Id.LeafPage.t * title * Frontmatter.children_order option) list -> t
  (** Uses the convention that the [index] children passes its payload to the
      container directory to output a payload *)
end

type library = { name : string; units : Id.RootModule.t list }

type page_hierarchy = { hierarchy_name : string; pages : PageToc.t }

type t = { pages : page_hierarchy list; libraries : library list }
