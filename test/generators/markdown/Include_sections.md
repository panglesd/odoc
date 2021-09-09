Include_sections

 Module `Include_sections`
<a id="module-type-Something"></a>
###### &nbsp; module type Something = sig

<a id="val-something"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val something : unit




## Something 1


foo



<a id="val-foo"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val foo : unit




### Something 2


<a id="val-bar"></a>
###### &nbsp; &nbsp; &nbsp; &nbsp;val bar : unit

foo bar





## Something 1-bis


Some text.


end

A module type.




Let's include `Something
` once




# Something 1


foo




## Something 2



# Something 1-bis


Some text.




# Second include


Let's include `Something
` a second time: the heading level should be shift here.




## Something 1


foo




### Something 2



## Something 1-bis


Some text.




## Third include


Shifted some more.




### Something 1


foo




#### Something 2



### Something 1-bis


Some text.



And let's include it again, but without inlining it this time: the ToC shouldn't grow.



<a id="val-something"></a>
###### &nbsp; val something : unit




### Something 1


foo



<a id="val-foo"></a>
###### &nbsp; val foo : unit




#### Something 2


<a id="val-bar"></a>
###### &nbsp; val bar : unit

foo bar





### Something 1-bis


Some text.

