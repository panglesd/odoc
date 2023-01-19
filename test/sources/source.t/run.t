Files containing some values:

  $ cat a.ml
  (* type t = string *)
  
  let x = 2
  let y = x + 1
  let z a = if x = 1 || true then x + y else 0
  
  module A = struct end
  module B = A
  
  module type T = sig end
  module type U = T
  
  type ext = ..
  type ext += Foo
  
  exception Exn
  
  class cls = object end
  class cls' = cls
  class type ct = object end
  
  module XX = struct
    let c = 1
  end
  
  let bli = XX.c

Compile the modules:

  $ ocamlc -c a.ml -bin-annot

Compile the pages:

  $ odoc compile --impl a.ml a.cmt
  Found an expression: Stdlib!.+
  Shape is :
  CU Stdlib . "+"[value]
  
  Found an expression: x/267
  Shape is :
  <A.0>
  
  Found an expression: Stdlib!.||
  Shape is :
  CU Stdlib . "||"[value]
  
  Found an expression: Stdlib!.=
  Shape is :
  CU Stdlib . "="[value]
  
  Found an expression: x/267
  Shape is :
  <A.0>
  
  Found an expression: Stdlib!.+
  Shape is :
  CU Stdlib . "+"[value]
  
  Found an expression: x/267
  Shape is :
  <A.0>
  
  Found an expression: y/268
  Shape is :
  <A.1>
  
  Found an expression: XX/295[11].c
  Shape is :
  <A.16>
  
  List of collected shapes:
  <A.16> 
  <A.1> 
  <A.0> 
  CU Stdlib . "+"[value]
  
  <A.0> 
  CU Stdlib . "="[value] 
  CU Stdlib . "||"[value] 
  <A.0>
  
  CU Stdlib . "+"[value]
  
  $ odoc link -I . a.odoc
  List of collected shapes:
  <A.16> 
  <A.1> 
  <A.0> 
  CU Stdlib . "+"[value] 
  
  <A.0> 
  CU Stdlib . "="[value] 
  CU Stdlib . "||"[value] 
  <A.0>
  
  CU Stdlib . "+"[value] 
  Trying to reduce:
  <A.16>
  
  Trying to reduce:
  <A.1>
  
  Trying to reduce:
  <A.0>
  
  Trying to reduce:
  CU Stdlib . "+"[value]
  
  Trying to reduce:
  <A.0>
  
  Trying to reduce:
  CU Stdlib . "="[value]
  
  Trying to reduce:
  CU Stdlib . "||"[value]
  
  Trying to reduce:
  <A.0>
  
  Trying to reduce:
  CU Stdlib . "+"[value]
  
  $ odoc html-generate --indent -o html a.odocl

Source links generated in the documentation:

  $ grep source_link html/A/index.html -B 2
      <div class="spec value anchored" id="val-x">
       <a href="#val-x" class="anchor"></a>
       <a href="A.ml.html#def-A0" class="source_link">Source</a>
  --
      <div class="spec value anchored" id="val-y">
       <a href="#val-y" class="anchor"></a>
       <a href="A.ml.html#def-A1" class="source_link">Source</a>
  --
      <div class="spec value anchored" id="val-z">
       <a href="#val-z" class="anchor"></a>
       <a href="A.ml.html#def-A2" class="source_link">Source</a>
  --
      <div class="spec module anchored" id="module-A">
       <a href="#module-A" class="anchor"></a>
       <a href="A.ml.html#def-A4" class="source_link">Source</a>
  --
      <div class="spec module anchored" id="module-B">
       <a href="#module-B" class="anchor"></a>
       <a href="A.ml.html#def-A4" class="source_link">Source</a>
  --
      <div class="spec module-type anchored" id="module-type-T">
       <a href="#module-type-T" class="anchor"></a>
       <a href="A.ml.html#def-A6" class="source_link">Source</a>
  --
      <div class="spec module-type anchored" id="module-type-U">
       <a href="#module-type-U" class="anchor"></a>
       <a href="A.ml.html#def-A7" class="source_link">Source</a>
  --
      <div class="spec type anchored" id="type-ext">
       <a href="#type-ext" class="anchor"></a>
       <a href="A.ml.html#def-A8" class="source_link">Source</a>
  --
      <div class="spec type extension anchored" id="extension-decl-Foo">
       <a href="#extension-decl-Foo" class="anchor"></a>
       <a href="A.ml.html#def-A9" class="source_link">Source</a>
  --
      <div class="spec exception anchored" id="exception-Exn">
       <a href="#exception-Exn" class="anchor"></a>
       <a href="A.ml.html#def-A10" class="source_link">Source</a>
  --
      <div class="spec class anchored" id="class-cls">
       <a href="#class-cls" class="anchor"></a>
       <a href="A.ml.html#def-A11" class="source_link">Source</a>
  --
      <div class="spec class anchored" id="class-cls'">
       <a href="#class-cls'" class="anchor"></a>
       <a href="A.ml.html#def-A13" class="source_link">Source</a>
  --
      <div class="spec class-type anchored" id="class-type-ct">
       <a href="#class-type-ct" class="anchor"></a>
       <a href="A.ml.html#def-A14" class="source_link">Source</a>
  --
      <div class="spec module anchored" id="module-XX">
       <a href="#module-XX" class="anchor"></a>
       <a href="A.ml.html#def-A16" class="source_link">Source</a>
  --
      <div class="spec value anchored" id="val-bli">
       <a href="#val-bli" class="anchor"></a>
       <a href="A.ml.html#def-A17" class="source_link">Source</a>

Ids generated in the source code:

  $ cat html/A/A.ml.html | tr '> ' '\n\n' | grep '^id'
  id="L1"
  id="L2"
  id="L3"
  id="L4"
  id="L5"
  id="L6"
  id="L7"
  id="L8"
  id="L9"
  id="L10"
  id="L11"
  id="L12"
  id="L13"
  id="L14"
  id="L15"
  id="L16"
  id="L17"
  id="L18"
  id="L19"
  id="L20"
  id="L21"
  id="L22"
  id="L23"
  id="L24"
  id="L25"
  id="L26"
  id="def-A0"
  id="x_267"
  id="def-A1"
  id="y_268"
  id="def-A2"
  id="z_269"
  id="a_271"
  id="def-A4"
  id="def-A5"
  id="def-A6"
  id="def-A7"
  id="def-A8"
  id="def-A9"
  id="def-A10"
  id="def-A11"
  id="def-A13"
  id="def-A14"
  id="def-A16"
  id="def-A15"
  id="c_294"
  id="def-A17"
  id="bli_296"
