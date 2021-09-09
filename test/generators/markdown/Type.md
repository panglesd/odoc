Type

 Module `Type`
<a id="type-abstract"></a>
###### &nbsp; type abstract

Some _documentation_.


<a id="type-alias"></a>
###### &nbsp; type alias = int



<a id="type-private_"></a>
###### &nbsp; type private_ = private int



<a id="type-constructor"></a>
###### &nbsp; type 'a constructor = 'a



<a id="type-arrow"></a>
###### &nbsp; type arrow = int -> int



<a id="type-higher_order"></a>
###### &nbsp; type higher_order = (int -> int) -> int



<a id="type-labeled"></a>
###### &nbsp; type labeled = l:int -> int



<a id="type-optional"></a>
###### &nbsp; type optional = ?l:int -> int



<a id="type-labeled_higher_order"></a>
###### &nbsp; type labeled_higher_order = (l:int -> int) -> (?l:int -> int) -> int



<a id="type-pair"></a>
###### &nbsp; type pair = int * int



<a id="type-parens_dropped"></a>
###### &nbsp; type parens_dropped = int * int



<a id="type-triple"></a>
###### &nbsp; type triple = int * int * int



<a id="type-nested_pair"></a>
###### &nbsp; type nested_pair = (int * int) * int



<a id="type-instance"></a>
###### &nbsp; type instance = int [constructor](#type-constructor)



<a id="type-long"></a>
###### &nbsp; type long = [labeled_higher_order](#type-labeled_higher_order) -> [ `Bar | `Baz of [triple](#type-triple) ] -> [pair](#type-pair) -> [labeled](#type-labeled) -> [higher_order](#type-higher_order) -> (string -> int) -> (int, float, char, string, char, unit) CamlinternalFormatBasics.fmtty -> [nested_pair](#type-nested_pair) -> [arrow](#type-arrow) -> string -> [nested_pair](#type-nested_pair) array



<a id="type-variant_e"></a>
###### &nbsp; type variant_e = {

<a id="type-variant_e.a"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`a : int;
`

  

}



<a id="type-variant"></a>
###### &nbsp; type variant = 

<a id="type-variant.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A

  



<a id="type-variant.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| B of int

  



<a id="type-variant.C"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| C

  foo



<a id="type-variant.D"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| D

  _bar_



<a id="type-variant.E"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| E of [variant_e](#type-variant_e)

  





<a id="type-variant_c"></a>
###### &nbsp; type variant_c = {

<a id="type-variant_c.a"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`a : int;
`

  

}



<a id="type-gadt"></a>
###### &nbsp; type _ gadt = 

<a id="type-gadt.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A : int [gadt](#type-gadt)

  



<a id="type-gadt.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| B : int -> string [gadt](#type-gadt)

  



<a id="type-gadt.C"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| C : [variant_c](#type-variant_c) -> unit [gadt](#type-gadt)

  





<a id="type-degenerate_gadt"></a>
###### &nbsp; type degenerate_gadt = 

<a id="type-degenerate_gadt.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A : [degenerate_gadt](#type-degenerate_gadt)

  





<a id="type-private_variant"></a>
###### &nbsp; type private_variant = private 

<a id="type-private_variant.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A

  





<a id="type-record"></a>
###### &nbsp; type record = {

<a id="type-record.a"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`a : int;
`

  



<a id="type-record.b"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`mutable b : int;
`

  



<a id="type-record.c"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`c : int;
`

  foo



<a id="type-record.d"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`d : int;
`

  _bar_



<a id="type-record.e"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`e : a. 'a;
`

  

}



<a id="type-polymorphic_variant"></a>
###### &nbsp; type polymorphic_variant = [ 

<a id="type-polymorphic_variant.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```A
`

  



<a id="type-polymorphic_variant.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```B of int
`

  



<a id="type-polymorphic_variant.C"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```C of int * unit
`

  



<a id="type-polymorphic_variant.D"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```D
`

  

 ]



<a id="type-polymorphic_variant_extension"></a>
###### &nbsp; type polymorphic_variant_extension = [ 

<a id="type-polymorphic_variant_extension.polymorphic_variant"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| 
``[polymorphic_variant](#type-polymorphic_variant)
`

  



