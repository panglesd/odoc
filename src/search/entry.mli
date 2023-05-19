type doc_entry = Paragraph | Heading | CodeBlock | MathBlock | Verbatim
module Html : sig end
module Doc : sig end
module ToHtml : sig end
val entry : id:'a -> doc:'b -> extra:'c -> 'd
val entry_of_constructor : 'a -> 'b list -> 'c -> 'd
val entry_of_field : 'a -> 'b list -> 'c -> 'd
val entries_of_docs : 'a list -> 'b list
val entries_of_doc : 'a -> 'b list
val entries_of_item : 'a -> 'b
