Problem happens on cmti:

  $ ocamlc -c test.mli -bin-annot
  $ odoc compile test.cmti
  odoc: internal error, uncaught exception:
        Invalid_argument("List.fold_left2")
        Raised at Stdlib.invalid_arg in file "stdlib.ml", line 30, characters 20-45
        Called from Odoc_xref2__Subst.type_expr in file "src/xref2/subst.ml", line 592, characters 21-59
        Called from Odoc_xref2__Subst.value in file "src/xref2/subst.ml", line 836, characters 19-38
        Called from Odoc_xref2__Component.Delayed.get in file "src/xref2/component.ml", line 61, characters 16-22
        Called from Odoc_xref2__Lang_of.signature_items.inner in file "src/xref2/lang_of.ml", line 444, characters 16-39
        Called from Odoc_xref2__Lang_of.signature in file "src/xref2/lang_of.ml", line 472, characters 12-43
        Called from Odoc_xref2__Lang_of.include_ in file "src/xref2/lang_of.ml", line 649, characters 18-69
        Called from Odoc_xref2__Lang_of.signature_items.inner in file "src/xref2/lang_of.ml", line 446, characters 47-66
        Called from Odoc_xref2__Lang_of.signature in file "src/xref2/lang_of.ml", line 472, characters 12-43
        Called from Odoc_xref2__Lang_of.simple_expansion in file "src/xref2/lang_of.ml", line 601, characters 30-51
        Called from Odoc_xref2__Compile.include_.get_expansion in file "src/xref2/compile.ml", line 425, characters 25-70
        Called from Odoc_xref2__Compile.signature_items.loop in file "src/xref2/compile.ml", line 344, characters 27-41
        Called from Odoc_xref2__Compile.signature in file "src/xref2/compile.ml", line 361, characters 19-49
        Called from Odoc_xref2__Compile.module_type_expr in file "src/xref2/compile.ml", line 710, characters 29-49
        Called from Odoc_xref2__Compile.module_type in file "src/xref2/compile.ml", line 395, characters 21-71
        Called from Odoc_xref2__Compile.signature_items.loop in file "src/xref2/compile.ml", line 319, characters 21-39
        Called from Odoc_xref2__Compile.signature in file "src/xref2/compile.ml", line 361, characters 19-49
        Called from Odoc_xref2__Compile.content.(fun) in file "src/xref2/compile.ml", line 101, characters 15-54
        Called from Odoc_xref2__Compile.unit in file "src/xref2/compile.ml", line 68, characters 21-47
        Called from Odoc_xref2__Lookup_failures.with_ref in file "src/xref2/lookup_failures.ml", line 13, characters 10-14
        Called from Odoc_xref2__Lookup_failures.catch_failures in file "src/xref2/lookup_failures.ml", line 60, characters 20-37
        Called from Odoc_odoc__Compile.resolve_and_substitute in file "src/odoc/compile.ml", line 125, characters 4-49
        Called from Odoc_model__Error.catch in file "src/model/error.ml", line 54, characters 21-27
        Called from Odoc_model__Error.catch_warnings.(fun) in file "src/model/error.ml", line 89, characters 18-22
        Called from Odoc_model__Error.with_ref in file "src/model/error.ml", line 67, characters 12-16
        Re-raised at Odoc_model__Error.with_ref in file "src/model/error.ml", line 72, characters 4-11
        Called from Odoc_odoc__Compile.compile.(fun) in file "src/odoc/compile.ml", line 269, characters 6-147
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 24, characters 19-24
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 22, characters 12-19
        Called from Cmdliner_eval.run_parser in file "cmdliner_eval.ml", line 34, characters 37-44
  [2]

  $ ocamlc -c test.ml -bin-annot
  $ odoc compile test.cmt
  WARNING: not processing the "interface" file. Using "test.cmt" while you should use the .cmti file
  odoc: internal error, uncaught exception:
        Invalid_argument("List.fold_left2")
        Raised at Stdlib.invalid_arg in file "stdlib.ml", line 30, characters 20-45
        Called from Odoc_xref2__Subst.type_expr in file "src/xref2/subst.ml", line 592, characters 21-59
        Called from Odoc_xref2__Subst.value in file "src/xref2/subst.ml", line 836, characters 19-38
        Called from Odoc_xref2__Component.Delayed.get in file "src/xref2/component.ml", line 61, characters 16-22
        Called from Odoc_xref2__Lang_of.signature_items.inner in file "src/xref2/lang_of.ml", line 444, characters 16-39
        Called from Odoc_xref2__Lang_of.signature in file "src/xref2/lang_of.ml", line 472, characters 12-43
        Called from Odoc_xref2__Lang_of.include_ in file "src/xref2/lang_of.ml", line 649, characters 18-69
        Called from Odoc_xref2__Lang_of.signature_items.inner in file "src/xref2/lang_of.ml", line 446, characters 47-66
        Called from Odoc_xref2__Lang_of.signature in file "src/xref2/lang_of.ml", line 472, characters 12-43
        Called from Odoc_xref2__Lang_of.simple_expansion in file "src/xref2/lang_of.ml", line 601, characters 30-51
        Called from Odoc_xref2__Compile.include_.get_expansion in file "src/xref2/compile.ml", line 425, characters 25-70
        Called from Odoc_xref2__Compile.signature_items.loop in file "src/xref2/compile.ml", line 344, characters 27-41
        Called from Odoc_xref2__Compile.signature in file "src/xref2/compile.ml", line 361, characters 19-49
        Called from Odoc_xref2__Compile.module_type_expr in file "src/xref2/compile.ml", line 710, characters 29-49
        Called from Odoc_xref2__Compile.module_type in file "src/xref2/compile.ml", line 395, characters 21-71
        Called from Odoc_xref2__Compile.signature_items.loop in file "src/xref2/compile.ml", line 319, characters 21-39
        Called from Odoc_xref2__Compile.signature in file "src/xref2/compile.ml", line 361, characters 19-49
        Called from Odoc_xref2__Compile.content.(fun) in file "src/xref2/compile.ml", line 101, characters 15-54
        Called from Odoc_xref2__Compile.unit in file "src/xref2/compile.ml", line 68, characters 21-47
        Called from Odoc_xref2__Lookup_failures.with_ref in file "src/xref2/lookup_failures.ml", line 13, characters 10-14
        Called from Odoc_xref2__Lookup_failures.catch_failures in file "src/xref2/lookup_failures.ml", line 60, characters 20-37
        Called from Odoc_odoc__Compile.resolve_and_substitute in file "src/odoc/compile.ml", line 125, characters 4-49
        Called from Odoc_model__Error.catch in file "src/model/error.ml", line 54, characters 21-27
        Called from Odoc_model__Error.catch_warnings.(fun) in file "src/model/error.ml", line 89, characters 18-22
        Called from Odoc_model__Error.with_ref in file "src/model/error.ml", line 67, characters 12-16
        Re-raised at Odoc_model__Error.with_ref in file "src/model/error.ml", line 72, characters 4-11
        Called from Odoc_odoc__Compile.compile.(fun) in file "src/odoc/compile.ml", line 269, characters 6-147
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 24, characters 19-24
        Called from Cmdliner_term.app.(fun) in file "cmdliner_term.ml", line 22, characters 12-19
        Called from Cmdliner_eval.run_parser in file "cmdliner_eval.ml", line 34, characters 37-44
  [2]

But not on cmi:

  $ odoc compile test.cmi
