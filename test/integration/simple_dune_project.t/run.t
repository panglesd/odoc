Build the documentation of a simple Dune library.

  $ dune build @install @doc
  List of collected shapes:
  List of collected shapes:
  List of collected shapes:
  CU Dune_odoc_test . "Foo"[module] . "t"[type]
  

  $ find _build/default/_doc/_html -name '*.html' | sort
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/Bar/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/Foo/index.html
  _build/default/_doc/_html/dune_odoc_test/Dune_odoc_test/index.html
  _build/default/_doc/_html/dune_odoc_test/index.html
  _build/default/_doc/_html/index.html
