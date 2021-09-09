open Odoc_document

let render _ page = Odoc_markdown.Generator.render page

let files_of_url url = Odoc_markdown.Link.files_of_url url

let renderer = { Renderer.name = "markdown"; render; files_of_url }
