Compile the files

  $ ocamlc -c j.ml -bin-annot -I .
  $ ocamlc -c main.ml -bin-annot -I .

Compile and link the documentation

  $ odoc compile -I . --child module-main --child module-j page.mld
  $ odoc compile --parent page -I . j.cmt
  $ odoc compile --parent page -I . main.cmt

  $ odoc link -I . j.odoc
  $ odoc link -I . main.odoc
  $ odoc link -I . page-page.odoc

When html-generating a page, we can provide, through --search-uri flags, uris to
search scripts that will be used to answer search queries. The uris can be
absolute (`https://...` or `/tmp/...` for instance, or relative. If they are
relative, they are interpreted as relative to the `-o` option).

Let us check that `--search-uri` works well:

  $ odoc html-generate --search-uri test.js -o html page-page.odocl
  $ grep -E "test\.js" html/page/index.html
  let search_urls = ['../test.js'];

  $ odoc html-generate --search-uri page/test.js -o html page-page.odocl
  $ grep -E "test\.js" html/page/index.html
  let search_urls = ['test.js'];

  $ odoc html-generate --search-uri search_scripts/test.js -o html page-page.odocl
  $ grep -E "test\.js" html/page/index.html
  let search_urls = ['../search_scripts/test.js'];

  $ odoc html-generate --search-uri /tmp/test.js -o html page-page.odocl
  $ grep -E "test\.js" html/page/index.html
  let search_urls = ['/tmp/test.js'];

  $ odoc html-generate --search-uri https://example.org/test.js -o html page-page.odocl
  $ grep -E "test\.js" html/page/index.html
  let search_urls = ['https://example.org/test.js'];

In this test, we use `fuse.js.js` (a search engine) combined to `index.js`, a file that
we will generate.

  $ odoc html-generate --search-uri fuse.js.js --search-uri index.js -o html j.odocl
  $ odoc html-generate --search-uri fuse.js.js --search-uri index.js -o html main.odocl
  $ odoc html-generate --search-uri fuse.js.js --search-uri index.js -o html page-page.odocl
  $ odoc support-files -o html

We now focus on how to generate the index.js file.

For this, we compute an index of all the values contained in a given list of
odoc files, using the `compile-index` command.

This command generates has two output format: a json output for consumption by
external search engine, and an `odoc` specific extension.  The odoc file is
meant to be consumed either by search engine written in OCaml, which would
depend on `odoc` as a library, or by `odoc` itself to build a global index
incrementally: the `compile-index` command can take indexes as input!

If -o is not provided, the file is saved as index.json, or index-index.odoc if
the --marshall flag is passed.  Odocl files can be given either in a list (using
--file-list, passing a file with the list of line-separated files), or by
passing directly the name of the files.

  $ printf "main.odocl\npage-page.odocl\nj.odocl\n" > index_map
  $ odoc compile-index -o index1.json --file-list index_map
  odoc: unknown option '--file-list'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Or equivalently:

  $ printf "main.odocl\npage-page.odocl\n" > index_map
  $ odoc compile-index -o index2.json --file-list index_map j.odocl
  odoc: unknown option '--file-list'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Or equivalently:

  $ odoc compile-index main.odocl page-page.odocl j.odocl
  odoc: too many arguments, don't know what to do with 'main.odocl', 'page-page.odocl', 'j.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Let's check that the previous commands are indeed independent:

  $ diff index.json index1.json
  diff: index.json: No such file or directory
  diff: index1.json: No such file or directory
  [2]
  $ diff index.json index2.json
  diff: index.json: No such file or directory
  diff: index2.json: No such file or directory
  [2]

Let's now test the --marshall flag.
We compare:
- the result of outputing as a marshalled file, and then use that to output a json file.
- Directly outputing a json file

  $ odoc compile-index -o index-main.odoc --marshall main.odocl
  odoc: unknown option '--marshall'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile-index -o main.json index-main.odoc
  odoc: too many arguments, don't know what to do with 'index-main.odoc'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat main.json | jq sort | jq '.[]' -c | sort > main1.json
  cat: main.json: No such file or directory

  $ odoc compile-index -o main.json main.odocl
  odoc: too many arguments, don't know what to do with 'main.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat main.json | jq sort | jq '.[]' -c | sort > main2.json
  cat: main.json: No such file or directory

  $ diff main1.json main2.json

  $ odoc compile-index -o index-j.odoc --marshall j.odocl
  odoc: unknown option '--marshall'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile-index -o j.json index-j.odoc
  odoc: too many arguments, don't know what to do with 'index-j.odoc'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat j.json | jq sort | jq '.[]' -c | sort > j1.json
  cat: j.json: No such file or directory

  $ odoc compile-index -o j.json j.odocl
  odoc: too many arguments, don't know what to do with 'j.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat j.json | jq sort | jq '.[]' -c | sort > j2.json
  cat: j.json: No such file or directory

  $ diff j1.json j2.json

  $ odoc compile-index -o index-page.odoc --marshall page-page.odocl
  odoc: unknown option '--marshall'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile-index -o page.json index-page.odoc
  odoc: too many arguments, don't know what to do with 'index-page.odoc'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat page.json | jq sort | jq '.[]' -c | sort > page1.json
  cat: page.json: No such file or directory

  $ odoc compile-index -o page.json page-page.odocl
  odoc: too many arguments, don't know what to do with 'page-page.odocl'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat page.json | jq sort | jq '.[]' -c | sort > page2.json
  cat: page.json: No such file or directory

  $ diff page1.json page2.json

