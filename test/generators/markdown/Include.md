Include

 Module `` Include`` 
<a id="module-type-Not_inlined"></a>
###### &nbsp; module type Not_inlined = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


###### &nbsp; end



<a id="type-t"></a>
###### &nbsp; type t



<a id="module-type-Inlined"></a>
###### &nbsp; module type Inlined = sig

<a id="type-u"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type u


###### &nbsp; end



<a id="type-u"></a>
###### &nbsp; type u



<a id="module-type-Not_inlined_and_closed"></a>
###### &nbsp; module type Not_inlined_and_closed = sig

<a id="type-v"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type v


###### &nbsp; end



include Not_inlined_and_closed

<a id="module-type-Not_inlined_and_opened"></a>
###### &nbsp; module type Not_inlined_and_opened = sig

<a id="type-w"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type w


###### &nbsp; end



<a id="type-w"></a>
###### &nbsp; type w



<a id="module-type-Inherent_Module"></a>
###### &nbsp; module type Inherent_Module = sig

<a id="val-a"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val a : t


###### &nbsp; end





<a id="module-type-Dorminant_Module"></a>
###### &nbsp; module type Dorminant_Module = sig



<a id="val-a"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val a : u


###### &nbsp; end





<a id="val-a"></a>
###### &nbsp; val a : u


IncludeNot_inlined

 Module type `` Include.Not_inlined`` 
<a id="type-t"></a>
###### &nbsp; type t


IncludeInlined

 Module type `` Include.Inlined`` 
<a id="type-u"></a>
###### &nbsp; type u


IncludeNot_inlined_and_closed

 Module type `` Include.Not_inlined_and_closed`` 
<a id="type-v"></a>
###### &nbsp; type v


IncludeNot_inlined_and_opened

 Module type `` Include.Not_inlined_and_opened`` 
<a id="type-w"></a>
###### &nbsp; type w


IncludeInherent_Module

 Module type `` Include.Inherent_Module`` 
<a id="val-a"></a>
###### &nbsp; val a : t


IncludeDorminant_Module

 Module type `` Include.Dorminant_Module`` 


<a id="val-a"></a>
###### &nbsp; val a : u

