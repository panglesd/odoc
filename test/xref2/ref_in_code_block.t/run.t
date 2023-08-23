A quick test to repro the issue found in #857

  $ ocamlc -bin-annot -c a.mli

  $ odoc compile a.cmti
  $ odoc link a.odoc

  $ odoc html-generate -o html/ a.odocl
  $ odoc support-files -o html/

In html, labels in subpages should not be disambiguated since they won't have the same URL.

  $ find html
  html
  html/A
  html/A/index.html


  $ firefox html/A/index.html
