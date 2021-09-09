OcamlaryDep7

 Module `Ocamlary.Dep7`

# Parameters


<a id="argument-1-Arg"></a>
###### &nbsp; module Arg : sig

<a id="module-type-S"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type S



<a id="module-type-T"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type T = sig

<a id="module-type-R"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module type R = S



<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module Y : R


end



<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module X : sig

<a id="module-type-R"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module type R = S



<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module Y : R


end


end




# Signature


<a id="module-M"></a>
###### &nbsp; module M : Arg.T

