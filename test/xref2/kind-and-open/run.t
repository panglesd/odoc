  $ cat > m.mli << EOF
  > kind_ k = value
  > type t
  > module M : sig kind_ k = immediate type t : k end
  > open M
  > type u : k = t
  > EOF

  $ ocamlc -c -bin-annot m.mli
  $ odoc compile m.cmti
  $ odoc link m.odoc
  $ odoc html-generate -o html m.odocl
  $ odoc support-files -o html

  $ rm -rf /tmp/odoc-tests/open
  $ mkdir -p /tmp/odoc-tests
  $ cp -r html /tmp/odoc-tests/open

Open /tmp/odoc-tests/open/M/index.html in a browser to check.

PROBLEM: open is ignored when resolving an unqualified kind: t's kind means M.k
but links to the outer k (while t correctly links to M.t).
