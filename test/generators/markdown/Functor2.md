Functor2

 Module `` Functor2`` 
<a id="module-type-S"></a>
###### &nbsp; module type S = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end



<a id="module-X"></a>
###### &nbsp; module X (Y : S) (Z : S) : sig ... end



<a id="module-type-XF"></a>
###### &nbsp; module type XF = sig


## Parameters


<a id="argument-1-Y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module Y : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t


end



<a id="argument-2-Z"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;module Z : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;type t


end




## Signature


<a id="type-y_t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type y_t = Y.t



<a id="type-z_t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type z_t = Z.t



<a id="type-x_t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type x_t = y_t


end


Functor2S

 Module type `` Functor2.S`` 
<a id="type-t"></a>
###### &nbsp; type t


Functor2X

 Module `` Functor2.X`` 

# Parameters


<a id="argument-1-Y"></a>
###### &nbsp; module Y : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end



<a id="argument-2-Z"></a>
###### &nbsp; module Z : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end




# Signature


<a id="type-y_t"></a>
###### &nbsp; type y_t = Y.t



<a id="type-z_t"></a>
###### &nbsp; type z_t = Z.t



<a id="type-x_t"></a>
###### &nbsp; type x_t = y_t


Functor2X1-Y

 Parameter `` X.1-Y`` 
<a id="type-t"></a>
###### &nbsp; type t


Functor2X2-Z

 Parameter `` X.2-Z`` 
<a id="type-t"></a>
###### &nbsp; type t


Functor2XF

 Module type `` Functor2.XF`` 

# Parameters


<a id="argument-1-Y"></a>
###### &nbsp; module Y : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end



<a id="argument-2-Z"></a>
###### &nbsp; module Z : sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


end




# Signature


<a id="type-y_t"></a>
###### &nbsp; type y_t = Y.t



<a id="type-z_t"></a>
###### &nbsp; type z_t = Z.t



<a id="type-x_t"></a>
###### &nbsp; type x_t = y_t


Functor2XF1-Y

 Parameter `` XF.1-Y`` 
<a id="type-t"></a>
###### &nbsp; type t


Functor2XF2-Z

 Parameter `` XF.2-Z`` 
<a id="type-t"></a>
###### &nbsp; type t

