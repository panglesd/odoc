Compile the modules:

  $ ocamlc -c a.mli -bin-annot
  $ ocamlc -c a.ml -bin-annot -I .
  $ ocamlc -c b.mli -bin-annot
  $ ocamlc -c b.ml -bin-annot -I .

The root page:

  $ odoc compile -c module-a -c module-b -c srctree-source root.mld

The source tree page

  $ printf "lib/a.ml\nlib/b.ml\n" > source.map
  $ odoc source-tree -I . --parent page-root source.map
  uname is Page-root.odoc and lname is page-root.odoc

  $ ls
  a.cmi
  a.cmo
  a.cmt
  a.cmti
  a.ml
  a.mli
  b.cmi
  b.cmo
  b.cmt
  b.cmti
  b.ml
  b.mli
  c.ml
  page-root.odoc
  root.mld
  source.map
  srctree-source.odoc

Compiling separately implementation and interface. Compiling implementation should happen before.
Even if there is no cmti, two compilations would happen.

  $ odoc compile-src -I . --source-path lib/a.ml --source-parent-file srctree-source.odoc a.cmt
  $ odoc compile -I . a.cmti
  uname is CamlinternalFormatBasics.odoc and lname is camlinternalFormatBasics.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  $ odoc compile-src -I . --source-path lib/b.ml --source-parent-file srctree-source.odoc b.cmt
  $ odoc compile -I . b.cmti
  uname is CamlinternalFormatBasics.odoc and lname is camlinternalFormatBasics.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc

  $ ls
  a.cmi
  a.cmo
  a.cmt
  a.cmti
  a.ml
  a.mli
  a.odoc
  b.cmi
  b.cmo
  b.cmt
  b.cmti
  b.ml
  b.mli
  b.odoc
  c.ml
  page-root.odoc
  root.mld
  source.map
  src-a.odoc
  src-b.odoc
  srctree-source.odoc

Linking everything.

  $ odoc link -I . page-root.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is B.odoc and lname is b.odoc
  uname is A.odoc and lname is a.odoc
  $ odoc link -I . a.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  trying to find the shape A
  Loading unit from name src-a
  uname is Src-a.odoc and lname is src-a.odoc
  Found 1 unit
  Loading unit from name src-a
  Found 1 unit
  trying to find the shape A
  Loading unit from name src-a
  Found 1 unit
  Loading unit from name src-a
  Found 1 unit
  $ odoc link -I . src-a.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  $ odoc link -I . b.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  trying to find the shape B
  Loading unit from name src-b
  uname is Src-b.odoc and lname is src-b.odoc
  Found 1 unit
  Loading unit from name src-b
  Found 1 unit
  trying to find the shape B
  Loading unit from name src-b
  Found 1 unit
  Loading unit from name src-b
  Found 1 unit
  $ odoc link -I . src-b.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  $ odoc link -I . srctree-source.odoc

Html generation.

  $ odoc html-generate -o html page-root.odocl
  $ odoc html-generate -o html srctree-source.odocl
  $ odoc html-generate -o html --source a.ml src-a.odocl
  $ odoc html-generate -o html a.odocl
  $ odoc html-generate -o html --source b.ml src-b.odocl
  $ odoc html-generate -o html b.odocl

  $ odoc support-files -o html

  $ rm -rf /tmp/html
  $ cp -r html /tmp/html

Summary of the changes in the CLI:
- `odoc source-tree` now generates files with name `src-tree-<name>.odoc
- New `odoc compile-src` command which takes a `.cmt` and output a `src-<name>.odoc`.
- `--source` is now passed at compiling phase.
- `--source-name` is now named `--source-path`.
