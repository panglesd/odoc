Nested

 Module `` Nested`` 


This comment needs to be here before #235 is fixed.


# Module


<a id="module-X"></a>
###### &nbsp; module X : sig ... ###### &nbsp; end

This is module X.





# Module type


<a id="module-type-Y"></a>
###### &nbsp; module type Y = sig


### Type


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t

Some type.





### Values


<a id="val-y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val y : t

The value of y.



###### &nbsp; end

This is module type Y.





# Functor


<a id="module-F"></a>
###### &nbsp; module F (Arg1 : Y) (Arg2 : sig ... ###### &nbsp; end) : sig ... ###### &nbsp; end

This is a functor F.





# Class


<a id="class-z"></a>
###### &nbsp; class virtual  z : object ... ###### &nbsp; end

This is class z.




<a id="class-inherits"></a>
###### &nbsp; class virtual  inherits : object ... ###### &nbsp; end


NestedX

 Module `` Nested.X`` 


This is module X.



Some additional comments.


# Type


<a id="type-t"></a>
###### &nbsp; type t

Some type.





# Values


<a id="val-x"></a>
###### &nbsp; val x : t

The value of x.



NestedY

 Module type `` Nested.Y`` 


This is module type Y.



Some additional comments.


# Type


<a id="type-t"></a>
###### &nbsp; type t

Some type.





# Values


<a id="val-y"></a>
###### &nbsp; val y : t

The value of y.



NestedF

 Module `` Nested.F`` 


This is a functor F.



Some additional comments.


# Type



# Parameters


<a id="argument-1-Arg1"></a>
###### &nbsp; module Arg1 : sig


### Type


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t

Some type.





### Values


<a id="val-y"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val y : t

The value of y.



###### &nbsp; end



<a id="argument-2-Arg2"></a>
###### &nbsp; module Arg2 : sig


### Type


<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t

Some type.



###### &nbsp; end




# Signature


<a id="type-t"></a>
###### &nbsp; type t = Arg1.t * Arg2.t

Some type.



NestedF1-Arg1

 Parameter `` F.1-Arg1`` 

# Type


<a id="type-t"></a>
###### &nbsp; type t

Some type.





# Values


<a id="val-y"></a>
###### &nbsp; val y : t

The value of y.



NestedF2-Arg2

 Parameter `` F.2-Arg2`` 

# Type


<a id="type-t"></a>
###### &nbsp; type t

Some type.



Nestedz

 Class `` Nested.z`` 


This is class z.



Some additional comments.

<a id="val-y"></a>
###### &nbsp; val y : int

Some value.




<a id="val-y'"></a>
###### &nbsp; val mutable virtual y' : int




# Methods


<a id="method-z"></a>
###### &nbsp; method z : int

Some method.




<a id="method-z'"></a>
###### &nbsp; method private virtual z' : int


Nestedinherits

 Class `` Nested.inherits`` 
<a id=""></a>
###### &nbsp; inherit z

