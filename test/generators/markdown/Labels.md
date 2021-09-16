Labels

 Module `` Labels`` 

# Attached to unit



# Attached to nothing


<a id="module-A"></a>
###### &nbsp; module A : sig ... end



<a id="type-t"></a>
###### &nbsp; type t

Attached to type




<a id="val-f"></a>
###### &nbsp; val f : t

Attached to value




<a id="val-e"></a>
###### &nbsp; val e : unit -> t

Attached to external




<a id="module-type-S"></a>
###### &nbsp; module type S = sig


### Attached to module type

end



<a id="class-c"></a>
###### &nbsp; class  c : object ... end



<a id="class-type-cs"></a>
###### &nbsp; class type  cs = object


### Attached to class type

end



<a id="exception-E"></a>
###### &nbsp; exception E

Attached to exception




<a id="type-x"></a>
###### &nbsp; type x = ..



<a id="extension-decl-X"></a>
###### &nbsp; type x += 

<a id="extension-X"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| X

  



Attached to extension




<a id="module-S"></a>
###### &nbsp; module S := A

Attached to module subst




<a id="type-s"></a>
###### &nbsp; type s := t

Attached to type subst




<a id="type-u"></a>
###### &nbsp; type u = 

<a id="type-u.A'"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;| A'

  Attached to constructor







<a id="type-v"></a>
###### &nbsp; type v = {

<a id="type-v.f"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;`` f : t;
`` 

  Attached to field



}



Testing that labels can be referenced


- Attached to unit

- Attached to nothing

- Attached to module

- Attached to type

- Attached to value

- Attached to class

- Attached to class type

- Attached to exception

- Attached to extension

- Attached to module subst

- Attached to type subst

- Attached to constructor

- Attached to field

LabelsA

 Module `` Labels.A`` 

# Attached to module

LabelsS

 Module type `` Labels.S`` 

# Attached to module type

Labelsc

 Class `` Labels.c`` 

# Attached to class

Labelscs

 Class type `` Labels.cs`` 

# Attached to class type
