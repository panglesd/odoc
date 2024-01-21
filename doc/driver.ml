(* $MDX part-begin=intro *)
open Bos
let ( >>= ) = Result.bind
let ( >>|= ) m f = m >>= fun x -> Ok (f x)
let get_ok = function Ok x -> x | Error (`Msg m) -> failwith m
let relativize p = Fpath.(v ".." // p)
(* this driver is run from the [doc] dir *)

(* Whether to instrument with landmarks. Result for each commands will be saved
   to directory [_build/default/doc/landmarks]. *)
let instrument = false
(* $MDX part-end *)

(* $MDX part-begin=commands *)
let odoc =
  Cmd.v "../src/odoc/bin/main.exe" (* This is the just-built odoc binary *)

let compile_output = ref [ "" ]

let link_output = ref [ "" ]

let generate_output = ref [ "" ]

type executed_command = {
  cmd : Cmd.t;
  time : float;  (** Running time in seconds. *)
  output_file : Fpath.t option;
}

(* Record the commands executed, their running time and optionally the path to
   the produced file. *)
let commands = ref []

let instrument_dir =
  lazy
    (let dir = Fpath.v "landmarks" in
     OS.Dir.delete dir |> get_ok;
     OS.Dir.create dir |> get_ok |> ignore;
     dir)

(* Environment variables passed to commands. *)
let env = OS.Env.current () |> get_ok

let run ?output_file cmd =
  let t_start = Unix.gettimeofday () in
  let env =
    if instrument then
      let (lazy instrument_dir) = instrument_dir in
      let instrument_out =
        match output_file with
        | Some outf ->
            Fpath.( / ) instrument_dir (Fpath.basename outf ^ ".json")
            |> Fpath.to_string
        | None -> "temporary:" ^ Fpath.to_string instrument_dir
      in
      Astring.String.Map.add "OCAML_LANDMARKS"
        ("time,allocation,format=json,output=" ^ instrument_out)
        env
    else env
  in
  let r =
    OS.Cmd.(run_out ~env ~err:OS.Cmd.err_run_out cmd |> to_lines) |> get_ok
  in
  let t_end = Unix.gettimeofday () in
  let time = t_end -. t_start in
  commands := { cmd; time; output_file } :: !commands;
  r

let add_prefixed_output cmd list prefix lines =
  if List.length lines > 0 then
    list :=
      !list
      @ (Bos.Cmd.to_string cmd :: List.map (fun l -> prefix ^ ": " ^ l) lines)

let compile file ?(count_occurrences = true) ?parent
    ?(output_dir = Fpath.v "./") ?(ignore_output = false) ?source_args children
    =
  let output_basename =
    let ext = Fpath.get_ext file in
    let basename = Fpath.basename (Fpath.rem_ext file) in
    match ext with
    | ".mld" -> "page-" ^ basename ^ ".odoc"
    | ".cmt" | ".cmti" | ".cmi" -> basename ^ ".odoc"
    | _ -> failwith ("bad extension: " ^ ext)
  in
  let output_file = Fpath.( / ) output_dir output_basename in
  let open Cmd in
  let source_args =
    match source_args with
    | None -> Cmd.empty
    | Some (source_name, source_parent_file) ->
        Cmd.(
          v "--source-name" % p source_name % "--source-parent-file"
          % p source_parent_file)
  in
  let cmt_arg =
    let cmt_file = Fpath.set_ext ".cmt" file in
    if Fpath.get_ext file = ".cmti" then
      match Bos.OS.File.exists cmt_file with
      | Ok true -> Cmd.(v "--cmt" % p cmt_file)
      | _ -> Cmd.empty
    else Cmd.empty
  in
  let occ =
    if count_occurrences then Cmd.v "--count-occurrences" else Cmd.empty
  in
  let cmd =
    odoc % "compile" % Fpath.to_string file %% source_args %% occ %% cmt_arg
    % "-I" % "." % "-o" % p output_file
    |> List.fold_right (fun child cmd -> cmd % "--child" % child) children
  in
  let cmd =
    match parent with
    | Some p -> cmd % "--parent" % ("page-\"" ^ p ^ "\"")
    | None -> cmd
  in
  let lines = run ~output_file cmd in
  if not ignore_output then
    add_prefixed_output cmd compile_output (Fpath.to_string file) lines

let link ?(ignore_output = false) file =
  let open Cmd in
  let output_file = Fpath.set_ext "odocl" file in
  let cmd = odoc % "link" % p file % "-o" % p output_file % "-I" % "." in
  let cmd =
    if Fpath.to_string file = "stdlib.odoc" then cmd % "--open=\"\"" else cmd
  in
  let lines = run ~output_file cmd in
  if not ignore_output then
    add_prefixed_output cmd link_output (Fpath.to_string file) lines

let html_generate ?(ignore_output = false) ?(assets = []) ?(search_uris = [])
    file source =
  let open Cmd in
  let source =
    match source with None -> empty | Some source -> v "--source" % p source
  in
  let assets =
    List.fold_left (fun acc filename -> acc % "--asset" % filename) empty assets
  in
  let search_uris =
    List.fold_left
      (fun acc filename -> acc % "--search-uri" % p filename)
      empty search_uris
  in
  let cmd =
    odoc % "html-generate" %% source % p file %% assets %% search_uris % "-o"
    % "html" % "--theme-uri" % "odoc" % "--support-uri" % "odoc"
  in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd generate_output (Fpath.to_string file) lines

let support_files () =
  let open Cmd in
  let cmd = odoc % "support-files" % "-o" % "html/odoc" in
  run cmd

let count_occurrences output =
  let open Cmd in
  let cmd = odoc % "count-occurrences" % "-I" % "." % "-o" % p output in
  run cmd
(* $MDX part-end *)

(* $MDX part-begin=deps *)
let dep_libraries_core =
  [
    "odoc-parser";
    "astring";
    "cmdliner";
    "fpath";
    "result";
    "tyxml";
    "fmt";
    "stdlib";
    "yojson";
  ]

let extra_deps =
  [
    "base";
    "core_kernel";
    "bin_prot";
    "sexplib";
    "sexplib0";
    "base_quickcheck";
    "ppx_sexp_conv";
    "ppx_hash";
    "core";
  ]

let dep_libraries =
  match Sys.getenv_opt "ODOC_BENCHMARK" with
  | Some "true" -> dep_libraries_core @ extra_deps
  | _ -> dep_libraries_core

let odoc_libraries =
  [
    "odoc_xref_test";
    "odoc_xref2";
    "odoc_odoc";
    "odoc_html_support_files";
    "odoc_model_desc";
    "odoc_model";
    "odoc_manpage";
    "odoc_loader";
    "odoc_latex";
    "odoc_html";
    "odoc_document";
    "odoc_examples";
    "odoc_parser";
    "ocamlary";
    "odoc_search";
    "odoc_html_frontend";
    "odoc_json_index";
  ]

let all_libraries = dep_libraries @ odoc_libraries

let extra_docs =
  [
    "interface";
    "driver";
    "parent_child_spec";
    "features";
    "odoc_for_authors";
    "dune";
    "ocamldoc_differences";
    "api_reference";
  ]

let parents =
  let add_parent p l = List.map (fun lib -> (lib, p)) l in
  add_parent "deps" dep_libraries @ add_parent "odoc" odoc_libraries
(* $MDX part-end *)

(* $MDX part-begin=ocamlfind *)
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
  List.fold_right (fun lib acc -> (lib, lib_path lib) :: acc) dep_libraries []
(* $MDX part-end *)

(* $MDX part-begin=findunits *)
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
  List.fold_right Fpath.Set.add l Fpath.Set.empty
(* $MDX part-end *)

(* $MDX part-begin=bestfile *)
let best_file base =
  List.map (fun ext -> Fpath.add_ext ext base) [ "cmti"; "cmt"; "cmi" ]
  |> List.find (fun f -> Bos.OS.File.exists f |> get_ok)
(* $MDX part-end *)

(* $MDX part-begin=ishidden *)
let is_hidden path = Astring.String.is_infix ~affix:"__" (Fpath.to_string path)
(* $MDX part-end *)

(* $MDX part-begin=compiledeps *)
type compile_deps = { digest : Digest.t; deps : (string * Digest.t) list }

let compile_deps f =
  let cmd = Cmd.(odoc % "compile-deps" % Fpath.to_string f) in
  let deps = run cmd in
  let l = List.filter_map (Astring.String.cut ~sep:" ") deps in
  let basename = Fpath.(basename (f |> rem_ext)) |> String.capitalize_ascii in
  match List.partition (fun (n, _) -> basename = n) l with
  | [ (_, digest) ], deps -> Ok { digest; deps }
  | _ -> Error (`Msg "odd")
