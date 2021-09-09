OcamlaryDep2

 Module `Ocamlary.Dep2`

# Parameters


<a id="argument-1-Arg"></a>
###### &nbsp; module Arg : sig

<a id="module-type-S"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type S



<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module X : sig

<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module Y : S


end


end




# Signature


<a id="module-A"></a>
###### &nbsp; module A : sig ... end



<a id="module-B"></a>
###### &nbsp; module B = A.Y

