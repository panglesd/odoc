Compile the modules:

  $ ocamlc -c a.mli -bin-annot
  $ ocamlc -c a.ml -bin-annot -I .
  $ ocamlc -c b.mli -bin-annot
  $ ocamlc -c b.ml -bin-annot -I .

The root page:

  $ odoc compile -c module-a -c module-b -c src-source root.mld

The source tree page

  $ printf "lib/a.ml\nlib/b.ml\n" > source.map
  $ odoc source-tree -I . --parent page-root source.map

Compiling separately implementation and interface. Compiling implementation should happen before.
Even if there is no cmti, two compilations would happen.

  $ odoc compile-src -I . --source a.ml --source-path lib/a.ml --source-parent-file src-tree-source.odoc a.cmt
  $ odoc compile -I . a.cmti
  $ odoc compile-src -I . --source b.ml --source-path lib/b.ml --source-parent-file src-tree-source.odoc b.cmt
  $ odoc compile -I . b.cmti

Linking everything.

  $ odoc link -I . page-root.odoc
  $ odoc link -I . a.odoc
  $ odoc link -I . src-a.odoc
  $ odoc link -I . b.odoc
  $ odoc link -I . src-b.odoc
  $ odoc link -I . src-tree-source.odoc

Html generation.

  $ odoc html-generate -o html page-root.odocl
  $ odoc html-generate -o html src-tree-source.odocl
  $ odoc html-generate -o html src-a.odocl
  $ odoc html-generate -o html a.odocl
  $ odoc html-generate -o html src-b.odocl
  $ odoc html-generate -o html b.odocl

Summary of the changes in the CLI:
- `odoc source-tree` now generates files with name `src-tree-<name>.odoc
- New `odoc compile-src` command which takes a `.cmt` and output a `src-<name>.odoc`.
- `--source` is now passed at compiling phase.
- `--source-name` is now named `--source-path`.