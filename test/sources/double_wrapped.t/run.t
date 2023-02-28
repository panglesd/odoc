This is what happens when a dune user write a toplevel module.
Similar to the lookup_def_wrapped test.

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "a.ml\nmain.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ ocamlc -c -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -o main__.cmo main__.ml -bin-annot -I .
  $ ocamlc -c -open Main__ main.ml -bin-annot -I .

  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . main__A.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . main__.cmt
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
  $ odoc link -I . main__.odoc

  $ odoc html-generate --source main.ml --indent -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --hidden --indent -o html main__.odocl
  $ odoc html-generate --source a.ml --hidden --indent -o html main__A.odocl
  odoc: FILE.odocl argument: no 'main__A.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

Look if all the source files are generated:

  $ find html | sort
  html

  $ cat html/Main/A/index.html
  cat: html/Main/A/index.html: No such file or directory
  [1]
