open Odoc_document
open Types
open Doctree

module Markup = struct
  type t =
    | Inline of string list
    | Block of t list
    | Concat of t list
    | Break
    | Anchor of string
    | String of string
    | Env of indent * string * t * string
    | Command of string * t
    | OpenSqBracket
    | CloseSqBracket
    | OpenParenthesis
    | CloseParenthesis

  and indent = Any

  let env indent s s' t = Env (indent, s, t, s')

  let noop = Concat []

  let break = Break

  let open_sq_bracket, close_sq_bracket = (OpenSqBracket, CloseSqBracket)

  let open_parenthesis, close_parenthesis = (OpenParenthesis, CloseParenthesis)

  let append t1 t2 =
    match (t1, t2) with
    | Concat l1, Concat l2 -> Concat (l1 @ l2)
    | Concat l1, e2 -> Concat (l1 @ [ e2 ])
    | e1, Concat l2 -> Concat (e1 :: l2)
    | e1, e2 -> Concat [ e1; e2 ]

  let ( ++ ) = append

  let concat = List.fold_left ( ++ ) (Concat [])

  let rec intersperse ~sep = function
    | [] -> []
    | [ h ] -> [ h ]
    | h1 :: (_ :: _ as t) -> h1 :: sep :: intersperse ~sep t

  let list ?(sep = Concat []) l = concat @@ intersperse ~sep l

  let str fmt = Format.ksprintf (fun s -> String s) fmt

  let escaped fmt = Format.ksprintf (fun s -> String s) fmt

  let command s t = Command (s, t)

  let rec pp fmt t =
    match t with
    | Inline s -> Format.fprintf fmt "%s" (String.concat "" s)
    | Block b ->
        let inner = function
          | [] -> ()
          | [ x ] -> Format.fprintf fmt "%a" pp x
          | x :: xs -> Format.fprintf fmt "%a@\n%a" pp x pp (Block xs)
        in
        inner b
    | Concat l -> pp_many fmt l
    | Break -> Format.fprintf fmt "@\n"
    | Anchor s -> Format.fprintf fmt "<a id=\"%s\"></a>" s
    | String s -> Format.fprintf fmt "%s" s
    | Env (indent, s, t, s') ->
        Format.fprintf fmt "@[%s%s%a@]@,%s@]"
          (match indent with Any -> "")
          s pp t s'
    | Command (s, t) -> Format.fprintf fmt "@[%s%a@]" s pp t
    | OpenSqBracket -> Format.fprintf fmt "["
    | CloseSqBracket -> Format.fprintf fmt "]"
    | OpenParenthesis -> Format.fprintf fmt "("
    | CloseParenthesis -> Format.fprintf fmt ")"

  and pp_many fmt l = List.iter (pp fmt) l
end

open Markup

let entity e =
  match e with "#45" -> escaped "-" | "gt" -> str ">" | s -> str "&%s;" s

let raw_markup (_ : Raw_markup.t) = noop

let style (style : style) content =
  match style with
  | `Bold -> command "**" (content ++ str "**")
  | `Italic | `Emphasis -> command "_" (content ++ str "_")
  | `Superscript -> command "<sup>" content
  | `Subscript -> command "<sub>" content

let generate_links = ref false

let rec source_code (s : Source.t) =
  match s with
  | [] -> noop
  | h :: t -> (
      match h with
      | Source.Elt i -> inline i ++ source_code t
      | Tag (None, s) -> source_code s ++ source_code t
      | Tag (Some _, s) -> source_code s ++ source_code t)

and inline (l : Inline.t) =
  match l with
  | [] -> noop
  | i :: rest -> (
      match i.desc with
      | Text "" -> inline rest
      | Text _ ->
          let l, _, rest =
            Doctree.Take.until l ~classify:(function
              | { Inline.desc = Text s; _ } -> Accum [ s ]
              | _ -> Stop_and_keep)
          in
          str {|%s|} (String.concat "" l) ++ inline rest
      | Entity e ->
          let x = entity e in
          x ++ inline rest
      | Styled (sty, content) -> style sty (inline content) ++ inline rest
      | Linebreak -> break ++ inline rest
      | Link (href, content) ->
          if !generate_links then
            (let rec f (content : Inline.t) =
               match content with
               | [] -> noop
               | i :: rest -> (
                   match i.desc with
                   | Text s ->
                       command "" (str "[%s]" s ++ str "(%s)" href) ++ f rest
                   | _ -> noop ++ f rest)
             in
             f content)
            ++ inline rest
          else inline content ++ inline rest
      | InternalLink (Resolved (link, content)) ->
          if !generate_links then
            match link.page.parent with
            | Some _ -> inline content ++ inline rest
            | None ->
                open_sq_bracket ++ inline content ++ close_sq_bracket
                ++ open_parenthesis
                ++ String ("#" ^ link.anchor)
                ++ close_parenthesis ++ inline rest
          else inline content ++ inline rest
      | InternalLink (Unresolved content) -> inline content ++ inline rest
      | Source content ->
          env Any "`` " "`` " (source_code content) ++ inline rest
      | Raw_markup t -> raw_markup t ++ inline rest)

let rec block (l : Block.t) =
  match l with
  | [] -> noop
  | b :: rest -> (
      let continue r = if r = [] then noop else break ++ block r in
      match b.desc with
      | Inline i -> inline i ++ continue rest
      | Paragraph i -> inline i ++ break ++ break ++ continue rest
      | List (list_typ, l) ->
          let f n b =
            let bullet =
              match list_typ with
              | Unordered -> escaped "- "
              | Ordered -> str "%d) " (n + 1)
            in
            bullet ++ block b ++ break
          in
          list ~sep:break (List.mapi f l) ++ continue rest
      | Description _ ->
          let descrs, _, rest =
            Take.until l ~classify:(function
              | { Block.desc = Description l; _ } -> Accum l
              | _ -> Stop_and_keep)
          in
          let f i =
            let key = inline i.Description.key in
            let def = block i.Description.definition in
            break ++ str "@" ++ key ++ str " : " ++ def ++ break ++ break
          in
          list ~sep:break (List.map f descrs) ++ continue rest
      | Source content -> source_code content ++ continue rest
      | Verbatim content -> str "%s" content ++ continue rest
      | Raw_markup t -> raw_markup t ++ continue rest)

let expansion_not_inlined url = not (Link.should_inline url)

let take_code l =
  let c, _, rest =
    Take.until l ~classify:(function
      | DocumentedSrc.Code c -> Accum c
      | DocumentedSrc.Alternative (Expansion e) when expansion_not_inlined e.url
        ->
          Accum e.summary
      | _ -> Stop_and_keep)
  in
  (c, rest)

let heading { Heading.label; level; title } =
  let level =
    match level with
    | 1 -> "#"
    | 2 -> "##"
    | 3 -> "###"
    | 4 -> "####"
    | 5 -> "#####"
    | 6 -> "######"
    | _ -> ""
    (* We can be sure that h6 will never be exceded! *)
  in
  match label with
  | Some _ -> command level (str " " ++ inline title)
  | None -> command (level ^ " ") (inline title)

let inline_subpage = function
  | `Inline | `Open | `Default -> true
  | `Closed -> false

let item_prop nbsp = String ("###### " ^ nbsp)

let rec documented_src (l : DocumentedSrc.t) nbsp =
  match l with
  | [] -> noop
  | line :: rest -> (
      let continue r = documented_src r nbsp in
      match line with
      | Code _ ->
          let c, rest = take_code l in
          source_code c ++ continue rest
      | Alternative alt -> (
          match alt with
          | Expansion { expansion; url; _ } ->
              if expansion_not_inlined url then
                let c, rest = take_code l in
                source_code c ++ continue rest
              else documented_src expansion nbsp)
      | Subpage p -> subpage p.content nbsp ++ continue rest
      | Documented _ | Nested _ ->
          let lines, _, rest =
            Take.until l ~classify:(function
              | DocumentedSrc.Documented { code; doc; anchor; _ } ->
                  Accum [ (`D code, doc, anchor) ]
              | DocumentedSrc.Nested { code; doc; anchor; _ } ->
                  Accum [ (`N code, doc, anchor) ]
              | _ -> Stop_and_keep)
          in
          let f (content, doc, (anchor : Odoc_document.Url.t option)) =
            let doc = match doc with [] -> noop | doc -> block doc in
            let content =
              match content with
              | `D code -> inline code
              | `N l -> documented_src l nbsp
            in
            let anchor = match anchor with Some a -> a.anchor | None -> "" in
            break ++ break ++ Anchor anchor ++ break ++ item_prop nbsp
            ++ content ++ break ++ break ++ str "  " ++ doc ++ break ++ break
          in
          let l = list ~sep:noop (List.map f lines) in
          l ++ continue rest)

and subpage { title = _; header = _; items; url = _ } nbsp =
  let content = items in
  let surround body =
    if content = [] then break else break ++ break ++ body ++ break
  in
  surround @@ item nbsp content

and item nbsp (l : Item.t list) : Markup.t =
  match l with
  | [] -> noop
  | i :: rest -> (
      let continue r = if r = [] then noop else break ++ break ++ item nbsp r in
      match i with
      | Text b -> block b ++ continue rest
      | Heading h -> break ++ heading h ++ break ++ continue rest
      | Declaration { attr = _; anchor; content; doc } ->
          let nbsp' = "&nbsp; &nbsp; &nbsp;" in
          let decl = documented_src content (nbsp ^ nbsp') in
          let doc = match doc with [] -> noop | doc -> block doc ++ break in
          let anchor = match anchor with Some x -> x.anchor | None -> "" in
          Anchor anchor ++ break ++ item_prop nbsp ++ decl ++ break ++ break
          ++ doc ++ continue rest
      | Include
          { attr = _; anchor = _; content = { summary; status; content }; doc }
        ->
          let d =
            if inline_subpage status then item nbsp content
            else
              let s = source_code summary in
              match doc with [] -> s | doc -> s ++ break ++ break ++ block doc
          in
          d ++ continue rest)

let on_sub subp =
  match subp with
  | `Page p -> if Link.should_inline p.Subpage.content.url then Some 1 else None
  | `Include incl -> if inline_subpage incl.Include.status then Some 0 else None

let rec calc_subpages (generate_links : bool) { Subpage.content; _ } =
  [ page generate_links content ]

and subpages generate_links i =
  Utils.flatmap ~f:(calc_subpages generate_links) @@ Doctree.Subpages.compute i

and page generate_links ({ Page.header; items; url; _ } as p) =
  let header = Shift.compute ~on_sub header in
  let items = Shift.compute ~on_sub items in
  let subpages = subpages generate_links p in
  Block
    ([ Inline (Link.for_printing url) ]
    @ [ item "&nbsp; " header ++ item "&nbsp; " items ]
    @ subpages)

let rec subpage subp =
  let p = subp.Subpage.content in
  if Link.should_inline p.url then [] else [ render p ]

and render (p : Page.t) =
  let content fmt =
    Format.fprintf fmt "%a" Markup.pp (page !generate_links p)
  in
  let children = Utils.flatmap ~f:subpage @@ Subpages.compute p in
  let filename = Link.as_filename p.url in
  { Odoc_document.Renderer.filename; content; children }
