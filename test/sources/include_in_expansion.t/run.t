Checking that source parents are kept, using include.

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "a.ml\nb.ml\nmain.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ ocamlc -c -o b.cmo b.ml -bin-annot -I .
  $ ocamlc -c -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile --source-name b.ml --source-parent-file src-source.odoc -I . b.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . main__A.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
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
  $ odoc link -I . main__A.odoc
  odoc: FILE.odoc argument: no 'main__A.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]

  $ odoc html-generate --source main.ml --indent -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source a.ml --hidden --indent -o html main__A.odocl
  odoc: FILE.odocl argument: no 'main__A.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

In Main.A, the source parent of value x should be to Main__A, while the
source parent of value y should be left to B.

  $ grep source_link html/Main/A/index.html -C 1
  grep: html/Main/A/index.html: No such file or directory
  [2]
