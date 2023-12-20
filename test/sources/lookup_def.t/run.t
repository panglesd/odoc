Compile the modules:

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

  $ printf "a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  odoc: option '-o': Output file must be prefixed with 'srctree-'.
  Usage: odoc source-tree [OPTION]… FILE
  Try 'odoc source-tree --help' or 'odoc --help' for more information.
  [2]

  $ ocamlc -c a.mli a.ml -bin-annot
  $ odoc compile --cmt a.cmt --source-name a.ml --source-parent-file src-source.odoc -I . a.cmti
  odoc: unknown option '--cmt', did you mean '-c'?
        unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link a.odoc
  odoc: FILE.odoc argument: no 'a.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]

Show the locations:

  $ odoc_print a.odocl | jq -c '.. | select(.locs?) | [ .id, .locs ]'
  odoc_print: PATH argument: no 'a.odocl' file or directory
  Usage: odoc_print [-r VAL] [OPTION]… PATH
  Try 'odoc_print --help' for more information.
