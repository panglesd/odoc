OcamlaryFunctorTypeOf

 Module `Ocamlary.FunctorTypeOf`


This comment is for `FunctorTypeOf
`.


# Parameters


<a id="argument-1-Collection"></a>
###### &nbsp; module Collection : sig

This comment is for `CollectionModule
`.



<a id="type-collection"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type collection

This comment is for `collection
`.




<a id="type-element"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type element



<a id="module-InnerModuleA"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module InnerModuleA : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t = collection

This comment is for `t
`.




<a id="module-InnerModuleA'"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module InnerModuleA' : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t = (unit, unit) [a_function](#type-a_function)

This comment is for `t`.



end

This comment is for `InnerModuleA'
`.




<a id="module-type-InnerModuleTypeA'"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module type InnerModuleTypeA' = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t = InnerModuleA'.t

This comment is for `t`.



end

This comment is for `InnerModuleTypeA'`.



end

This comment is for `InnerModuleA
`.




<a id="module-type-InnerModuleTypeA"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type InnerModuleTypeA = InnerModuleA.InnerModuleTypeA'

This comment is for `InnerModuleTypeA
`.



end




# Signature


<a id="type-t"></a>
###### &nbsp; type t = Collection.collection

This comment is for `t
`.