<a id="type-polymorphic_variant_extension.E"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```E
`

  

 ]



<a id="type-nested_polymorphic_variant"></a>
###### &nbsp; type nested_polymorphic_variant = [ 

<a id="type-nested_polymorphic_variant.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| ```A of [ `B | `C ]
`

  

 ]



<a id="type-private_extenion#row"></a>
###### &nbsp; type private_extenion#row



<a id="type-private_extenion"></a>
###### &nbsp; and private_extenion = private [> 

<a id="type-private_extenion.polymorphic_variant"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`| 
``[polymorphic_variant](#type-polymorphic_variant)
`

  

 ]



<a id="type-object_"></a>
###### &nbsp; type object_ = < a : int; b : int; c : int; >



<a id="module-type-X"></a>
###### &nbsp; module type X = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u


end



<a id="type-module_"></a>
###### &nbsp; type module_ = (module X)



<a id="type-module_substitution"></a>
###### &nbsp; type module_substitution = (module X with type t = int and type u = unit)



<a id="type-covariant"></a>
###### &nbsp; type +'a covariant



<a id="type-contravariant"></a>
###### &nbsp; type -'a contravariant



<a id="type-bivariant"></a>
###### &nbsp; type _ bivariant = int



<a id="type-binary"></a>
###### &nbsp; type ('a, 'b) binary



<a id="type-using_binary"></a>
###### &nbsp; type using_binary = (int, int) [binary](#type-binary)



<a id="type-name"></a>
###### &nbsp; type 'custom name



<a id="type-constrained"></a>
###### &nbsp; type 'a constrained = 'a constraint 'a = int



<a id="type-exact_variant"></a>
###### &nbsp; type 'a exact_variant = 'a constraint 'a = [ `A | `B of int ]



<a id="type-lower_variant"></a>
###### &nbsp; type 'a lower_variant = 'a constraint 'a = [> `A | `B of int ]



<a id="type-any_variant"></a>
###### &nbsp; type 'a any_variant = 'a constraint 'a = [>  ]



<a id="type-upper_variant"></a>
###### &nbsp; type 'a upper_variant = 'a constraint 'a = [< `A | `B of int ]



<a id="type-named_variant"></a>
###### &nbsp; type 'a named_variant = 'a constraint 'a = [< [polymorphic_variant](#type-polymorphic_variant) ]



<a id="type-exact_object"></a>
###### &nbsp; type 'a exact_object = 'a constraint 'a = < a : int; b : int; >



<a id="type-lower_object"></a>
###### &nbsp; type 'a lower_object = 'a constraint 'a = < a : int; b : int; .. >



<a id="type-poly_object"></a>
###### &nbsp; type 'a poly_object = 'a constraint 'a = < a : a. 'a; >



<a id="type-double_constrained"></a>
###### &nbsp; type ('a, 'b) double_constrained = 'a * 'b constraint 'a = int constraint 'b = unit



<a id="type-as_"></a>
###### &nbsp; type as_ = int as 'a * 'a



<a id="type-extensible"></a>
###### &nbsp; type extensible = ..



<a id="extension-decl-Extension"></a>
###### &nbsp; type [extensible](#type-extensible) += 

<a id="extension-Extension"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| Extension

  Documentation for [`Extension
`](#extension-Extension).



<a id="extension-Another_extension"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| Another_extension

  Documentation for [`Another_extension
`](#extension-Another_extension).





<a id="type-mutually"></a>
###### &nbsp; type mutually = 

<a id="type-mutually.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A of [recursive](#type-recursive)

  





<a id="type-recursive"></a>
###### &nbsp; and recursive = 

<a id="type-recursive.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| B of [mutually](#type-mutually)

  





<a id="exception-Foo"></a>
###### &nbsp; exception Foo of int * int