Now, we compare the combination of the three marshalled files (index-main.odoc,
index-page.odoc, index-j.odoc).

  $ odoc compile-index -o all.json index-page.odoc index-j.odoc index-main.odoc
  odoc: too many arguments, don't know what to do with 'index-page.odoc', 'index-j.odoc', 'index-main.odoc'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]
  $ cat all.json | jq sort | jq '.[]' -c | sort > all1.json
  cat: all.json: No such file or directory

  $ cat index.json | jq sort | jq '.[]' -c | sort > all2.json
  cat: index.json: No such file or directory
  $ diff all1.json all2.json

The json index file contains a json array, each element of the array corresponding to
a search entry.
An index entry contains:
- an ID,
- the docstring associated (in text format),
- its kind, and some additional information (that are specific for each kind of entry)
- Information on how to render it: the link, and some html. (The link cannot be embedded in the html, it is relative to the "root" of the page, and thus may have to be modified). This also corresponds to the json that should be output to odoc in case the entry is selected by the query.

The index file, one entry per line:
  $ cat index.json | jq sort | jq '.[]' -c
  cat: index.json: No such file or directory

and the first entries formatted:

  $ cat index.json | jq sort | head -n 33
  cat: index.json: No such file or directory

Here is the list of ids for entries. Multiple IDs exists as standalone
paragraphs, codeblocks, etc. use their parent ID (they don't have one for
themselves).

  $ cat index.json | jq -r '.[].id | map(.kind + "-" + .name) | join(".")' | sort
  cat: index.json: No such file or directory

Now, from the index.json file, we need to create the scripts and put them as specified with --search-uri
Those should be javascript file. They will be run in their declared order, in a webworker (so as not to block UI).
They take their input (a string, the query) as a message sent to the webworker (so they have to listen to it). They answer their result to the query by sending a message.
This response should be a JSON entry of the form of the [display] field of a index.json entry, for odoc to be able to print it.

Here is an example of such search script generation, using the fuse.js search engine.

  $ printf "let documents = " > index.js
  $ cat index.json >> index.js
  cat: index.json: No such file or directory
  [1]

  $ cat << EOF >> index.js
  > 
  > const options = { keys: ['id', 'doc'] };
  > var idx_fuse = new Fuse(documents, options);
  > onmessage = (m) => {
  >   let query = m.data;
  >   let result = idx_fuse.search(query);
  >   postMessage(result.slice(0,200).map(a => a.item.display));
  > };
  > EOF

We should now put the scripts where it was:

  $ cp index.js html/
  $ cp fuse.js.js html/

One way to visually try the search is to indent
$ cp -r html /tmp/
$ firefox /tmp/html/page/Main/index.html
and run `dune test`.

Testing the warnings/errors for the `compile-index` command:

Passing an inexistent file:

  $ printf "inexistent.odocl\n" > index_map
  $ odoc compile-index --file-list index_map
  odoc: unknown option '--file-list'.
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Passing an odoc file which is neither a compilation unit nor a page:

  $ odoc compile -c srctree-source page.mld
  $ printf "a.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page -o srctree-source.odoc source_tree.map

  $ odoc compile-index srctree-source.odoc
  odoc: too many arguments, don't know what to do with 'srctree-source.odoc'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Passing a file which is not a correctly marshalled one:

  $ echo hello > my_file
  $ odoc compile-index my_file
  odoc: too many arguments, don't know what to do with 'my_file'
  Usage: odoc compile-index [--include-rec=DIR] [--json] [OPTION]…
  Try 'odoc compile-index --help' or 'odoc --help' for more information.
  [2]

Passing no file:

  $ odoc compile-index
  ERROR: At least one of --include-rec must be passed to odoc compile-index
  [1]
