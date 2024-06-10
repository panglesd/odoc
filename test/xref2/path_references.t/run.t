  $ ocamlc -bin-annot test.ml

  $ mkdir h
  $ odoc compile --output-dir h --parent-id pkg/doc doc/foo.mld
  $ odoc compile --output-dir h --parent-id pkg/doc doc/dup.mld
  $ odoc compile --output-dir h --parent-id pkg/doc/subdir doc/subdir/bar.mld
  $ odoc compile --output-dir h --parent-id pkg/doc/subdir doc/subdir/dup.mld
  $ odoc compile --output-dir h --parent-id pkg/lib/libname test.cmt

  $ odoc link -P pkg:h/pkg/doc -L libname:h/pkg/lib/libname h/pkg/doc/subdir/page-dup.odoc
  $ odoc link -P pkg:h/pkg/doc -L libname:h/pkg/lib/libname h/pkg/doc/subdir/page-bar.odoc
  File "doc/subdir/bar.mld", line 12, characters 49-56:
  Warning: Failed to resolve reference unresolvedroot(Test) Couldn't find "Test"
  File "doc/subdir/bar.mld", line 12, characters 39-48:
  Warning: Failed to resolve reference ./Test is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 12, characters 18-38:
  Warning: Failed to resolve reference /pkg/libname/Test is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 12, characters 0-17:
  Warning: Failed to resolve reference //libname/Test is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 10, characters 43-51:
  Warning: Failed to resolve reference ./dup is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 10, characters 20-42:
  Warning: Failed to resolve reference /pkg/doc/subdir/dup is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 10, characters 0-19:
  Warning: Failed to resolve reference //doc/subdir/dup is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 8, characters 13-28:
  Warning: Failed to resolve reference /pkg/doc/dup is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 8, characters 0-12:
  Warning: Failed to resolve reference //doc/dup is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 6, characters 50-58:
  Warning: Failed to resolve reference ./bar is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 6, characters 20-42:
  Warning: Failed to resolve reference /pkg/doc/subdir/bar is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 6, characters 0-19:
  Warning: Failed to resolve reference //doc/subdir/bar is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 4, characters 29-35:
  Warning: Failed to resolve reference unresolvedroot(foo) Couldn't find "foo"
  File "doc/subdir/bar.mld", line 4, characters 13-28:
  Warning: Failed to resolve reference /pkg/doc/foo is of kind page path but expected signature or page
  File "doc/subdir/bar.mld", line 4, characters 0-12:
  Warning: Failed to resolve reference //doc/foo is of kind page path but expected signature or page
  $ odoc link -P pkg:h/pkg/doc -L libname:h/pkg/lib/libname h/pkg/doc/page-dup.odoc
  $ odoc link -P pkg:h/pkg/doc -L libname:h/pkg/lib/libname h/pkg/doc/page-foo.odoc
  File "doc/foo.mld", line 12, characters 49-56:
  Warning: Failed to resolve reference unresolvedroot(Test) Couldn't find "Test"
  File "doc/foo.mld", line 12, characters 39-48:
  Warning: Failed to resolve reference ./Test is of kind page path but expected signature or page
  File "doc/foo.mld", line 12, characters 18-38:
  Warning: Failed to resolve reference /pkg/libname/Test is of kind page path but expected signature or page
  File "doc/foo.mld", line 12, characters 0-17:
  Warning: Failed to resolve reference //libname/Test is of kind page path but expected signature or page
  File "doc/foo.mld", line 10, characters 43-56:
  Warning: Failed to resolve reference ./subdir/dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 10, characters 20-42:
  Warning: Failed to resolve reference /pkg/doc/subdir/dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 10, characters 0-19:
  Warning: Failed to resolve reference //doc/subdir/dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 8, characters 29-37:
  Warning: Failed to resolve reference ./dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 8, characters 13-28:
  Warning: Failed to resolve reference /pkg/doc/dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 8, characters 0-12:
  Warning: Failed to resolve reference //doc/dup is of kind page path but expected signature or page
  File "doc/foo.mld", line 6, characters 64-79:
  Warning: Failed to resolve reference ./subdir/bar is of kind page path but expected signature or page
  File "doc/foo.mld", line 6, characters 50-63:
  Warning: Failed to resolve reference ./subdir/bar is of kind page path but expected signature or page
  File "doc/foo.mld", line 6, characters 43-49:
  Warning: Failed to resolve reference unresolvedroot(bar) Couldn't find "bar"
  File "doc/foo.mld", line 6, characters 20-42:
  Warning: Failed to resolve reference /pkg/doc/subdir/bar is of kind page path but expected signature or page
  File "doc/foo.mld", line 6, characters 0-19:
  Warning: Failed to resolve reference //doc/subdir/bar is of kind page path but expected signature or page
  File "doc/foo.mld", line 4, characters 36-44:
  Warning: Failed to resolve reference ./foo is of kind page path but expected signature or page
  File "doc/foo.mld", line 4, characters 13-28:
  Warning: Failed to resolve reference /pkg/doc/foo is of kind page path but expected signature or page
  File "doc/foo.mld", line 4, characters 0-12:
  Warning: Failed to resolve reference //doc/foo is of kind page path but expected signature or page
  $ odoc link -P pkg:h/pkg/doc -L libname:h/pkg/lib/libname h/pkg/lib/libname/test.odoc
  File "test.ml", line 11, characters 42-51:
  Warning: Failed to resolve reference ./Test is of kind page path but expected signature or page
  File "test.ml", line 11, characters 21-41:
  Warning: Failed to resolve reference /pkg/libname/Test is of kind page path but expected signature or page
  File "test.ml", line 11, characters 3-20:
  Warning: Failed to resolve reference //libname/Test is of kind page path but expected signature or page
  File "test.ml", line 9, characters 23-45:
  Warning: Failed to resolve reference /pkg/doc/subdir/dup is of kind page path but expected signature or page
  File "test.ml", line 9, characters 3-22:
  Warning: Failed to resolve reference //doc/subdir/dup is of kind page path but expected signature or page
  File "test.ml", line 7, characters 16-31:
  Warning: Failed to resolve reference /pkg/doc/dup is of kind page path but expected signature or page
  File "test.ml", line 7, characters 3-15:
  Warning: Failed to resolve reference //doc/dup is of kind page path but expected signature or page
  File "test.ml", line 5, characters 46-52:
  Warning: Failed to resolve reference unresolvedroot(bar) Couldn't find "bar"
  File "test.ml", line 5, characters 23-45:
  Warning: Failed to resolve reference /pkg/doc/subdir/bar is of kind page path but expected signature or page
  File "test.ml", line 5, characters 3-22:
  Warning: Failed to resolve reference //doc/subdir/bar is of kind page path but expected signature or page
  File "test.ml", line 3, characters 32-38:
  Warning: Failed to resolve reference unresolvedroot(foo) Couldn't find "foo"
  File "test.ml", line 3, characters 16-31:
  Warning: Failed to resolve reference /pkg/doc/foo is of kind page path but expected signature or page
  File "test.ml", line 3, characters 3-15:
  Warning: Failed to resolve reference //doc/foo is of kind page path but expected signature or page

