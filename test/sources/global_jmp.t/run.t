Compile the modules:

  $ odoc compile -c module-a -c module-b -c src-source root.mld

  $ printf "a.ml\nb.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map

  $ ocamlc -c a.mli a.ml -bin-annot
  $ ocamlc -c b.ml -I . -bin-annot
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . a.cmti
  $ odoc compile --source-name b.ml --source-parent-file src-source.odoc -I . b.cmt
  $ odoc link a.odoc -I .
  $ odoc link b.odoc -I .
  $ odoc link src-source.odoc -I .
  $ odoc link page-root.odoc -I .

Generate html

  $ odoc html-generate --indent -o html page-root.odocl
  $ odoc html-generate --indent -o html src-source.odocl
  $ odoc html-generate --source a.ml --indent -o html a.odocl
  $ odoc html-generate --source b.ml --indent -o html b.odocl
  $ odoc support-files  -o html

A.a in b.ml links to the A.a value in the API

  $ cat html/root/source/b.ml.html | tr ' ' '\n' | grep -A 3 index.html#val-a
  href="../../A/index.html#val-a"><span
  class="UIDENT">A</span><span
  class="DOT">.</span><span
  class="LIDENT">a</span></a><span