(* $MDX part-end *)

(* $MDX part-begin=unit *)
type unit = {
  file : Fpath.t;
  ignore_output : bool;
  source : Fpath.t option;
  assets : string list;
}
(* $MDX part-end *)

(* $MDX part-begin=sourcerendering *)
let source_tree_output = ref [ "" ]

let source_tree ?(ignore_output = false) ~parent ~output file =
  let open Cmd in
  let parent = v "--parent" % ("page-\"" ^ parent ^ "\"") in
  let cmd =
    odoc % "source-tree" % "-I" % "." %% parent % "-o" % p output % p file
  in
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
    List.filter_map
      (fun (_, _, _, file) -> Option.map Fpath.to_string file)
      units
  in
  let source_map = Fpath.v "source.map" in
  let () = Bos.OS.File.write_lines source_map sources |> get_ok in
  let () = source_tree ~parent:"odoc" ~output:odoc_source_tree source_map in
  { file = odoc_source_tree; ignore_output = false; source = None; assets = [] }
(* $MDX part-end *)

(* $MDX part-begin=odocunits *)
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
(* $MDX part-end *)

(* $MDX part-begin=allunits *)
let all_units =
  let lib_units =
    List.map
      (fun (lib, p) ->
        Fpath.Set.fold
          (fun p acc -> ("deps", lib, p, None) :: acc)
          (find_units p |> get_ok)
          [])
      lib_paths
  in
  odoc_units @ lib_units |> List.flatten
