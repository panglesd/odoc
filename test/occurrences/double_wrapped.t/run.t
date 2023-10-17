This test simulates the conditions when a dune user write a toplevel module.

The module C is not exposed in the handwritten toplevel module.
The module A and B are exposed.
The module B depends on both B and C, the module C only depends on A.

  $ ocamlc -c -o main__.cmo main__.ml -bin-annot -w -49 -no-alias-deps -I .
  $ ocamlc -c -open Main__ -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__C.cmo c.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__B.cmo b.ml -bin-annot -I .
  $ ocamlc -c -open Main__ main.ml -bin-annot -I .

Passing the count-occurrences flag to odoc compile makes it collect the
occurrences information.


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

The count occurrences command outputs a marshalled hashtable, whose keys are
odoc identifiers, and whose values are integers corresponding to the number of
uses.

  $ odoc count-occurrences -I . -o occurrences.txt

  $ du -h occurrences.txt
  4.0K	occurrences.txt

The occurrences_print executable, available only for testing, unmarshal the file
and prints the number of occurrences in a readable format.

Uses of A and B are counted correctly, with the path rewritten correctly.
Uses of C are not counted, since the canonical destination (generated by dune) does not exist.
Uses of values Y.x and Z.y (in b.ml) are not counted since they come from a "local" module.
Uses of values Main__.C.y and Main__.A.x are not rewritten since we use references instead of paths.

  $ occurrences_print occurrences.txt
  Main.A.x was used 2 times
  Main.A.t was used 1 times
  Main.A was used 3 times
  Main.A.M was used 2 times
  Main.B was used 1 times
