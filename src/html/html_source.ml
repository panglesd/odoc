open Odoc_document.Types
open Tyxml

let html_of_doc ~config ~resolve docs =
  let open Html in
  let a :
      ( [< Html_types.a_attrib ],
        [< Html_types.span_content_fun ],
        [> Html_types.span ] )
      star =
    Unsafe.node "a"
    (* Makes it possible to use <a> inside span. Although this is not standard (see
        https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Content_categories)
        it is validated by the {{:https://validator.w3.org/nu/#textarea}W3C}. *)
  in
  (* [a] tags should not contain in other [a] tags. If this happens, browsers
     start to be really weird. If PPX do bad things, such a situation could
     happen. We manually avoid this situation. *)
  let rec doc_to_html ~is_in_a doc =
    match doc with
    | Source_page.Plain_code s -> [ txt s ]
    | Tagged_code (info, docs) -> (
        let is_in_a = match info with Link _ -> true | _ -> is_in_a in
        let children = List.concat @@ List.map (doc_to_html ~is_in_a) docs in
        match info with
        | Syntax tok -> [ span ~a:[ a_class [ tok ] ] children ]
        | Link { documentation; implementation } -> (
            let href_implementation =
              Option.map (Link.href ~config ~resolve) implementation
            in
            let href_documentation =
              Option.map (Link.href ~config ~resolve) documentation
            in
            match href_documentation, href_implementation with
            | None, None -> children
            | _ ->
               let summary = span ~a:[a_class ["summary"]] children in
               let href h c s t =
                 match h with
                 | Some href -> [ a ~a:[ a_href href; a_class [c] ; a_title t ] [txt s] ]
                 | None -> []
               in
               let a_impl = href href_implementation "impl" "💻" "Jump to implementation" in
               let a_doc = href href_documentation "doc" "📖" "Jump to documentation" in
               [ span ~a:[a_class ["details"]] [summary ; span ~a:[a_class ["jumps"]] (a_impl @ a_doc)]]
            (* let body = *)
            (*   match href_implementation with *)
            (*   | Some href -> [ a ~a:[ a_href href ] children ] *)
            (*   | None -> children *)
            (* in *)
            (* match href_documentation with *)
            (* | None -> body *)
            (* | Some href -> *)
            (*     [ *)
            (*       span *)
            (*         ~a:[ a_class [ "jump-to-doc-container" ] ] *)
            (*         [ *)
            (*           span ~a:[] body; *)
            (*           a *)
            (*             ~a:[ a_href href; a_class [ "jump-to-doc" ] ] *)
            (*             [ txt " 📖" ]; *)
            (*         ]; *)
            (*     ] *))
        | Anchor lbl -> [ span ~a:[ a_id lbl ] children ])
  in
  span ~a:[] @@ List.concat @@ List.map (doc_to_html ~is_in_a:false) docs

let count_lines_in_string s =
  let n = ref 0 in
  String.iter (function '\n' -> incr n | _ -> ()) s;
  !n

(** Traverse the doc to count the number of lines. *)
let rec count_lines_in_span = function
  | Source_page.Plain_code s -> count_lines_in_string s
  | Tagged_code (_, docs) -> count_lines docs

and count_lines = function
  | [] -> 0
  | hd :: tl -> count_lines_in_span hd + count_lines tl

let rec line_numbers acc n =
  let open Html in
  if n < 1 then acc
  else
    let l = string_of_int n in
    let anchor =
      a
        ~a:[ a_id ("L" ^ l); a_class [ "source_line" ]; a_href ("#L" ^ l) ]
        [ txt l ]
    in
    line_numbers (anchor :: txt "\n" :: acc) (n - 1)

let html_of_doc ~config ~resolve docs =
  let open Html in
  pre
    ~a:[ a_class [ "source_container" ] ]
    [
      code
        ~a:[ a_class [ "source_line_column" ] ]
        (line_numbers [] (count_lines docs));
      code
        ~a:[ a_class [ "source_code" ] ]
        [ html_of_doc ~config ~resolve docs ];
    ]