(* $MDX part-end *)

(* $MDX part-begin=api_ref_gen *)
let update_api_reference_page () =
  let libs =
    List.sort String.compare odoc_libraries |> List.map String.capitalize_ascii
  in
  OS.File.with_oc
    (Fpath.v "api_reference.mld")
    (fun oc () ->
      let pf = Printf.fprintf in
      pf oc "{0 API Reference}\n\n";
      List.iter (pf oc "- {!%s}\n") libs;
      Ok ())
    ()
  |> get_ok |> get_ok
(* $MDX part-end *)

(* $MDX part-begin=compile_mlds *)
let search_file = "index.js"

let compile_mlds () =
  update_api_reference_page ();
  let mkpage x = "page-\"" ^ x ^ "\"" in
  let mkmod x = "module-" ^ String.capitalize_ascii x in
  let mkmld x = Fpath.(add_ext "mld" (v x)) in
  ignore
    (compile (mkmld "odoc")
       ("src-source" :: "page-deps"
       :: List.map mkpage (odoc_libraries @ extra_docs)));
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
            (fun (_parent, lib, child, _) ->
              if lib = library then Some (Fpath.basename child |> mkmod)
              else None)
            all_units
        in
        ignore (compile (mkmld ("library_mlds/" ^ library)) ~parent children);
        "page-" ^ library ^ ".odoc")
      all_libraries
  in
  {
    file = Fpath.v "page-odoc.odoc";
    ignore_output = false;
    source = None;
    assets = [];
  }
  :: List.map
       (fun f ->
         { file = Fpath.v f; ignore_output = false; source = None; assets = [] })
       (("page-deps.odoc" :: odocs) @ extra_odocs)
