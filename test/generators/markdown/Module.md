Module

 Module `Module`


Foo.<a id="val-foo"></a>
###### &nbsp; val foo : unit

The module needs at least one signature item, otherwise a bug causes the compiler to drop the module comment (above). See 
[https://caml.inria.fr/mantis/view.php?id=7701](https://caml.inria.fr/mantis/view.php?id=7701).


<a id="module-type-S"></a>
###### &nbsp; module type S = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M : sig
end


end



<a id="module-type-S1"></a>
###### &nbsp; module type S1



<a id="module-type-S2"></a>
###### &nbsp; module type S2 = S



<a id="module-type-S3"></a>
###### &nbsp; module type S3 = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t = int



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u = string



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M : sig
end


end



<a id="module-type-S4"></a>
###### &nbsp; module type S4 = sig

<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M : sig
end


end



<a id="module-type-S5"></a>
###### &nbsp; module type S5 = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M : sig
end


end



<a id="type-result"></a>
###### &nbsp; type ('a, 'b) result



<a id="module-type-S6"></a>
###### &nbsp; module type S6 = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M : sig
end


end



<a id="module-M'"></a>
###### &nbsp; module M' : sig ... end



<a id="module-type-S7"></a>
###### &nbsp; module type S7 = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w



<a id="module-M"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module M = M'


end



<a id="module-type-S8"></a>
###### &nbsp; module type S8 = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t



<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u



<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type 'a v



<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type ('a, 'b) w


end



<a id="module-type-S9"></a>
###### &nbsp; module type S9 = sig
end



<a id="module-Mutually"></a>
###### &nbsp; module Mutually : sig ... end



<a id="module-Recursive"></a>
###### &nbsp; module Recursive : sig ... end

