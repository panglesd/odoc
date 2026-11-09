  $ cat > a.mli << EOF
  > kind_ k = value
  > type u
  > module M : sig type t : k  type t2 = u end
  > EOF

  $ cat > b.mli << EOF
  > include module type of A.M
  > EOF

  $ ocamlc -c -bin-annot a.mli b.mli
  $ odoc compile a.cmti
  $ odoc compile -I . b.cmti
  $ odoc link -I . a.odoc
  $ odoc link -I . b.odoc
  $ odoc html-generate -o html a.odocl
  $ odoc html-generate -o html b.odocl
  $ odoc support-files -o html

  $ rm -rf /tmp/odoc-tests/prefix
  $ mkdir -p /tmp/odoc-tests
  $ cp -r html /tmp/odoc-tests/prefix

Open /tmp/odoc-tests/prefix/B/index.html in a browser to check.

The issue is that in module B, which has `type t : k`, the `k` is not linking to
`kind_ k = value`.
