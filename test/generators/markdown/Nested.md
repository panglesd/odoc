Nested

 Module `Nested`


This comment needs to be here before #235 is fixed.
# Module


<a id="module-X"></a>
###### &nbsp; module X : sig ... end

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

end

This is module type Y.



# Functor


<a id="module-F"></a>
###### &nbsp; module F (Arg1 : Y) (Arg2 : sig ... end) : sig ... end

This is a functor F.



# Class


<a id="class-z"></a>
###### &nbsp; class virtual  z : object ... end

This is class z.


<a id="class-inherits"></a>
###### &nbsp; class virtual  inherits : object ... end

