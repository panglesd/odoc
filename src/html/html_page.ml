(*
 * Copyright (c) 2016 Thomas Refis <trefis@janestreet.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

module Url = Odoc_document.Url
module Html = Tyxml.Html

let html_of_toc toc =
  let open Types in
  let rec section (section : toc) =
    let link = Html.a ~a:[ Html.a_href section.href ] section.title in
    match section.children with [] -> [ link ] | cs -> [ link; sections cs ]
  and sections the_sections =
    the_sections
    |> List.map (fun the_section -> Html.li (section the_section))
    |> Html.ul
  in
  match toc with
  | [] -> []
  | _ -> [ Html.nav ~a:[ Html.a_class [ "odoc-toc" ] ] [ sections toc ] ]

let html_of_breadcrumbs (breadcrumbs : Types.breadcrumb list) =
  let make_navigation ~up_url rest =
    [
      Html.nav
        ~a:[ Html.a_class [ "odoc-nav" ] ]
        ([ Html.a ~a:[ Html.a_href up_url ] [ Html.txt "Up" ]; Html.txt " – " ]
        @ rest);
    ]
  in
  match List.rev breadcrumbs with
  | [] -> [] (* Can't happen - there's always the current page's breadcrumb. *)
  | [ _ ] -> [] (* No parents *)
  | [ { name = "index"; _ }; x ] ->
      (* Special case leaf pages called 'index' with one parent. This is for files called
          index.mld that would otherwise clash with their parent. In particular,
          dune and odig both cause this situation right now. *)
      let up_url = "../index.html" in
      let parent_name = x.name in
      make_navigation ~up_url [ Html.txt parent_name ]
  | current :: up :: bs ->
      let space = Html.txt " " in
      let sep = [ space; Html.entity "#x00BB"; space ] in
      let html =
        (* Create breadcrumbs *)
        Utils.list_concat_map ?sep:(Some sep)
          ~f:(fun (breadcrumb : Types.breadcrumb) ->
            [
              [
                Html.a
                  ~a:[ Html.a_href breadcrumb.href ]
                  [ Html.txt breadcrumb.name ];
              ];
            ])
          (up :: bs)
        |> List.flatten
      in
      make_navigation ~up_url:up.href
        (List.rev html @ sep @ [ Html.txt current.name ])

let page_creator ~config ~url ~uses_katex header breadcrumbs toc content =
  let theme_uri = Config.theme_uri config in
  let support_uri = Config.support_uri config in
  let path = Link.Path.for_printing url in

  let head : Html_types.head Html.elt =
    let title_string =
      Printf.sprintf "%s (%s)" url.name (String.concat "." path)
    in

    let file_uri base file =
      match base with
      | Types.Absolute uri -> uri ^ "/" ^ file
      | Relative uri ->
          let page = Url.Path.{ kind = `File; parent = uri; name = file } in
          Link.href ~config ~resolve:(Current url) (Url.from_path page)
    in

    let odoc_css_uri = file_uri theme_uri "odoc.css" in
    let highlight_js_uri = file_uri support_uri "highlight.pack.js" in
    let default_meta_elements =
      [
        Html.link ~rel:[ `Stylesheet ] ~href:odoc_css_uri ();
        Html.meta ~a:[ Html.a_charset "utf-8" ] ();
        Html.meta
          ~a:[ Html.a_name "generator"; Html.a_content "odoc %%VERSION%%" ]
          ();
        Html.meta
          ~a:
            [
              Html.a_name "viewport";
              Html.a_content "width=device-width,initial-scale=1.0";
            ]
          ();
        Html.script ~a:[ Html.a_src highlight_js_uri ] (Html.txt "");
        Html.script (Html.txt {tt|
     /* Taken from https://github.com/highlightjs/highlight.js/issues/2889 */

     var mergeHTMLPlugin = (function () {
         'use strict';

         var originalStream;

         /**
          * @param {string} value
          * @returns {string}
          */
         function escapeHTML(value) {
             return value
                 .replace(/&/g, '&amp;')
                 .replace(/</g, '&lt;')
                 .replace(/>/g, '&gt;')
                 .replace(/"/g, '&quot;')
                 .replace(/'/g, '&#x27;');
         }

         /* plugin itself */

         /** @type {HLJSPlugin} */
         const mergeHTMLPlugin = {
             // preserve the original HTML token stream
             "before:highlightElement": ({ el }) => {
                 originalStream = nodeStream(el);
             },
             // merge it afterwards with the highlighted token stream
             "after:highlightElement": ({ el, result, text }) => {
                 if (!originalStream.length) return;

                 const resultNode = document.createElement('div');
                 resultNode.innerHTML = result.value;
                 result.value = mergeStreams(originalStream, nodeStream(resultNode), text);
                 el.innerHTML = result.value;
             }
         };

         /* Stream merging support functions */

         /**
          * @typedef Event
          * @property {'start'|'stop'} event
          * @property {number} offset
          * @property {Node} node
          */

         /**
          * @param {Node} node
          */
         function tag(node) {
             return node.nodeName.toLowerCase();
         }

         /**
          * @param {Node} node
          */
         function nodeStream(node) {
             /** @type Event[] */
             const result = [];
             (function _nodeStream(node, offset) {
                 for (let child = node.firstChild; child; child = child.nextSibling) {
                     if (child.nodeType === 3) {
                         offset += child.nodeValue.length;
                     } else if (child.nodeType === 1) {
                         result.push({
                             event: 'start',
                             offset: offset,
                             node: child
                         });
                         offset = _nodeStream(child, offset);
                         // Prevent void elements from having an end tag that would actually
                         // double them in the output. There are more void elements in HTML
                         // but we list only those realistically expected in code display.
                         if (!tag(child).match(/br|hr|img|input/)) {
                             result.push({
                                 event: 'stop',
                                 offset: offset,
                                 node: child
                             });
                         }
                     }
                 }
                 return offset;
             })(node, 0);
             return result;
         }

         /**
          * @param {any} original - the original stream
          * @param {any} highlighted - stream of the highlighted source
          * @param {string} value - the original source itself
          */
         function mergeStreams(original, highlighted, value) {
             let processed = 0;
             let result = '';
             const nodeStack = [];

             function selectStream() {
                 if (!original.length || !highlighted.length) {
                     return original.length ? original : highlighted;
                 }
                 if (original[0].offset !== highlighted[0].offset) {
                     return (original[0].offset < highlighted[0].offset) ? original : highlighted;
                 }

                 /*
                    To avoid starting the stream just before it should stop the order is
                    ensured that original always starts first and closes last:

                    if (event1 == 'start' && event2 == 'start')
                    return original;
                    if (event1 == 'start' && event2 == 'stop')
                    return highlighted;
                    if (event1 == 'stop' && event2 == 'start')
                    return original;
                    if (event1 == 'stop' && event2 == 'stop')
                    return highlighted;

                    ... which is collapsed to:
                  */
                 return highlighted[0].event === 'start' ? original : highlighted;
             }

             /**
              * @param {Node} node
              */
             function open(node) {
                 /** @param {Attr} attr */
                 function attributeString(attr) {
                     return ' ' + attr.nodeName + '="' + escapeHTML(attr.value) + '"';
                 }
                 // @ts-ignore
                 result += '<' + tag(node) + [].map.call(node.attributes, attributeString).join('') + '>';
             }

             /**
              * @param {Node} node
              */
             function close(node) {
                 result += '</' + tag(node) + '>';
             }

             /**
              * @param {Event} event
              */
             function render(event) {
                 (event.event === 'start' ? open : close)(event.node);
             }

             while (original.length || highlighted.length) {
                 let stream = selectStream();
                 result += escapeHTML(value.substring(processed, stream[0].offset));
                 processed = stream[0].offset;
                 if (stream === original) {
                     /*
                        On any opening or closing tag of the original markup we first close
                        the entire highlighted node stack, then render the original tag along
                        with all the following original tags at the same offset and then
                        reopen all the tags on the highlighted stack.
                      */
                     nodeStack.reverse().forEach(close);
                     do {
                         render(stream.splice(0, 1)[0]);
                         stream = selectStream();
                     } while (stream === original && stream.length && stream[0].offset === processed);
                     nodeStack.reverse().forEach(open);
                 } else {
                     if (stream[0].event === 'start') {
                         nodeStack.push(stream[0].node);
                     } else {
                         nodeStack.pop();
                     }
                     render(stream.splice(0, 1)[0]);
                 }
             }
             return result + escapeHTML(value.substr(processed));
         }

         return mergeHTMLPlugin;

     }());

     hljs.addPlugin(mergeHTMLPlugin);

hljs.initHighlightingOnLoad();|tt});
      ]
    in
    let meta_elements =
      if uses_katex then
        let katex_css_uri = file_uri theme_uri "katex.min.css" in
        let katex_js_uri = file_uri support_uri "katex.min.js" in
        default_meta_elements
        @ [
            Html.link ~rel:[ `Stylesheet ] ~href:katex_css_uri ();
            Html.script ~a:[ Html.a_src katex_js_uri ] (Html.txt "");
            Html.script
              (Html.cdata_script
                 {|
          document.addEventListener("DOMContentLoaded", function () {
            var elements = Array.from(document.getElementsByClassName("odoc-katex-math"));
            for (var i = 0; i < elements.length; i++) {
              var el = elements[i];
              var content = el.textContent;
              var new_el = document.createElement("span");
              new_el.setAttribute("class", "odoc-katex-math-rendered");
              var display = el.classList.contains("display");
              katex.render(content, new_el, { throwOnError: false, displayMode: display });
              el.replaceWith(new_el);
            }
          });
        |});
          ]
      else default_meta_elements
    in
    Html.head (Html.title (Html.txt title_string)) meta_elements
  in

  let body =
    html_of_breadcrumbs breadcrumbs
    @ [ Html.header ~a:[ Html.a_class [ "odoc-preamble" ] ] header ]
    @ html_of_toc toc
    @ [ Html.div ~a:[ Html.a_class [ "odoc-content" ] ] content ]
  in
  let htmlpp = Html.pp ~indent:(Config.indent config) () in
  let html = Html.html head (Html.body ~a:[ Html.a_class [ "odoc" ] ] body) in
  let content ppf =
    htmlpp ppf html;
    (* Tyxml's pp doesn't output a newline a the end, so we force one *)
    Format.pp_force_newline ppf ()
  in
  content

let make ~config ~url ~header ~breadcrumbs ~toc ~uses_katex content children =
  let filename = Link.Path.as_filename ~is_flat:(Config.flat config) url in
  let content =
    page_creator ~config ~url ~uses_katex header breadcrumbs toc content
  in
  { Odoc_document.Renderer.filename; content; children }

let path_of_module_of_source ppf url =
  match url.Url.Path.parent with
  | Some parent ->
      let path = Link.Path.for_printing parent in
      Format.fprintf ppf " (%s)" (String.concat "." path)
  | None -> ()

let src_page_creator ~breadcrumbs ~config ~url ~header name content =
  let theme_uri = Config.theme_uri config in
  let head : Html_types.head Html.elt =
    let title_string =
      Format.asprintf "Source: %s%a" name path_of_module_of_source url
    in
    let file_uri base file =
      match base with
      | Types.Absolute uri -> uri ^ "/" ^ file
      | Relative uri ->
          let page = Url.Path.{ kind = `File; parent = uri; name = file } in
          Link.href ~config ~resolve:(Current url) (Url.from_path page)
    in
    let odoc_css_uri = file_uri theme_uri "odoc.css" in
    let meta_elements =
      [
        Html.link ~rel:[ `Stylesheet ] ~href:odoc_css_uri ();
        Html.meta ~a:[ Html.a_charset "utf-8" ] ();
        Html.meta
          ~a:[ Html.a_name "generator"; Html.a_content "odoc %%VERSION%%" ]
          ();
        Html.meta
          ~a:
            [
              Html.a_name "viewport";
              Html.a_content "width=device-width,initial-scale=1.0";
            ]
          ();
      ]
    in
    Html.head (Html.title (Html.txt title_string)) meta_elements
  in
  let body =
    html_of_breadcrumbs breadcrumbs
    @ [ Html.header ~a:[ Html.a_class [ "odoc-preamble" ] ] header ]
    @ content
  in
  (* We never indent as there is a bug in tyxml and it would break lines inside
     a [pre] *)
  let htmlpp = Html.pp ~indent:false () in
  let html =
    Html.html head (Html.body ~a:[ Html.a_class [ "odoc-src" ] ] body)
  in
  let content ppf =
    htmlpp ppf html;
    (* Tyxml's pp doesn't output a newline a the end, so we force one *)
    Format.pp_force_newline ppf ()
  in
  content

let make_src ~config ~url ~breadcrumbs ~header title content =
  let filename = Link.Path.as_filename ~is_flat:(Config.flat config) url in
  let content =
    src_page_creator ~breadcrumbs ~config ~url ~header title content
  in
  { Odoc_document.Renderer.filename; content; children = [] }
