Checking that source links exists inside recursive modules.

  $ ocamlc -c main.ml -bin-annot -I .
  $ odoc compile --impl main.ml -I . main.cmt
  List of collected shapes:
  <Main.0> 
  <Main.1>
  
  $ odoc link -I . main.odoc
  List of collected shapes:
  <Main.0> 
  <Main.1> 
  Trying to reduce:
  <Main.0>
  
  Trying to reduce:
  <Main.1>
  
  $ odoc html-generate --indent -o html main.odocl

Both modules should contain source links
(TODO)

  $ grep source_link html/Main/A/index.html -C 2
  [1]

  $ grep source_link html/Main/B/index.html -C 2
  [1]
