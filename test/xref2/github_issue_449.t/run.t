A quick test to repro the issue found in #456

  $ compile a.mli
  File "a.mli", line 6, characters 8-19:
  Warning: Failed to resolve reference unresolvedroot(m) Couldn't find "m"
  $ odoc html-generate --indent -o html/ a.odocl
  $ odoc support-files -o html/
  $ cat html/test/A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (test.A)</title>
    <link rel="stylesheet" href="../../odoc.css"/><meta charset="utf-8"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../index.html">test</a> &#x00BB; A
    </nav>
    <header class="odoc-preamble"><h1>Module <code><span>A</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec class anchored" id="class-c">
       <a href="#class-c" class="anchor"></a>
       <code><span><span class="keyword">class</span>  </span>
        <span><a href="class-c/index.html">c</a></span>
        <span> : <span class="keyword">object</span> ... 
         <span class="keyword">end</span>
        </span>
       </code>
      </div>
     </div>
     <div class="odoc-spec">
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <code><span><span class="keyword">type</span> t</span><span> = </span>
        <span>{</span>
       </code>
       <ol>
        <li id="type-t.x" class="def record field anchored">
         <a href="#type-t.x" class="anchor"></a>
         <code><span>x : int;</span></code>
        </li>
        <li id="type-t.y" class="def record field anchored">
         <a href="#type-t.y" class="anchor"></a>
         <code><span>y : int;</span></code>
         <div class="def-doc"><span class="comment-delim">(*</span>
          <p><a href="#type-t.x"><code>x</code></a></p>
          <span class="comment-delim">*)</span>
         </div>
        </li>
       </ol><code><span>}</span></code>
      </div>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/module-type-A/index.html
  cat: html/test/A/module-type-A/index.html: No such file or directory
  [1]
