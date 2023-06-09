# How to Drive `odoc`

This 'live' document describes how to use `odoc` to produce the documentation of `odoc` itself. The aim is
to show a short, simple example of how `odoc` can be used, covering most of the important features.
The document built here includes not only the documentation of `odoc` itself, but it also builds the
docs for a subset of `odoc`'s dependent libraries to show how this may be done. For a much more
complete and comprehensive use of `odoc`, see the [Voodoo project](https://github.com/ocaml-doc/voodoo), the tool that is being used to build
the package docs for
[ocaml.org/packages](https://ocaml.org/packages). The information in this page is specific to
odoc version 2.3 or later.  For earlier
versions see the `driver.md` or `driver.mld` files in the corresponding source distribution.


First, we need to initialise MDX with some libraries and helpful values:

```ocaml env=e1
(* Prelude *)
#require "bos";;
#install_printer Fpath.pp;;
#print_length 1000;;
#print_depth 10;;
open Bos;;
let (>>=) = Result.bind;;
let (>>|=) m f = m >>= fun x -> Ok (f x);;
let get_ok = function | Ok x -> x | Error (`Msg m) -> failwith m
let relativize p = Fpath.(v ".." // p) (* this driver is run from the [doc] dir *)
```

## Desired Output

`odoc` produces output files (HTML or others) in a structured directory tree, so before running `odoc`, the structure of the output must be decided. For these docs, we want the following structure:

- `odoc/index.html` : main page
- `odoc/{odoc_for_authors.html,...}` : other documentation pages
- `odoc/odoc_model/index.html` : `odoc` model library subpage
- `odoc/odoc_model/Odoc_model/index.html` : Module page for the module `Odoc_model`
- `odoc/odoc_model/Odoc_model/...` : Further pages for the submodules of `Odoc_model`
- `odoc/odoc_.../index.html` : other `odoc` library pages
- `odoc/deps/stdlib/index.html` : stdlib main page
- `odoc/deps/stdlib/Stdlib/index.html` : Module page for the module `Stdlib`
- `odoc/deps/astring/index.html` : astring main page
- `odoc/deps/...` : other dependencies
- `odoc/source/...` : rendered source files

The `odoc` model for achieving this is that we have *pages* (`.mld` files) that have *children* which are either *further pages* (`.mld` files), *modules* (from `.cmti` files), or
*source trees*. This {{!page-parent_child_spec} parent/child relationship} is specified on the command line. Parent pages must be *compiled* by `odoc` before their children. Then compiling a page `mypage.mld` will produce the file `page-mypage.odoc`.

In the example below, there will be a file `odoc.mld` that corresponds with the top-level directory `odoc/`. It will be compiled as follows:

<!-- $MDX skip -->
```sh
odoc compile odoc.mld --child page-odoc_model --child deps 
  --child src-source ...
```

The file `deps.mld` which corresponds with the sub-directory `odoc/deps/`, will be compiled as follows:

<!-- $MDX skip -->
```sh
odoc compile deps.mld -I . --parent page-odoc --child page-stdlib --child page-astring ...
```

The file `odoc_model.mld` will have a child module `Odoc_model`. It will be compiled as follows:

<!-- $MDX skip -->
```sh
odoc compile odoc_model.mld -I . --parent page-odoc --child module-Odoc_model
```

The last type of page contains a list of paths to the source files that should be rendered as HTML. The output will be found as a tree underneath this page. This will be compiled in the following way:

<!-- $MDX skip -->
```sh
odoc source-tree source.map -I . --parent page-odoc
```

where the first few lines of `source.map` are:

```
src/xref2/utils.ml
src/xref2/type_of.ml
src/xref2/tools.ml
```

indicating the desire for the rendered source of `utils.ml` to be found as the file `odoc/source/src/xref2/utils.ml.html`.

When compiling any `.mld` file, the parent and all children must be specified. Parents can only be pages from other `.mld` files, and children may be pages (from `.mld` files) or modules (from `.cmti`,`.cmt`, or `.cmi` files).

The parent page must exist before the child page is created, and it must have had the child specified when it was initially compiled.

## Document Generation Phases

Using `odoc` is a three-phase process:

1. Compilation: `odoc compile`
   
This takes as input either `.mld` files containing pure odoc markup, or the output from the compiler in the form of `.cmti`, `.cmt`, or `.cmi` files (in order of preference). For `.mld` files, this step simply translates them into `odoc`'s internal format and writes the corresponding file. For example, given the input `foobar.mld`, `odoc` will output `page-foobar.odoc`. There are no dependencies for compiling `.mld` files beyond the parent as outlined above.

For modules, compilation is the point where `odoc` performs some initial expansion and resolution operations, a process that usually introduces dependencies. For a given input `/path/to/file.cmti` it will output the file `/path/to/file.odoc` unless the `-o` option is used to override the output file. If there were `.cmi` dependencies required for OCaml to compile a particular module, then there will be equivalent `.odoc` dependencies needed for the `odoc compile` step. `odoc` will search for these dependencies in the paths specified with the `-I` directive on compilation. `odoc` provides a command to help with this: `odoc compile-deps`.

As an example we can run `odoc compile-deps` on the file `../src/xref2/.odoc_xref2.objs/byte/odoc_xref2__Compile.cmti`:

<!-- $MDX non-deterministic=output -->
```sh
$ `odoc` compile-deps ../src/xref2/.odoc_xref2.objs/byte/odoc_xref2__Compile.cmti | tail -n 5
Stdlib__result 2ba42445465981713146b97d5e185dd5
Stdlib__seq d6a8de25c9eecf5ae9420a9f3f8b2e88
Stdlib__set 5d365647a10f75c22f2b045a867b4d3e
Stdlib__uchar ab6f1df93abf9e800a3e0d1543523c96
Odoc_xref2__Compile e0d620d652a724705f7ed620dfe07be0
```

From this, we see it's necessary to run `odoc compile` against several `Stdlib` modules before we can compile `odoc_xref2__Compile.cmti`

1. Linking: `odoc link`

This takes the `odoc` files produced during the compilation step and performs the final steps of resolution for both pages and modules, and expansion for modules only. It is during this phase that all the references in the documentation comments are resolved. In order for these to be resolved, everything that is referenced must have been compiled already, and their `odoc` files must be on the
include path as specified by the `-I` arguments to `odoc link`. In this example, we achieve that by compiling all modules and `.mld` files before linking anything. The output of the
link step is an `odocl` file, which is in the same path as the original `odoc` file by default.

Please note: it's only necessary to link the non-hidden modules (i.e., without a double underscore).

3. Generation: `odoc html-generate`

Once the compile and link phases are complete, the resulting `odocl` files may be rendered in a variety of formats. In this example we output HTML.


## `odoc` Documentation

In this section `odoc` is used to generate the documentation of `odoc` and some of its dependent packages. We can make a few simplifying assumptions here:

1. Since we're working with one leaf package, we can assume that there can be no module name clashes in the dependencies. As such, we can afford to put all of our `.odoc` files into one directory and then hard-code the include path to be this directory. When using `odoc` in a context where there may be module name clashes, it requires more careful partitioning of output directories.
2. We'll do all of the compiling before any linking.

Let's start with some functions to execute the three phases of `odoc`.

Compiling a file with `odoc` requires a few arguments: the file to compile, an
optional parent, a list of include paths, a list of children for `.mld` files,
optional parent and name for source implementation, and an output path. Include
paths can be just `'.'`, and we can calculate the output file from the input
because all of the files are going into the same directory.

Linking a file with `odoc` requires the input file and a list of include paths. As
for compile, we will hard-code the include path.

Generating the HTML requires the input `odocl` file, an optional implementation
source file (passed via the `--source` argument), and an output path. We will
hard-code the output path to be `html/`.

Using the `--source` argument with an `.odocl` file that was not compiled with
`--source-parent-file` and `--source-name` will result in an error, as will omitting `--source` when generating HTML of an `odocl` that was
compiled with `--source-parent-file` and `--source-name`.

In all of these, we'll capture `stdout` and `stderr` so we can check it later.

```ocaml env=e1
let odoc = Cmd.v "../src/odoc/bin/main.exe" (* This is the just-built odoc binary *)

let compile_output = ref [ "" ]

let link_output = ref [ "" ]

let generate_output = ref [ "" ]

let commands = ref [ ]

let run cmd =
  let cmd_str = Cmd.to_string cmd in
  commands := cmd_str :: !commands;
  OS.Cmd.(run_out ~err:OS.Cmd.err_run_out cmd |> to_lines) |> get_ok

let add_prefixed_output cmd list prefix lines =
  if List.length lines > 0 then
    list :=
      !list
      @ Bos.Cmd.to_string cmd :: List.map (fun l -> prefix ^ ": " ^ l) lines

let compile file ?parent ?(output_dir = Fpath.v "./")
    ?(ignore_output = false) ?source_args children =
  let output_file =
    let ext = Fpath.get_ext file in
    let basename = Fpath.basename (Fpath.rem_ext file) in
    match ext with
    | ".mld" -> "page-" ^ basename ^ ".odoc"
    | ".cmt" | ".cmti" | ".cmi" -> basename ^ ".odoc"
    | _ -> failwith ("bad extension: " ^ ext)
  in
  let open Cmd in
  let source_args =
    match source_args with
    | None -> Cmd.empty
    | Some (source_name, source_parent_file) ->
        Cmd.(
          v "--source-name" % p source_name % "--source-parent-file"
          % p source_parent_file)
  in
  let cmd =
    odoc % "compile" % Fpath.to_string file %% source_args % "-I" % "."
    % "-o"
    % p (Fpath.( / ) output_dir output_file)
    |> List.fold_right (fun child cmd -> cmd % "--child" % child) children
  in
  let cmd =
    match parent with
    | Some p -> cmd % "--parent" % ("page-\"" ^ p ^ "\"")
    | None -> cmd
  in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd compile_output (Fpath.to_string file) lines

let link ?(ignore_output = false) file =
  let open Cmd in
  let cmd = odoc % "link" % p file % "-I" % "." in
  let cmd = if Fpath.to_string file = "stdlib.odoc" then cmd % "--open=\"\"" else cmd in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd link_output (Fpath.to_string file) lines

let html_generate ?(ignore_output = false) ?(search_files = []) file source =
  let open Cmd in
  let source = match source with None -> empty | Some source -> v "--source" % p source in
  let search =
    List.fold_left
      (fun acc filename -> acc % "--search-file" % filename)
      empty
      (List.map Fpath.filename search_files)
  in
  let cmd =
    odoc % "html-generate" %% source % p file %% search % "-o" % "html" % "--theme-uri" % "odoc"
    % "--support-uri" % "odoc"
  in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd generate_output (Fpath.to_string file) lines

let support_files  ?(search_files = []) () =
  let open Cmd in
  let search = List.fold_left (fun acc f -> acc % "--search-file" % p f) empty search_files in
  let cmd = odoc % "support-files" % "-o" % "html/odoc" in
  run cmd
```

We'll now make some library lists. We have not only external dependency
libraries, but `odoc` itself is also separated into libraries. These two
sets of libraries will be documented in different sections, so we'll keep them
in separate lists. Moreover, `odoc` libraries will include the source code, via
a hardcoded path.

Additionally we'll also construct a list containing the extra documentation pages. Finally let's create a list mapping the section to its parent, which matches
the hierarchy declared above.

```ocaml env=e1
let dep_libraries_core = [
    "odoc-parser";
    "astring";
    "cmdliner";
    "fpath";
    "result";
    "tyxml";
    "fmt";
    "stdlib";
    "yojson";
    "biniou";
];;

let extra_deps = [
    "base";
    "core_kernel";
    "bin_prot";
    "sexplib";
    "sexplib0";
    "base_quickcheck";
    "ppx_sexp_conv";
    "ppx_hash";
]

let dep_libraries =
    match Sys.getenv_opt "ODOC_BENCHMARK" with
    | Some "true" -> dep_libraries_core @ extra_deps
    | _ -> dep_libraries_core

let odoc_libraries = [
    "odoc_xref_test"; "odoc_xref2"; "odoc_odoc"; "odoc_html_support_files";
    "odoc_model_desc"; "odoc_model"; "odoc_manpage"; "odoc_loader";
    "odoc_latex"; "odoc_html"; "odoc_document"; "odoc_examples" ];;

let all_libraries = dep_libraries @ odoc_libraries;;

let extra_docs = [
    "interface";
    "contributing";
    "driver";
    "parent_child_spec";
    "features";
    "interface";
    "odoc_for_authors";
    "dune";
    "ocamldoc_differences";
]

let parents =
    let add_parent p l = List.map (fun lib -> (lib, p)) l in
    (add_parent "deps" dep_libraries) @ (add_parent "odoc" odoc_libraries);;

```

`odoc` operates on the compiler outputs. We need to find them for both the files compiled by Dune within this project and those in libraries we compile against.
The following uses `ocamlfind` to locate the library paths for our dependencies. Since `ocamlfind` gives
us the absolute path, we also have a short function here to relativize it based on our current working
directory to ensure the log of commands we collect is as reproducible as possible.

```ocaml env=e1
let ocamlfind = Cmd.v "ocamlfind"

let reach t ~from =
  let rec loop t from =
    match (t, from) with
    | a :: t, b :: from when a = b -> loop t from
    | _ -> List.fold_right (fun _ acc -> ".." :: acc) from t
  in
  let v s = String.split_on_char '/' s in
  loop (v t) (v from) |> String.concat "/"

let relativize_path =
  let pwd = Sys.getcwd () in
  fun p -> reach p ~from:pwd

let lib_path lib =
  let cmd = Cmd.(ocamlfind % "query" % lib) in
  run cmd |> List.hd |> relativize_path

let lib_paths =
  List.fold_right
    (fun lib acc ->
      (lib, lib_path lib) :: acc)
    dep_libraries []
```

We need a function to find `odoc` inputs from the given search path. `odoc`
operates on `.cmti`, `.cmt`, or `.cmi` files, in order of preference, and the following
function finds all matching files starting from the given path. Then it returns an `Fpath.Set.t`
that contains the `Fpath.t` values representing the absolute file path, without its extension.

```ocaml env=e1
let find_units p =
  OS.Dir.fold_contents ~dotfiles:true
    (fun p acc ->
      if List.exists (fun ext -> Fpath.has_ext ext p) [ "cmt"; "cmti"; "cmi" ]
      then p :: acc
      else acc)
    [] (Fpath.v p)
  >>|= fun paths ->
  let l = List.map Fpath.rem_ext paths in
  let l =
    List.filter
      (fun f ->
        not @@ Astring.String.is_infix ~affix:"ocamldoc" (Fpath.to_string f))
      l
  in
  List.fold_right Fpath.Set.add l Fpath.Set.empty;;
```

Since the units returned by this function have their extension stripped, we need
function to find the best file to use with this basename.

```ocaml env=e1
let best_file base =
  List.map (fun ext -> Fpath.add_ext ext base) [ "cmti"; "cmt"; "cmi" ]
  |> List.find (fun f -> Bos.OS.File.exists f |> get_ok)
```

Many of the units will be 'hidden', meaning that Dune will mangle their name
in order to namespace them. This is achieved by prefixing the namespace module and
a double underscore, so we can tell by the existence of a double underscore that
a module is intended to be hidden. The following predicate tests for that condition:

```ocaml env=e1
let is_hidden path = Astring.String.is_infix ~affix:"__" (Fpath.to_string path)
```

To build the documentation, we start with these files. With the following function, we'll call `odoc compile-deps` on the file to
find all other compilation units upon which it depends:

```ocaml env=e1
type compile_deps = { digest : Digest.t; deps : (string * Digest.t) list }

let compile_deps f =
  let cmd = Cmd.(odoc % "compile-deps" % Fpath.to_string f) in
  let deps = run cmd in
  let l = List.filter_map (Astring.String.cut ~sep:" ") deps in
  let basename = Fpath.(basename (f |> rem_ext)) |> String.capitalize_ascii in
  match List.partition (fun (n, _) -> basename = n) l with
  | [ (_, digest) ], deps -> Ok { digest; deps }
  | _ -> Error (`Msg "odd")
```

For `odoc` libraries, we infer the implementation and interface source file path
from the library name. We list them in a file, passed to `odoc source-tree`, to
generate `src-source.odoc`. This file contains the source hierarchy, and will be
linked and passed to `html-generate` just as other pages and compilation units.

It is used as the `source-parent` for all units for which we could provide
sources.

```ocaml env=e1
let source_tree_output = ref [ "" ]

let source_tree ?(ignore_output = false) ~parent ~output file =
  let open Cmd in
  let parent = v "--parent" % ("page-\"" ^ parent ^ "\"") in
  let cmd = odoc % "source-tree" % "-I" % "." %% parent % "-o" % p output % p file in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd source_tree_output (Fpath.to_string file) lines

let odoc_source_tree = Fpath.v "src-source.odoc"

let source_dir_of_odoc_lib lib =
  match String.split_on_char '_' lib with
  | "odoc" :: s ->
      let libname = Fpath.(v (String.concat "_" s)) in
      Some Fpath.(v "src" // libname)
  | _ -> None

let source_files_of_odoc_module lib module_ =
  let filename =
    let module_ =
      match Astring.String.cut ~rev:true ~sep:"__" module_ with
      | None -> module_
      | Some (_, "") -> module_
      | Some (_, module_) -> module_
    in
    (* ML.ml should not be renamed *)
    if String.for_all (fun c -> Char.equal (Char.uppercase_ascii c) c) module_
    then module_
    else String.uncapitalize_ascii module_
  in
  match source_dir_of_odoc_lib lib with
  | None -> None
  | Some relpath ->
      let add_filename path ext =
        Fpath.( / ) path filename |> Fpath.add_ext ext
      in
      let find_by_extension path exts =
        exts
        |> List.map (fun ext -> add_filename path ext)
        |> List.find_opt (fun f -> Bos.OS.File.exists (relativize f) |> get_ok)
      in
      find_by_extension relpath [ "pp.ml"; "ml" ]

let compile_source_tree units =
  let sources =
    List.filter_map (fun (_, _, _, file) -> Option.map Fpath.to_string file) units
  in
  let source_map = Fpath.v "source.map" in
  let () = Bos.OS.File.write_lines source_map sources |> get_ok in
  let () = source_tree ~parent:"odoc" ~output:odoc_source_tree source_map in
  (odoc_source_tree, false, None)

```

Let's now put together a list of all possible modules. We'll keep track of
which library they're in, and whether that library is a part of `odoc` or a dependency
library.

```ocaml env=e1
let odoc_all_unit_paths = find_units ".." |> get_ok

let odoc_units =
  List.map
    (fun lib ->
      Fpath.Set.fold
        (fun p acc ->
          if Astring.String.is_infix ~affix:lib (Fpath.to_string p) then
            let impl =
              let module_ = Fpath.basename p in
              source_files_of_odoc_module lib module_
            in
            ("odoc", lib, p, impl) :: acc
          else acc)
        odoc_all_unit_paths [])
    odoc_libraries
```

```ocaml env=e1
let all_units =
  let lib_units =
    List.map
      (fun (lib, p) ->
        Fpath.Set.fold
          (fun p acc -> ("deps", lib, p, None) :: acc)
          (find_units p |> get_ok)
          [])
      lib_paths in
  odoc_units @ lib_units |> List.flatten
```

Now we'll compile all of the parent `.mld` files. To ensure that the parents are compiled before the children, we start with `odoc.mld`, then `deps.mld`, and so on. The result of this file is a list of the resulting `odoc` files.

```ocaml env=e1
let compile_mlds () =
  let mkpage x = "page-\"" ^ x ^ "\"" in
  let mkmod x = "module-" ^ String.capitalize_ascii x in
  let mkmld x = Fpath.(add_ext "mld" (v x)) in
  ignore
    (compile (mkmld "odoc")
       ("src-source" :: "page-deps" :: List.map mkpage (odoc_libraries @ extra_docs)));
  ignore (compile (mkmld "deps") ~parent:"odoc" (List.map mkpage dep_libraries));
  let extra_odocs =
    List.map
      (fun p ->
        ignore (compile (mkmld p) ~parent:"odoc" []);
        "page-" ^ p ^ ".odoc")
      extra_docs
  in
  let odocs =
    List.map
      (fun library ->
        let parent = List.assoc library parents in
        let children =
          List.filter_map
            (fun (parent, lib, child, _) ->
              if lib = library then Some (Fpath.basename child |> mkmod)
              else None)
            all_units
        in
        ignore (compile (mkmld ("library_mlds/"^library)) ~parent children);
        "page-" ^ library ^ ".odoc")
      all_libraries
  in
  List.map
    (fun f -> (Fpath.v f, false, None))
    ("page-odoc.odoc" :: "page-deps.odoc" :: odocs @ extra_odocs)
```

Now we get to the compilation phase. For each unit, we query its dependencies, then recursively call to compile these dependencies. Once this is done we compile the unit itself. If the unit has already been compiled we don't do anything. Note that we aren't checking the hashes of the dependencies which a build system should do to ensure that the module being compiled is the correct one. Again we benefit from the fact that we're creating the docs for one leaf package and that there must be no module name clashes in its dependencies. The result of this function is a list of the resulting `odoc` files.

```ocaml env=e1
let compile_all () =
  let mld_odocs = compile_mlds () in
  let source_tree = compile_source_tree all_units in
  let source_args =
    Option.map (fun source_relpath -> (source_relpath, odoc_source_tree))
  in
  let rec rec_compile ?impl parent lib file =
    let output = Fpath.(base (set_ext "odoc" file)) in
    if OS.File.exists output |> get_ok then []
    else
      let deps = compile_deps file |> get_ok in
      let files =
        List.fold_left
          (fun acc (dep_name, digest) ->
            match
              List.find_opt
                (fun (_, _, f, _) ->
                  Fpath.basename f |> String.capitalize_ascii = dep_name)
                all_units
            with
            | None -> acc
            | Some (parent, lib, dep_path, impl) ->
                let file = best_file dep_path in
                rec_compile ?impl parent lib file @ acc)
          [] deps.deps
      in
      let ignore_output = parent = "deps" in
      let source_args = source_args impl in
      compile file ~parent:lib ?source_args ~ignore_output [];
      (output, ignore_output, impl) :: files
  in
  source_tree
  :: List.fold_left
    (fun acc (parent, lib, dep, impl) ->
      acc @ rec_compile ?impl parent lib (best_file dep))
    [] all_units
  @ mld_odocs
```

Linking is now straightforward. We link all `odoc` files.

```ocaml env=e1
let link_all odoc_files =
  List.map
    (fun (odoc_file, ignore_output, source) ->
      ignore (link ~ignore_output odoc_file);
      Fpath.set_ext "odocl" odoc_file, source)
    odoc_files
```

Now we simply run `odoc html-generate` over all of the resulting `odocl` files.
This will generate sources, as well as documentation for non-hidden units.
We notify the generator that the javascript file to use for search is `index.js`.

```ocaml env=e1
let generate_all odocl_files =
  let search_files = [ Fpath.v "index.js" ] in
  let relativize_opt = function None -> None | Some file -> Some (relativize file) in
  List.iter
    (fun (f, source) -> ignore(html_generate ~search_files f (relativize_opt source)))
     odocl_files;
  support_files ~search_files ()
```

Finally, we generate an index of all values, types, ... This index is meant to be consumed by search engines, to create their own index. It consists of a JSON array, containing entries with the name, full name, associated comment, link and anchor, and kind.
Generating the index is done via `odoc compile-index`, which create a json file. This second format is meant to be consumed by search engines to populate their search index. Search engines written in OCaml can also call the `Odoc_model.Fold.unit` and  `Odoc_model.Fold.page` function, in conjunction with `Odoc_search.Entry.entry_of_item` in order to get a (version stable) OCaml value of each element to be indexed.

```ocaml env=e1
let index_generate ?(ignore_output = false) () =
  let open Cmd in
  let cmd = odoc % "compile-index" % "-o" % "html/index.json" % "-I" % "." in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd generate_output "index compilation" lines;
```

We turn the JSON index into a javascript file. In order to never block the UI, this file will be used as a web worker by `odoc`, to perform searches:

- The search query will be sent as a plain string to the web worker, using the standard mechanism of message passing
- The web worker has to sent back the result as a message to the main thread, containing the list of result. Each entry of this list must have the same form as it had in the original JSON file.
- The file must be named `index.js` and be located in the `odoc-support` URI.

In this driver, we use the minisearch javascript library. For more involved application, we could use `index.js` to call a server-side search engine via an API call.

```ocaml env=e1
let js_index () =
  let index = Bos.OS.File.read Fpath.(v "html" / "index.json") |> get_ok in
  let minisearch = Bos.OS.File.read Fpath.(v "minisearch.js") |> get_ok in
  Bos.OS.File.writef Fpath.(v "html" / "odoc" / "index.js") {|%s
let documents = 
  %s
;

let miniSearch = new MiniSearch({
  fields: ['id', 'doc'], // fields to index for full-text search
  storeFields: ['display'], // fields to return with search results
  extractField: (document, fieldName) => {
    if (fieldName === 'id') {
      return document.id.map(e => e.kind + "-" + e.name).join('.')
    }
    return document[fieldName]
  }
})


// Index all documents (except Type extensions which don't have a unique ID)
miniSearch.addAll(documents.filter(entry => entry.extra.kind != "TypeExtension"));

onmessage = (m) => {
  let query = m.data;
  let result = miniSearch.search(query);
  postMessage(result.slice(0,200).map(a => a.display));
}
|} minisearch index
```


The following code executes all of the above, and we're done!

```ocaml env=e1
let compiled = compile_all () in
let linked = link_all compiled in
let _ = generate_all linked in
let () = index_generate () in js_index ()
```

