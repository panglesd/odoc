This is what happens when a dune user write a toplevel module.

  $ odoc compile -c module-a -c src-source root.mld

  $ ocamlc -c -o main__.cmo main__.ml -bin-annot -w -49 -no-alias-deps -I .
  $ ocamlc -c -open Main__ -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__C.cmo c.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__B.cmo b.ml -bin-annot -I .
  $ ocamlc -c -open Main__ main.ml -bin-annot -I .

  $ odoc compile --count-occurrences -I . main__A.cmt
  $ odoc compile --count-occurrences -I . main__C.cmt
  $ odoc compile --count-occurrences -I . main__B.cmt
  $ odoc compile --count-occurrences -I . main__.cmt
  $ odoc compile --count-occurrences -I . main.cmt

  $ odoc link -I . main.odoc
  $ odoc link -I . main__A.odoc
  $ odoc link -I . main__B.odoc
  $ odoc link -I . main__C.odoc
  $ odoc link -I . main__.odoc

Count occurrences

  $ odoc count-occurrences -I . -o occurrences.txt

Uses of A and B are counted correctly, since the path is rewritten correctly.
Uses of C are not counted, since the canonical destination does not exists.
Uses of values Y.x and Z.y (in b.ml) are not counted since they come from a "local" module.
Uses of values Main__.C.y and Main__.A.x are not rewritten since we use references instead of paths.

  $ cat occurrences.txt
  Main.A.x was used 2 times
  Main.A.t was used 1 times
  Main.A was used 3 times
  Main.A.M was used 2 times
  Main.B was used 1 times
