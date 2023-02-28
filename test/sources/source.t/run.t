Files containing some values:

  $ cat a.ml
  type t = string
  
  let x = 2
  let y = x + 1
  let z a = if x = 1 || true then x + y else 0
  
  module A = struct end
  module B = A
  
  module type T = sig end
  module type U = T
  
  type ext = ..
  type ext += Foo
  
  exception Exn
  
  class cls = object end
  class cls' = cls
  class type ct = object end

Source pages require a parent:

  $ odoc compile -c module-a -c src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

Compile the modules:

  $ ocamlc -c a.ml -bin-annot

Compile the pages without --source:

  $ odoc compile a.cmt
  $ odoc link -I . a.odoc
  $ odoc html-generate --indent -o html a.odocl

No source links are generated in the documentation:

  $ ! grep source_link html/A/index.html -B 2

Now, compile the pages with the --source option:

  $ printf "a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]

  $ odoc compile -I . --source-name a.ml --source-parent-file src-source.odoc a.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . a.odoc
  $ odoc html-generate --source a.ml --indent -o html a.odocl
  File "a.ml":
  Warning: --source argument is invalid on compilation unit that were not compiled with --source-parent and --source-name

Source links generated in the documentation:

  $ grep source_link html/A/index.html -B 2
  [1]

Ids generated in the source code:

  $ cat html/root/source/a.ml.html | tr '> ' '\n\n' | grep '^id'
  cat: html/root/source/a.ml.html: No such file or directory
  [1]
