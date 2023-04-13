open Js_of_ocaml

let x = Data.x

let v : Odoc_search.Types.index =
  match Base64.decode x with
  | Error _ -> failwith "glo"
  | Ok x -> Marshal.from_string x 0

let () =
  List.iter
    (fun { Odoc_search.Types.id; doc = _ } ->
      print_endline @@ Odoc_model.Paths.Identifier.name id)
    v;
  Js_of_ocaml.Js.export "my_index" v;
  Js_of_ocaml.Js.export "my_function" (fun x -> print_endline x);
  let _ = Js.Unsafe.global##.document in
  ()

let _decodeURI (s : Js.js_string Js.t) : Js.js_string Js.t =
  Js.Unsafe.fun_call (Js.Unsafe.js_expr "decodeURI") [| Js.Unsafe.inject s |]

let () =
  let elt = Js.Unsafe.global##.document in
  (Js.Unsafe.coerce elt)##.blah := Js.string "yoyoyo"

let _createElement a = Dom_html.document##createElement (Js.string a)

let () =
  let module Html = Dom_html in
  let div1 = Dom_html.document##createElement (Js.string "div") in
  let body = Html.window##.document##.body in
  let () = div1##.innerHTML := Js.string "<h1>bliblibli</h1>" in
  let () = Dom.appendChild body div1 in
  ()

let get_ a = Js.Opt.get a (fun () -> failwith "get_opt_failed")
let get_ok = function Ok x -> x | Error _ -> failwith "get_ok"

let _id =
  let module Html = Dom_html in
  let bar = Dom_html.document##querySelector (Js.string ".search-bar") in
  let search_result =
    get_ @@ Dom_html.document##querySelector (Js.string ".search-result")
  in
  let bar = get_ bar in
  Html.addEventListener bar Html.Event.input
    (Dom_html.handler (fun ev ->
         let query = get_ ev##.target in
         let query =
           Js.to_string
             (Js.Unsafe.coerce query : Html.inputElement Js.t)##.value
         in
         let results =
           ignore query;
           v
         in
         search_result##.innerHTML := Js.string "";
         let f entry =
           let container = Html.createA Html.document in
           let href =
             let url =
               get_ok
               @@ Odoc_document.Url.from_identifier ~stop_before:false
                    entry.Odoc_search.Types.id
             in
             let config =
               Odoc_html.Config.v ~semantic_uris:true ~indent:false ~flat:false
                 ~open_details:false ~as_json:false ()
             in
             let url = Odoc_html.Link.href ~config ~resolve:(Base "") url in
             Js.to_string Js.Unsafe.global##.baseurl ^ url
           in
           container##.href := Js.string href;
           let kind =
             match entry.id.iv with
             | `InstanceVariable _ -> "instance-variable"
             | `Parameter _ -> "parameter"
             | `Module _ -> "module"
             | `ModuleType _ -> "module-type"
             | `Method _ -> "method"
             | `Field _ -> "field"
             | `Result _ -> "result"
             | `Label _ -> "label"
             | `Type _ -> "type"
             | `Exception _ -> "exception"
             | `Class _ -> "class"
             | `Page _ -> "page"
             | `LeafPage _ -> "leaf-page"
             | `CoreType _ -> "core-type"
             | `ClassType _ -> "class-type"
             | `Value _ -> "value"
             | `CoreException _ -> "core-exception"
             | `Constructor _ -> "constructor"
             | `Extension _ -> "extension"
             | `Root _ -> "root"
           in
           container##.classList##add (Js.string "search-entry");
           container##.classList##add (Js.string kind);
           Dom.appendChild search_result container
         in
         List.iter f results;
         Js._true))
    Js._true
