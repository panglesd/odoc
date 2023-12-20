This is what happens when a dune user write a toplevel module.
Similar to the lookup_def_wrapped test.

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

  $ printf "a.ml\nmain.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  odoc: option '-o': Output file must be prefixed with 'srctree-'.
  Usage: odoc source-tree [OPTION]… FILE
  Try 'odoc source-tree --help' or 'odoc --help' for more information.
  [2]

  $ ocamlc -c -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -o main__.cmo main__.ml -bin-annot -I .
  $ ocamlc -c -open Main__ main.ml -bin-annot -I .

  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . main__A.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . main__.cmt
  uname is CamlinternalFormatBasics.odoc and lname is camlinternalFormatBasics.odoc
  uname is Main__A.odoc and lname is main__A.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is Main__A.odoc and lname is main__A.odoc
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
  $ odoc link -I . main__A.odoc
  odoc: FILE.odoc argument: no 'main__A.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . main__.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  trying to find the shape Main__
  Loading unit from name src-main__
  uname is Src-main__.odoc and lname is src-main__.odoc
  Found 0 unit
  Not finding it

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
