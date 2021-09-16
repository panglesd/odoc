Toplevel_comments

 Module `` Toplevel_comments`` 


A doc comment at the beginning of a module is considered to be that module's doc.

<a id="module-type-T"></a>
###### &nbsp; module type T = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


###### &nbsp; end

Doc of `` T
`` , part 1.




<a id="module-Include_inline"></a>
###### &nbsp; module Include_inline : sig ... ###### &nbsp; end

Doc of `` T
`` , part 2.




<a id="module-Include_inline'"></a>
###### &nbsp; module Include_inline' : sig ... ###### &nbsp; end

Doc of `` Include_inline
`` , part 1.




<a id="module-type-Include_inline_T"></a>
###### &nbsp; module type Include_inline_T = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


###### &nbsp; end

Doc of `` T
`` , part 2.




<a id="module-type-Include_inline_T'"></a>
###### &nbsp; module type Include_inline_T' = sig

<a id="type-t"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;type t


###### &nbsp; end

Doc of `` Include_inline_T'
`` , part 1.




<a id="module-M"></a>
###### &nbsp; module M : sig ... ###### &nbsp; end

Doc of `` M
`` 




<a id="module-M'"></a>
###### &nbsp; module M' : sig ... ###### &nbsp; end

Doc of `` M'
``  from outside




<a id="module-M''"></a>
###### &nbsp; module M'' : sig ... ###### &nbsp; end

Doc of `` M''
`` , part 1.




<a id="module-Alias"></a>
###### &nbsp; module Alias : T

Doc of `` Alias
`` .




<a id="class-c1"></a>
###### &nbsp; class  c1 : int -> object ... ###### &nbsp; end

Doc of `` c1
`` , part 1.




<a id="class-type-ct"></a>
###### &nbsp; class type  ct = object
###### &nbsp; end

Doc of `` ct
`` , part 1.




<a id="class-c2"></a>
###### &nbsp; class  c2 : ct

Doc of `` c2
`` .




<a id="module-Ref_in_synopsis"></a>
###### &nbsp; module Ref_in_synopsis : sig ... ###### &nbsp; end

`` t`` .



Toplevel_commentsT

 Module type `` Toplevel_comments.T`` 


Doc of `` T`` , part 1.



Doc of `` T
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsInclude_inline

 Module `` Toplevel_comments.Include_inline`` 


Doc of `` T
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsInclude_inline'

 Module `` Toplevel_comments.Include_inline'`` 


Doc of `` Include_inline`` , part 1.



Doc of `` Include_inline
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsInclude_inline_T

 Module type `` Toplevel_comments.Include_inline_T`` 


Doc of `` T
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsInclude_inline_T'

 Module type `` Toplevel_comments.Include_inline_T'`` 


Doc of `` Include_inline_T'`` , part 1.



Doc of `` Include_inline_T'
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsM

 Module `` Toplevel_comments.M`` 


Doc of `` M
`` 


Toplevel_commentsM'

 Module `` Toplevel_comments.M'`` 


Doc of `` M'
``  from outside


Toplevel_commentsM''

 Module `` Toplevel_comments.M''`` 


Doc of `` M''`` , part 1.



Doc of `` M''
`` , part 2.


Toplevel_commentsAlias

 Module `` Toplevel_comments.Alias`` 


Doc of `` Alias`` .



Doc of `` T
`` , part 2.

<a id="type-t"></a>
###### &nbsp; type t


Toplevel_commentsc1

 Class `` Toplevel_comments.c1`` 


Doc of `` c1`` , part 1.



Doc of `` c1
`` , part 2.


Toplevel_commentsct

 Class type `` Toplevel_comments.ct`` 


Doc of `` ct`` , part 1.



Doc of `` ct
`` , part 2.


Toplevel_commentsc2

 Class `` Toplevel_comments.c2`` 


Doc of `` c2`` .



Doc of `` ct
`` , part 2.


Toplevel_commentsRef_in_synopsis

 Module `` Toplevel_comments.Ref_in_synopsis`` 


`` t
`` .



This reference should resolve in the context of this module, even when used as a synopsis.

<a id="type-t"></a>
###### &nbsp; type t

