Files containing some values:

  $ cat a.ml
  type t = string
  
  type truc = A | B
  
  let xazaz = A
  
  module Yoyo = struct
    type bli = Aa | Bb
  end
  
  let segr = Yoyo.Aa
  
  let x = 2
  let y = x + 1
  let z a = if x = 1 || true then x + y else a
  let z' a = if x = 1 || true then x + y else a
  
  module A = struct end
  module B = A
  
  module type T = sig end
  module type U = T
  
  type ext = ..
  type ext += Foo | Bar
  
  exception Exn
  
  class cls = object end
  class cls' = cls
  class type ct = object end
  
  let x _ = raise Exn
  
  module X : sig
    type t
  end = struct
    type t = int
  end
  
  type a1 = int
  and a2 = a1
  
  module F (M : sig
    module A : sig end
  end) =
  struct
    module B = M.A
  end
  
  module FM = F (struct
    module A = struct end
  end)
  
  module FF (A : sig end) (B : sig end) = struct end
  module FF2 (A : sig
    module E : sig end
  end) (A : sig
    module F : sig end
  end) =
  struct end

Source pages require a parent:

  $ odoc compile -c module-a -c src-source -c src-source2 root.mld
  ERROR: Failed to parse child reference: Unrecognized kind: src
  [1]

Compile the modules:

  $ ocamlc -c a.ml -bin-annot

Compile the pages without --source:

  $ odoc compile a.cmt
  uname is CamlinternalFormatBasics.odoc and lname is camlinternalFormatBasics.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  $ odoc link -I . a.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  trying to find the shape A
  Loading unit from name src-a
  uname is Src-a.odoc and lname is src-a.odoc
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  $ odoc html-generate --indent -o html a.odocl

No source links are generated in the documentation:

  $ ! grep source_link html/A/index.html -B 2

Now, compile the pages with the --source option:

  $ printf "a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  odoc: option '-o': Output file must be prefixed with 'srctree-'.
  Usage: odoc source-tree [OPTION]… FILE
  Try 'odoc source-tree --help' or 'odoc --help' for more information.
  [2]

  $ odoc compile -I . --source-name a.ml --source-parent-file src-source.odoc a.cmt
  odoc: unknown option '--source-name'.
        unknown option '--source-parent-file'.
  Usage: odoc compile [--child=CHILD] [--open=MODULE] [--resolve-fwd-refs] [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . a.odoc
  uname is Stdlib.odoc and lname is stdlib.odoc
  trying to find the shape A
  Loading unit from name src-a
  uname is Src-a.odoc and lname is src-a.odoc
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  trying to find the shape A
  Loading unit from name src-a
  Found 0 unit
  Not finding it
  $ odoc link -I . page-root.odoc
  odoc: FILE.odoc argument: no 'page-root.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . src-source.odoc
  odoc: FILE.odoc argument: no 'src-source.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html src-source.odocl
  odoc: FILE.odocl argument: no 'src-source.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --indent -o html page-root.odocl
  odoc: FILE.odocl argument: no 'page-root.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source a.ml --indent -o html a.odocl
  odoc: internal error, uncaught exception:
        Failure("TODO")
        Raised at Stdlib.failwith in file "stdlib.ml", line 29, characters 17-33
        Called from Odoc_odoc__Rendering.ignored_source_arg in file "src/odoc/rendering.ml" (inlined), line 16, characters 28-43
        Called from Odoc_odoc__Rendering.documents_of_unit.(fun) in file "src/odoc/rendering.ml", line 21, characters 39-62
        Called from Odoc_model__Error.catch_warnings.(fun) in file "src/model/error.ml", line 89, characters 18-22
        Called from Odoc_model__Error.with_ref in file "src/model/error.ml", line 67, characters 12-16
        Re-raised at Odoc_model__Error.with_ref in file "src/model/error.ml", line 72, characters 4-11
        Called from Odoc_odoc__Rendering.documents_of_unit in file "src/odoc/rendering.ml", line 19, characters 2-202
        Called from Odoc_odoc__Rendering.generate_odoc in file "src/odoc/rendering.ml", line 122, characters 2-76
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 24, characters 19-24
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 22, characters 12-19
        Called from Cmdliner_eval.run_parser in file "cmdliner_eval.ml", line 34, characters 37-44
  [2]
  $ odoc support-files -o html

Source links generated in the documentation:

  $ grep source_link html/A/index.html -B 2
  [1]

Ids generated in the source code:

  $ cat html/root/source/a.ml.html | tr '> ' '\n\n' | grep '^id'
  cat: html/root/source/a.ml.html: No such file or directory
  [1]
