Checking that source links exists inside recursive modules.

  $ odoc compile -c module-main -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "main.ml" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ ocamlc -c main.ml -bin-annot -I .
  $ odoc compile --source-name main.ml --source-parent-file src-source.odoc -I . main.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
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
