(** {!Format} pretty-printer combinators.
    Consult {{!nameconv}naming conventions} for your pretty-printers.
    {b References}
    {ul
    {- The {!Format} module documentation.}
    {- The required reading {!Format} module
       {{:https://ocaml.org/learn/tutorials/format.html}tutorial}.}}
    {e %%VERSION%% - {{:%%PKG_HOMEPAGE%% }homepage}} *)

(** {1:formatting Formatting} *)

val pf :
  Format.formatter -> ('a, Format.formatter, unit) Pervasives.format -> 'a
(** [pf] is {!Format.fprintf}. *)
