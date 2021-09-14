Include2

 Module `` Include2`` 
<a id="module-X"></a>
###### &nbsp; module X : sig ... end

Comment about X that should not appear when including X below.




Comment about X that should not appear when including X below.



<a id="type-t"></a>
###### &nbsp; type t = int



<a id="module-Y"></a>
###### &nbsp; module Y : sig ... end

Top-comment of Y.




<a id="module-Y_include_synopsis"></a>
###### &nbsp; module Y_include_synopsis : sig ... end

The `` include Y``  below should have the synopsis from `` Y
`` 's top-comment attached to it.




<a id="module-Y_include_doc"></a>
###### &nbsp; module Y_include_doc : sig ... end


Include2X

 Module `` Include2.X`` 


Comment about X that should not appear when including X below.

<a id="type-t"></a>
###### &nbsp; type t = int


Include2Y

 Module `` Include2.Y`` 


Top-comment of Y.

<a id="type-t"></a>
###### &nbsp; type t


Include2Y_include_synopsis

 Module `` Include2.Y_include_synopsis`` 


The `` include Y``  below should have the synopsis from `` Y
`` 's top-comment attached to it.

<a id="type-t"></a>
###### &nbsp; type t = Y.t


Include2Y_include_doc

 Module `` Include2.Y_include_doc`` 
<a id="type-t"></a>
###### &nbsp; type t = Y.t

