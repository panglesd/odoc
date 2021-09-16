Recent_impl

 Module `` Recent_impl`` 
<a id="module-Foo"></a>
###### &nbsp; module Foo : sig ... ###### &nbsp; end



<a id="module-B"></a>
###### &nbsp; module B : sig ... ###### &nbsp; end



<a id="type-u"></a>
###### &nbsp; type u



<a id="module-type-S"></a>
###### &nbsp; module type S = sig

<a id="module-F"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module F : sig


## Parameters


<a id="argument-1-_"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module _ : sig
###### &nbsp; end




## Signature


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t


###### &nbsp; end



<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module X : sig
###### &nbsp; end



<a id="val-f"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val f : F(X).t


###### &nbsp; end



<a id="module-B'"></a>
###### &nbsp; module B' = Foo.B


Recent_implFoo

 Module `` Recent_impl.Foo`` 
<a id="module-A"></a>
###### &nbsp; module A : sig ... ###### &nbsp; end



<a id="module-B"></a>
###### &nbsp; module B : sig ... ###### &nbsp; end


Recent_implFooA

 Module `` Foo.A`` 
<a id="type-t"></a>
###### &nbsp; type t = 

<a id="type-t.A"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A

  




Recent_implFooB

 Module `` Foo.B`` 
<a id="type-t"></a>
###### &nbsp; type t = 

<a id="type-t.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| B

  




Recent_implB

 Module `` Recent_impl.B`` 
<a id="type-t"></a>
###### &nbsp; type t = 

<a id="type-t.B"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| B

  




Recent_implS

 Module type `` Recent_impl.S`` 
<a id="module-F"></a>
###### &nbsp; module F : sig


## Parameters


<a id="argument-1-_"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module _ : sig
###### &nbsp; end




## Signature


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


###### &nbsp; end



<a id="module-X"></a>
###### &nbsp; module X : sig
###### &nbsp; end



<a id="val-f"></a>
###### &nbsp; val f : F(X).t


Recent_implSF

 Module `` S.F`` 

# Parameters


<a id="argument-1-_"></a>
###### &nbsp; module _ : sig
###### &nbsp; end




# Signature


<a id="type-t"></a>
###### &nbsp; type t


Recent_implSF1-_

 Parameter `` F.1-_`` 

Recent_implSX

 Module `` S.X`` 
