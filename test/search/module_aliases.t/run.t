Compile the files

  $ ocamlc -c main.ml -bin-annot -I .

Compile and link the documentation

  $ odoc compile main.cmt
  $ odoc link main.odoc
  $ odoc compile-index main.odocl
  odoc: too many arguments, don't know what to do with 'main.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Search results only redirect to their definition point (not the
expansions). Comments link to the expansion they are in.

  $ cat index.json | jq -r '.[] | "\(.id[-1].name) -> \(.display.url)"'
  cat: index.json: No such file or directory