(* $MDX part-end *)

(* $MDX part-begin=compile_all *)
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
          (fun acc (dep_name, _digest) ->
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
      { file = output; ignore_output; source = impl; assets = [] } :: files
  in
  source_tree
  :: List.fold_left
       (fun acc (parent, lib, dep, impl) ->
         acc @ rec_compile ?impl parent lib (best_file dep))
       [] all_units
  @ mld_odocs
(* $MDX part-end *)

(* $MDX part-begin=link_all *)
let link_all odoc_files =
  List.map
    (fun ({ file = odoc_file; ignore_output; _ } as unit) ->
      ignore (link ~ignore_output odoc_file);
      { unit with file = Fpath.set_ext "odocl" odoc_file })
    odoc_files
(* $MDX part-end *)

(* $MDX part-begin=generate_all *)
let generate_all odocl_files =
  let relativize_opt = function
    | None -> None
    | Some file -> Some (relativize file)
  in
  let search_uris = [ Fpath.v "minisearch.js"; Fpath.v "index.js" ] in
  List.iter
    (fun { file = f; ignore_output = _; source; assets } ->
      ignore (html_generate ~assets ~search_uris f (relativize_opt source)))
    odocl_files;
  support_files ()
(* $MDX part-end *)

(* $MDX part-begin=index_generate *)
let index_generate ?(ignore_output = false) () =
  let open Cmd in
  let files =
    OS.Dir.contents (Fpath.v ".")
    |> get_ok
    |> List.filter (Fpath.has_ext "odocl")
    |> List.filter (fun p ->
           not (String.equal "src-source.odocl" (Fpath.filename p)))
    |> List.filter (fun p -> not (is_hidden p))
    |> List.map Fpath.to_string
  in
  let index_map = Fpath.v "index.map" in
  let () = Bos.OS.File.write_lines index_map files |> get_ok in
  let cmd =
    odoc % "compile-index" % "-o" % "html/index.json" % "--file-list"
    % p index_map
  in
  let lines = run cmd in
  if not ignore_output then
    add_prefixed_output cmd generate_output "index compilation" lines
(* $MDX part-end *)

(* $MDX part-begin=js_generate *)
let js_index () =
  let index = Bos.OS.File.read Fpath.(v "html" / "index.json") |> get_ok in
  Bos.OS.File.writef (Fpath.v search_file)
    {|
 let documents =
   %s
 ;

 let miniSearch = new MiniSearch({
  fields: ['id', 'doc', 'entry_id'], // fields to index for full-text search
   storeFields: ['display'], // fields to return with search results
   idField: 'entry_id',
   extractField: (document, fieldName) => {
     if (fieldName === 'id') {
       return document.id.map(e => e.kind + "-" + e.name).join('.')
     }
     return document[fieldName]
   }
 })


 // Use a unique id since some entries' id are not unique (type extension or
 // standalone doc comments for instance)
 documents.forEach((entry,i) => entry.entry_id = i)
 miniSearch.addAll(documents);

 onmessage = (m) => {
   let query = m.data;
   let result = miniSearch.search(query);
   postMessage(result.slice(0,200).map(a => a.display));
 }
 |}
    index
  |> get_ok;
  Bos.OS.Cmd.run Bos.Cmd.(v "cp" % search_file % "html/") |> get_ok;
  Bos.OS.Cmd.run Bos.Cmd.(v "cp" % "minisearch.js" % "html/") |> get_ok
(* $MDX part-end *)

(* $MDX part-begin=exec_all *)
let _ =
  let compiled = compile_all () in
  let linked = link_all compiled in
  let () = index_generate () in
  let _ = js_index () in
  let _ = count_occurrences (Fpath.v "occurrences-odoc_and_deps.odoc") in
  generate_all linked
(* $MDX part-end *)

(* $MDX part-begin=lines *)
let _ = a
(* $MDX part-end *)
