val render :
  config:Config.t ->
  Odoc_document.Types.Document.t ->
  Odoc_document.Renderer.page list

val doc :
  config:Config.t ->
  xref_base_uri:string ->
  Odoc_document.Types.Block.t ->
  Html_types.flow5_without_sectioning_heading_header_footer Tyxml.Html.elt list

val source : Odoc_document.Types.Source.t -> [> Html_types.div ] Tyxml.Html.elt

val items :
  Odoc_document.Types.Item.t list ->
  Html_types.flow5_without_header_footer Tyxml.Html.elt list
