OcamlaryAliases

 Module `` Ocamlary.Aliases`` 


Let's imitate jst's layout.

<a id="module-Foo"></a>
###### &nbsp; module Foo : sig ... end



<a id="module-A'"></a>
###### &nbsp; module A' = Foo.A



<a id="type-tata"></a>
###### &nbsp; type tata = Foo.A.t



<a id="type-tbtb"></a>
###### &nbsp; type tbtb = Foo.B.t



<a id="type-tete"></a>
###### &nbsp; type tete



<a id="type-tata'"></a>
###### &nbsp; type tata' = A'.t



<a id="type-tete2"></a>
###### &nbsp; type tete2 = Foo.E.t



<a id="module-Std"></a>
###### &nbsp; module Std : sig ... end



<a id="type-stde"></a>
###### &nbsp; type stde = Std.E.t




### include of Foo


Just for giggle, let's see what happens when we include `` Foo
`` .



<a id="module-A"></a>
###### &nbsp; module A = Foo.A



<a id="module-B"></a>
###### &nbsp; module B = Foo.B



<a id="module-C"></a>
###### &nbsp; module C = Foo.C



<a id="module-D"></a>
###### &nbsp; module D = Foo.D



<a id="module-E"></a>
###### &nbsp; module E : sig ... end



<a id="type-testa"></a>
###### &nbsp; type testa = A.t



And also, let's refer to `` A.t``  and `` Foo.B.id
`` 



<a id="module-P1"></a>
###### &nbsp; module P1 : sig ... end



<a id="module-P2"></a>
###### &nbsp; module P2 : sig ... end



<a id="module-X1"></a>
###### &nbsp; module X1 = P2.Z



<a id="module-X2"></a>
###### &nbsp; module X2 = P2.Z



<a id="type-p1"></a>
###### &nbsp; type p1 = X1.t



<a id="type-p2"></a>
###### &nbsp; type p2 = X2.t


OcamlaryAliasesFoo

 Module `` Aliases.Foo`` 
<a id="module-A"></a>
###### &nbsp; module A : sig ... end



<a id="module-B"></a>
###### &nbsp; module B : sig ... end



<a id="module-C"></a>
###### &nbsp; module C : sig ... end



<a id="module-D"></a>
###### &nbsp; module D : sig ... end



<a id="module-E"></a>
###### &nbsp; module E : sig ... end


OcamlaryAliasesFooA

 Module `` Foo.A`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesFooB

 Module `` Foo.B`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesFooC

 Module `` Foo.C`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesFooD

 Module `` Foo.D`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesFooE

 Module `` Foo.E`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesStd

 Module `` Aliases.Std`` 
<a id="module-A"></a>
###### &nbsp; module A = Foo.A



<a id="module-B"></a>
###### &nbsp; module B = Foo.B



<a id="module-C"></a>
###### &nbsp; module C = Foo.C



<a id="module-D"></a>
###### &nbsp; module D = Foo.D



<a id="module-E"></a>
###### &nbsp; module E = Foo.E


OcamlaryAliasesE

 Module `` Aliases.E`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesP1

 Module `` Aliases.P1`` 
<a id="module-Y"></a>
###### &nbsp; module Y : sig ... end


OcamlaryAliasesP1Y

 Module `` P1.Y`` 
<a id="type-t"></a>
###### &nbsp; type t



<a id="val-id"></a>
###### &nbsp; val id : t -> t


OcamlaryAliasesP2

 Module `` Aliases.P2`` 
<a id="module-Z"></a>
###### &nbsp; module Z = Z

