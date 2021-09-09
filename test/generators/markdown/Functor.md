Functor

 Module `Functor`
<a id="module-type-S"></a>
###### &nbsp; module type S = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end



<a id="module-type-S1"></a>
###### &nbsp; module type S1 = sig


## Parameters


<a id="argument-1-_"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module _ : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t


end




## Signature


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end



<a id="module-F1"></a>
###### &nbsp; module F1 (Arg : S) : S



<a id="module-F2"></a>
###### &nbsp; module F2 (Arg : S) : S with type t = Arg.t



<a id="module-F3"></a>
###### &nbsp; module F3 (Arg : S) : sig ... end



<a id="module-F4"></a>
###### &nbsp; module F4 (Arg : S) : S



<a id="module-F5"></a>
###### &nbsp; module F5 () : S

