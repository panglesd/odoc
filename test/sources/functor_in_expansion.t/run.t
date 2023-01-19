Verify the behavior on functors.

  $ ocamlc -c -o main__F.cmo f.ml -bin-annot -I .
  $ ocamlc -c -o main__R.cmo r.ml -bin-annot -I .
  $ ocamlc -c -o main.cmo main.ml -bin-annot -I .
  $ odoc compile --impl f.ml -I . main__F.cmt
  List of collected shapes:
  <<predef:int>>
  
  $ odoc compile --impl r.ml -I . main__R.cmt
  List of collected shapes:
  $ odoc compile --impl main.ml -I . main.cmt
  List of collected shapes:
  $ odoc link -I . main__F.odoc
  List of collected shapes:
  <<predef:int>> 
  Trying to reduce:
  <<predef:int>>
  
  $ odoc link -I . main__R.odoc
  List of collected shapes:
  $ odoc link -I . main.odoc
  List of collected shapes:
  $ odoc html-generate --indent -o html main__F.odocl
  $ odoc html-generate --indent -o html main__R.odocl
  $ odoc html-generate --indent -o html main.odocl

  $ find html | sort
  html
  html/Main
  html/Main/Main.ml.html
  html/Main/R
  html/Main/R/index.html
  html/Main/index.html
  html/Main__F
  html/Main__F/Main__F.ml.html
  html/Main__R
  html/Main__R/Main__R.ml.html

In this test, the functor expansion contains the right link.
TODO

  $ cat html/Main/R/index.html | grep source_link --context=2
         <a href="#type-t" class="anchor"></a>
         <a href="../../Main__F/Main__F.ml.html#def-Main__F1"
          class="source_link">Source
         </a>
         <code><span><span class="keyword">type</span> t</span>
  --
         <a href="#val-y" class="anchor"></a>
         <a href="../../Main__F/Main__F.ml.html#def-Main__F2"
          class="source_link">Source
         </a><code><span><span class="keyword">val</span> y : int</span></code>
        </div>

  $ cat html/A/A.ml.html | grep L3
  cat: html/A/A.ml.html: No such file or directory
  [1]

However, on functor results, there is a link to source in the file:

  $ cat html/B/R/index.html | grep source_link --context=2
  cat: html/B/R/index.html: No such file or directory
  [1]

On functor parameter, the link is right (modulo the fact that sub-module type
links are all to the whole module type definition):

  $ cat html/A/F/argument-1-S/index.html | grep source_link --context=1
  cat: html/A/F/argument-1-S/index.html: No such file or directory
  [1]

  $ cat html/A/F/argument-1-S/../../../S/S.ml.html | grep L1
  cat: html/A/F/argument-1-S/../../../S/S.ml.html: No such file or directory
  [1]
