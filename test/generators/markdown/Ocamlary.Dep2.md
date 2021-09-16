OcamlaryDep2

 Module `` Ocamlary.Dep2`` 

# Parameters


<a id="argument-1-Arg"></a>
###### &nbsp; module Arg : sig

<a id="module-type-S"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module type S



<a id="module-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module X : sig

<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;module Y : S


###### &nbsp; end


###### &nbsp; end




# Signature


<a id="module-A"></a>
###### &nbsp; module A : sig ... ###### &nbsp; end



<a id="module-B"></a>
###### &nbsp; module B = A.Y


OcamlaryDep21-Arg

 Parameter `` Dep2.1-Arg`` 
<a id="module-type-S"></a>
###### &nbsp; module type S



<a id="module-X"></a>
###### &nbsp; module X : sig

<a id="module-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module Y : S


###### &nbsp; end


OcamlaryDep21-ArgX

 Module `` 1-Arg.X`` 
<a id="module-Y"></a>
###### &nbsp; module Y : S


OcamlaryDep2A

 Module `` Dep2.A`` 
<a id="module-Y"></a>
###### &nbsp; module Y : Arg.S

