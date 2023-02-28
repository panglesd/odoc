Similar to Astring library.

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "a.ml\na_x.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ ocamlc -c -o a_x.cmo a_x.ml -bin-annot -I .
  $ ocamlc -c a.mli -bin-annot -I .
  $ ocamlc -c a.ml -bin-annot -I .

  $ odoc compile --hidden --source-name a_x.ml --source-parent-file src-source.odoc -I . a_x.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . a.cmti
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]

  $ odoc link -I . a_x.odoc
  odoc: FILE.odoc argument: no 'a_x.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . a.odoc
  odoc: FILE.odoc argument: no 'a.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]

TODO: It seems that --hidden do not work:
  $ odoc_print a_x.odoc | grep hidden
  odoc_print: PATH argument: no 'a_x.odoc' file or directory
  Usage: odoc_print [-r VAL] [OPTION]… PATH
  Try 'odoc_print --help' for more information.
  [1]
  $ odoc_print a_x.odocl | grep hidden
  odoc_print: PATH argument: no 'a_x.odocl' file or directory
  Usage: odoc_print [-r VAL] [OPTION]… PATH
  Try 'odoc_print --help' for more information.
  [1]

  $ odoc html-generate --source a_x.ml --indent -o html a_x.odocl
  odoc: FILE.odocl argument: no 'a_x.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source a.ml --indent -o html a.odocl
  odoc: FILE.odocl argument: no 'a.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

Look if all the source files are generated:

  $ find html | sort
  html

Documentation for `A_x` is not generated for hidden modules, but --hidden do not
work right now:

  $ ! [ -f html/A_x/index.html ]

Code source for `A_x` is wanted:

  $ [ -f html/root/source/a_x.ml.html ]
  [1]

`A` should contain a link to `A_x.ml.html`:

  $ grep source_link html/A/index.html
  grep: html/A/index.html: No such file or directory
  [2]

`A.X` and `A.X.Y` should contain a link to `A_x.ml.html`:

  $ grep source_link html/A/X/index.html
  grep: html/A/X/index.html: No such file or directory
  [2]
  $ grep source_link html/A/X/Y/index.html
  grep: html/A/X/Y/index.html: No such file or directory
  [2]