Helper that extracts references in a compact way. Headings help to interpret the result.

  $ jq_references() { jq -c '.. | objects | if has("`Reference") then . elif has("`Heading") then [ .. | .["`Word"]? | select(.) ] else empty end'; }

  $ odoc_print ./h/pkg/doc/page-foo.odocl | jq_references
  ["Title","for","foo"]
  ["Page","foo"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"foo"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"foo"]}},[]]}
  {"`Reference":[{"`Resolved":{"`Identifier":{"`LeafPage":[{"Some":{"`Page":[{"Some":{"`Page":["None","pkg"]}},"doc"]}},"foo"]}}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["foo","`TRelativePath"]}},[]]}
  ["Page","subdir/bar"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Root":["bar","`TUnknown"]},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["subdir","`TRelativePath"]},"bar"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["subdir","`TRelativePath"]},"bar"]}},[]]}
  ["Page","dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["dup","`TRelativePath"]}},[]]}
  ["Page","subdir/dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["subdir","`TRelativePath"]},"dup"]}},[]]}
  ["Module","Test"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["libname","`TCurrentPackage"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"libname"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["Test","`TRelativePath"]}},[]]}
  {"`Reference":[{"`Root":["Test","`TUnknown"]},[]]}

  $ odoc_print ./h/pkg/doc/subdir/page-bar.odocl | jq_references
  ["Title","for","subdir/bar"]
  ["Page","foo"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"foo"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"foo"]}},[]]}
  {"`Reference":[{"`Root":["foo","`TUnknown"]},[]]}
  ["Page","subdir/bar"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Resolved":{"`Identifier":{"`LeafPage":[{"Some":{"`Page":[{"Some":{"`Page":[{"Some":{"`Page":["None","pkg"]}},"doc"]}},"subdir"]}},"bar"]}}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["bar","`TRelativePath"]}},[]]}
  ["Page","dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"dup"]}},[]]}
  ["Page","subdir/dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["dup","`TRelativePath"]}},[]]}
  ["Module","Test"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["libname","`TCurrentPackage"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"libname"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["Test","`TRelativePath"]}},[]]}
  {"`Reference":[{"`Root":["Test","`TUnknown"]},[]]}

  $ odoc_print ./h/pkg/lib/libname/test.odocl | jq_references
  ["Page","foo"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"foo"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"foo"]}},[]]}
  {"`Reference":[{"`Root":["foo","`TUnknown"]},[]]}
  ["Page","subdir/bar"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"bar"]}},[]]}
  {"`Reference":[{"`Root":["bar","`TUnknown"]},[]]}
  ["Page","dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"dup"]}},[]]}
  ["Page","subdir/dup"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["doc","`TCurrentPackage"]},"subdir"]},"dup"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"doc"]},"subdir"]},"dup"]}},[]]}
  ["Module","Test"]
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Root":["libname","`TCurrentPackage"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Slash":[{"`Slash":[{"`Root":["pkg","`TAbsolutePath"]},"libname"]},"Test"]}},[]]}
  {"`Reference":[{"`Page_path":{"`Root":["Test","`TRelativePath"]}},[]]}
  {"`Reference":[{"`Resolved":{"`Identifier":{"`Root":[{"Some":{"`Page":[{"Some":{"`Page":[{"Some":{"`Page":["None","pkg"]}},"lib"]}},"libname"]}},"Test"]}}},[]]}
