Compile the modules:

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ ocamlc -c a.mli a.ml -bin-annot
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . a.cmti
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
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
