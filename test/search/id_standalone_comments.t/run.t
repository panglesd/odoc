Compile the files

  $ ocamlc -c main.ml -bin-annot -I .

Compile and link the documentation

  $ odoc compile -I . main.cmt
  $ odoc link -I . main.odoc

  $ odoc compile-index main.odocl
  odoc: too many arguments, don't know what to do with 'main.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Let's have a look at the links generated for standalone comments search entries:

  $ cat index.json | jq -r '.[] | select(.kind.kind | contains("Doc")) | "\(.doc) -> \(.display.url)"'
  cat: index.json: No such file or directory

The entries link to the pages that contain the standalone comment (they do not
have an ID, so they cannot be linked directly).
