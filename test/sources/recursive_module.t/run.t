Checking that source links exists inside recursive modules.

  $ odoc compile -c module-main -c src-source root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

  $ printf "main.ml" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  odoc: option '-o': Output file must be prefixed with 'srctree-'.
  Usage: odoc source-tree [OPTION]… FILE
  Try 'odoc source-tree --help' or 'odoc --help' for more information.
  [2]

  $ ocamlc -c main.ml -bin-annot -I .
  $ odoc compile --source-name main.ml --source-parent-file src-source.odoc -I . main.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . main.odoc
  odoc: FILE.odoc argument: no 'main.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source main.ml --indent -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

Both modules should contain source links

  $ grep source_link html/Main/A/index.html -C 2
  grep: html/Main/A/index.html: No such file or directory
  [2]

  $ grep source_link html/Main/B/index.html -C 2
  grep: html/Main/B/index.html: No such file or directory
  [2]
