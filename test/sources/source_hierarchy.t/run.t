A page can have source children.

  $ odoc compile -c module-a -c module-b -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "lib/main.ml\nlib/b/b.ml\nlib/a/a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

Compile the modules:

  $ ocamlc -c a.ml -bin-annot
  $ ocamlc -c b.ml -bin-annot
  $ ocamlc -c c.ml -bin-annot

Now, compile the pages with the --source option. The source-name must be included in the source-children of the source-parent:

  $ odoc compile -I . --source-name lib/a/a.ml --source-parent-file src-source.odoc a.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . --source-name lib/b/b.ml --source-parent-file src-source.odoc b.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile -I . --source-name lib/main.ml --source-parent-file src-source.odoc c.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . page-root.odoc
  odoc: FILE.odoc argument: no 'page-root.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . a.odoc
  odoc: FILE.odoc argument: no 'a.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . b.odoc
  odoc: FILE.odoc argument: no 'b.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . c.odoc
  odoc: FILE.odoc argument: no 'c.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html page-root.odocl
  odoc: FILE.odocl argument: no 'page-root.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html src-source.odoc
  odoc: FILE.odocl argument: no 'src-source.odoc' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source a.ml --indent -o html a.odocl
  odoc: FILE.odocl argument: no 'a.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source b.ml --indent -o html b.odocl
  odoc: FILE.odocl argument: no 'b.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source c.ml --indent -o html c.odocl
  odoc: FILE.odocl argument: no 'c.odocl' file or directory
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
