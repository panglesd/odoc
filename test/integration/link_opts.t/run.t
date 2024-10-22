  $ ocamlc -bin-annot test.ml
  $ mkdir h
  $ odoc compile --output-dir h --parent-id pkg page.mld
  $ odoc compile --output-dir h --parent-id pkg/libname test.cmt

No library or package are passed, no error. This ensures compatibility with Odoc 2.

  $ odoc link -P pkg:h/pkg h/pkg/libname/test.odoc
  $ odoc link -P pkg:h/pkg h/pkg/page-page.odoc
  $ odoc link -L libname:h/pkg/libname h/pkg/libname/test.odoc
  $ odoc link -L libname:h/pkg/libname h/pkg/page-page.odoc

Current library is not passed:

  $ odoc link -P pkg:h/pkg -L otherlib:h/otherpkg h/pkg/libname/test.odoc
  ERROR: The input file must be part of a directory passed as -L
  [1]
  $ odoc link -P pkg:h/pkg -L otherlib:h/otherpkg h/pkg/page-page.odoc

Current package is not passed:

  $ odoc link -P otherpkg:h/otherpkg -L libname:h/pkg/libname h/pkg/libname/test.odoc
  ERROR: The input file must be part of a directory passed as -P
  [1]
  $ odoc link -P otherpkg:h/otherpkg -L libname:h/pkg/libname h/pkg/page-page.odoc
  ERROR: The input file must be part of a directory passed as -P
  [1]
