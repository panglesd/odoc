#if OCAML_VERSION >= (4,14,0)
let get_type_desc = Types.get_desc
#else
let get_type_desc t = t.Types.desc
#endif

type 'a pattern =
#if OCAML_VERSION >= (4,11,0)
  'a Typedtree.general_pattern
#else
  Typedtree.pattern
#endif

type 'a pattern_desc =
#if OCAML_VERSION >= (4,11,0)
  'a Typedtree.pattern_desc
#else
  Typedtree.pattern_desc
#endif

(** Extract longident and constructor description from a pattern construct,
    when it is one. *)
let get_pattern_construct_info (type a) : a pattern_desc -> _ = function
#if OCAML_VERSION >= (4,13,0)
  | Typedtree.Tpat_construct (l, { cstr_res; _ }, _, _)
#else
  | Tpat_construct (l, { cstr_res; _ }, _)
#endif
    -> Some (l, cstr_res)
  | _ -> None


module Tast_iterator = struct
#if OCAML_VERSION >= (4,09,0)
  include Tast_iterator
#else
  open Asttypes
  open Typedtree

  type iterator =
    {
      expr: iterator -> expression -> unit;
      module_expr: iterator -> module_expr -> unit;
      class_type: iterator -> class_type -> unit;
      module_type: iterator -> module_type -> unit;
      pat: iterator -> pattern -> unit;
      typ: iterator -> core_type -> unit;
    }

  let default_iterator = {
    expr = fun _ _ -> () ;
    module_expr = fun _ _ -> () ;
    class_type = fun _ _ -> () ;
    module_type = fun _ _ -> () ;
    pat = fun _ _ -> () ;
    typ = fun _ _ -> () ;
}
#endif
end
