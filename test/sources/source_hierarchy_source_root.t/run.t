A page can have source children.

  $ odoc compile -c module-a -c module-b -c src-source root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

  $ printf "lib/main.ml\nlib/b/b.ml\nlib/a/a.ml\n" > source.map
  $ odoc source-tree -I . --parent page-root source.map
  uname is Page-root.odoc and lname is page-root.odoc
  ERROR: Couldn't find specified parent page
  [1]

Compile the modules:

  $ ocamlc -c lib/a/a.ml -bin-annot
  $ ocamlc -c lib/b/b.ml -bin-annot
  $ ocamlc -c lib/main.ml -bin-annot

Now, compile the pages with the --source option. The source-name must be included in the source-children of the source-parent:

  $ odoc compile -I . --source-name lib/a/a.ml --source-parent-file src-source.odoc lib/a/a.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . --source-name lib/b/b.ml --source-parent-file src-source.odoc lib/b/b.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . --source-name lib/main.ml --source-parent-file src-source.odoc lib/main.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . -I lib/a -I lib/b -I lib page-root.odoc
  odoc: FILE.odoc argument: no 'page-root.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . lib/a/a.odoc
  odoc: FILE.odoc argument: no 'lib/a/a.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . lib/b/b.odoc
  odoc: FILE.odoc argument: no 'lib/b/b.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . lib/main.odoc
  odoc: FILE.odoc argument: no 'lib/main.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . src-source.odoc
  odoc: FILE.odoc argument: no 'src-source.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html page-root.odocl
  odoc: FILE.odocl argument: no 'page-root.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html src-source.odocl
  odoc: FILE.odocl argument: no 'src-source.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source-root . --indent -o html lib/a/a.odocl
  odoc: FILE.odocl argument: no 'lib/a/a.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source-root . --indent -o html lib/b/b.odocl
  odoc: FILE.odocl argument: no 'lib/b/b.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source-root . --indent -o html lib/main.odocl
  odoc: FILE.odocl argument: no 'lib/main.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

Source pages and source directory pages are generated:

  $ find html | sort
  html

A directory simply list its children:

  $ cat html/root/source/lib/index.html
  cat: html/root/source/lib/index.html: No such file or directory
  [1]
