Verify the behavior on functors.

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

  $ printf "s.ml\na.ml\nb.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  odoc: option '-o': Output file must be prefixed with 'srctree-'.
  Usage: odoc source-tree [OPTION]… FILE
  Try 'odoc source-tree --help' or 'odoc --help' for more information.
  [2]

  $ ocamlc -c -o s.cmo s.ml -bin-annot -I .
  $ ocamlc -c -o a.cmo a.ml -bin-annot -I .
  $ ocamlc -c -o b.cmo b.ml -bin-annot -I .
  $ odoc compile --source-name s.ml --source-parent-file src-source.odoc -I . s.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . a.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile --source-name b.ml --source-parent-file src-source.odoc -I . b.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . s.odoc
  odoc: FILE.odoc argument: no 's.odoc' file or directory
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
  $ odoc html-generate --source s.ml --indent -o html s.odocl
  odoc: FILE.odocl argument: no 's.odocl' file or directory
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

  $ find html | sort
  html

In this test, the functor expansion contains the right link.

  $ cat html/A/F/index.html | grep source_link -C 1
  cat: html/A/F/index.html: No such file or directory
  [1]

  $ cat html/root/source/a.ml.html | grep L3
  cat: html/root/source/a.ml.html: No such file or directory
  [1]

However, on functor results, there is a link to source in the file:

  $ cat html/B/R/index.html | grep source_link -C 2
  cat: html/B/R/index.html: No such file or directory
  [1]

Source links in functor parameters might not make sense. Currently we generate none:

  $ cat html/A/F/argument-1-S/index.html | grep source_link -C 1
  cat: html/A/F/argument-1-S/index.html: No such file or directory
  [1]
