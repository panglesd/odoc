The OCaml JSON file is taken from https://github.com/ocamllabs/vscode-ocaml-platform/blob/bde6e565e5da8d4d942e029559f2b27d7ae7525a/syntaxes/ocaml.json with a few minor modifications. They are distributed under the ISC License.

VSCode License

```
ISC License

Copyright (c) 2019 OCaml Labs

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

The OCaml grammar has been modified to make tmLanguage accept it, with the
following modifications:

```diff
$ diff ocaml_original.json ocaml_new.json
33,35d32
<         {
<           "comment": "toplevel directives",
<           "patterns": [
84,86c81
<             }
<           ]
<         },
---
>             },
143,144c138,139
<           "beginCaptures": [{ "name": "comment.cinaps.ocaml" }],
<           "endCaptures": [{ "name": "comment.cinaps.ocaml" }],
---
>           "beginCaptures": {"1" : { "name": "comment.cinaps.ocaml" }},
>           "endCaptures": {"1" : { "name": "comment.cinaps.ocaml" }},
336,337c331,332
<           "beginCaptures": [{ "name": "keyword.other.ocaml" }],
<           "endCaptures": [{ "name": "keyword.other.ocaml" }],
---
>           "beginCaptures": {"1" : { "name": "keyword.other.ocaml" }},
>           "endCaptures": {"1" : { "name": "keyword.other.ocaml" }},
343,344c338,339
<           "beginCaptures": [{ "name": "keyword.other.ocaml" }],
<           "endCaptures": [{ "name": "keyword.other.ocaml" }],
---
>           "beginCaptures": {"1" : { "name": "keyword.other.ocaml" }},
>           "endCaptures": { "1" : { "name": "keyword.other.ocaml" }},
```

If you modify one of the json file, to update the corresponding json value in
`jsons.ml`, use the following code to get the value an manually copy-paste it:

```ocaml
let file = try Array.get Sys.argv 1 with _ -> failwith "You must pass a path"

let () =
  let json = Yojson.Basic.from_file file in
  let yojson = Yojson.Basic.show json in
  print_endline yojson
```
