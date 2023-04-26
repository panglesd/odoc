(** Get plain text doc-comment from a doc comment *)

let get_value x = x.Odoc_model.Location_.value

let rec string_of_doc (doc : Odoc_model.Comment.docs) =
  doc |> List.map get_value |> List.map s_of_block_element |> String.concat "\n"

and s_of_block_element (be : Odoc_model.Comment.block_element) =
  match be with
  | `Paragraph (_, is) -> inlines is
  | `Tag _ -> ""
  | `List (_, ls) ->
      List.map (fun x -> x |> List.map get_value |> List.map nestable) ls
      |> List.concat |> String.concat " "
  | `Heading (_, _, h) -> inlines h
  | `Modules _ -> ""
  | `Code_block (_, _, s) -> s |> get_value
  | `Verbatim (_, v) -> v
  | `Math_block (_, m) -> m

and nestable (n : Odoc_model.Comment.nestable_block_element) =
  s_of_block_element (n :> Odoc_model.Comment.block_element)

and inlines is = is |> List.map get_value |> List.map inline |> String.concat ""

and inline (i : Odoc_model.Comment.inline_element) =
  match i with
  | `Code_span s -> s
  | `Word w -> w
  | `Math_span m -> m
  | `Space -> " "
  | `Reference (_, c) -> link_content c
  | `Link (_, c) -> link_content c
  | `Styled (_, b) -> inlines b
  | `Raw_markup (_, _) -> ""

and link_content l =
  l |> List.map get_value
  |> List.map non_link_inline_element
  |> String.concat ""

and non_link_inline_element (n : Odoc_model.Comment.non_link_inline_element) =
  inline (n :> Odoc_model.Comment.inline_element)
