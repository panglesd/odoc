OcamlaryDep5

 Module `Ocamlary.Dep5`

# Parameters


<a id="argument-1-Arg"></a>
###### &nbsp; module Arg : sig

<a id="module-type-T"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type T



<a id="module-type-S"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type S = sig

<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module X : T



<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module Y : sig
end


end



<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module X : T


end




# Signature


<a id="module-Z"></a>
###### &nbsp; module Z : Arg.S with module Y = Dep3

