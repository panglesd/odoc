Checking that source links exists inside recursive modules.

  $ odoc compile --child module-main root.mld
  $ ocamlc -c main.ml -bin-annot -I .
  $ odoc compile --source-name main.ml --source-parent page-root -I . main.cmt
  $ odoc link -I . main.odoc
  $ odoc html-generate --source main.ml --indent -o html main.odocl
 
Both modules should contain source links

  $ grep source_link html/Main/A/index.html -C 2
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <a href="../../root/main.ml.html#def-8" class="source_link">Source</a>
       <code><span><span class="keyword">type</span> t</span>
        <span> = <a href="../B/index.html#type-t">B.t</a></span>

  $ grep source_link html/Main/B/index.html -C 2
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <a href="../../root/main.ml.html#def-9" class="source_link">Source</a>
       <code><span><span class="keyword">type</span> t</span><span> = </span>
       </code>

