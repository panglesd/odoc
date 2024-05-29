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

open Odoc_model

val compilation_unit :
  ?sidebar:Lang.Sidebar.t -> Lang.Compilation_unit.t -> Types.Document.t

val page : ?sidebar:Lang.Sidebar.t -> Lang.Page.t -> Types.Document.t
(** Convert compilation unit or page models into a document *)

val source_tree : Lang.SourceTree.t -> Types.Document.t list

val implementation :
  Lang.Implementation.t ->
  Syntax_highlighter.infos ->
  string ->
  Types.Document.t list
(** Highlight the source as OCaml syntax *)
