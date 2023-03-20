Astring test

  $ ocamlc -c -bin-annot astring_unsafe.ml
  $ ocamlc -c -bin-annot astring_base.ml
  $ ocamlc -c -bin-annot astring_escape.ml
  $ ocamlc -c -bin-annot astring_char.ml
  $ ocamlc -c -bin-annot astring_sub.ml
  $ ocamlc -c -bin-annot astring_string.ml
  $ ocamlc -c -bin-annot astring.mli
  $ ocamlc -c -bin-annot astring.ml

The source map is a map of where to find the source files. Here we've just got a flat hierarchy for simplicity.

  $ ls *.ml > source.map

We have two top-level parent pages - `astring` and `inaccessible`. The module `Astring` appears as a child of
the page `astring`. Modules that aren't visible to OCaml (because their cmi file is not installed) are under
`inaccessible`. The source tree will also appear under the `astring` page.

  $ odoc compile astring.mld --child src-source --child module-Astring
  $ odoc compile inaccessible.mld --child module-Astring_unsafe --child module-Astring_base --child module-Astring_escape --child module-Astring_char --child module-Astring_sub --child module-Astring_string

Generate the source map first.
  $ odoc source-tree source.map -I . --parent page-astring

For all inaccessible modules, make sure their parent is `page-inaccessible`. We need to compile this to allow linking to
their corresponding source.
  $ odoc compile astring_unsafe.cmt --source-parent src-source.odoc --source-name astring_unsafe.ml -I . --parent page-inaccessible
  $ odoc compile astring_base.cmt --source-parent src-source.odoc --source-name astring_base.ml -I . --parent page-inaccessible
  $ odoc compile astring_escape.cmt --source-parent src-source.odoc --source-name astring_escape.ml -I . --parent page-inaccessible
  $ odoc compile astring_char.cmt --source-parent src-source.odoc --source-name astring_char.ml -I . --parent page-inaccessible
  $ odoc compile astring_sub.cmt --source-parent src-source.odoc --source-name astring_sub.ml -I . --parent page-inaccessible
  $ odoc compile astring_string.cmt --source-parent src-source.odoc --source-name astring_string.ml -I . --parent page-inaccessible

The one exposed module is `Astring`, whose parent is `page-astring`.
  $ odoc compile astring.cmti --source-parent src-source.odoc --source-name astring.ml --parent page-astring -I .

Link the main pages and exposed module, but not the 'source-only' odoc files.
  $ odoc link -I . page-inaccessible.odoc
  $ odoc link -I . page-astring.odoc
  $ odoc link -I . astring.odoc
  $ odoc link -I . src-source.odoc

Generate the output for the linked pages
  $ odoc html-generate page-astring.odocl -o html
  $ odoc html-generate page-inaccessible.odocl -o html

Generate the output for the exposed module:
  $ odoc html-generate astring.odocl --source astring.ml -o html

Generate the index pages for the source:
  $ odoc html-generate src-source.odocl -o html

And finally generate the source pages themselves. Unfortunately this also generates
a documentation page for the inaccessible module too.
  $ odoc html-generate astring_string.odoc --source astring_string.ml -o html
  $ odoc html-generate astring_sub.odoc --source astring_sub.ml -o html
  $ odoc html-generate astring_char.odoc --source astring_char.ml -o html
  $ odoc html-generate astring_escape.odoc --source astring_escape.ml -o html
  $ odoc html-generate astring_base.odoc --source astring_base.ml -o html
  $ odoc html-generate astring_unsafe.odoc --source astring_unsafe.ml -o html

Lastly output the css/js/fonts/etc
  $ odoc support-files -o html

This should be removed before merging, but it's helpful to see the output!
  $ rsync -avz html /tmp/html/
  



