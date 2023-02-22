A quick test to repro the issue found in #456

  $ compile a.mli
  File "a.mli", line 10, characters 4-8:
  Warning: Failed to resolve reference unresolvedroot(t) Couldn't find "t"
  $ odoc html-generate --indent -o html/ a.odocl
  Warning, resolved hidden path: {t}1
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
      <div class="spec value anchored" id="val-f">
       <a href="#val-f" class="anchor"></a>
       <code>
        <span><span class="keyword">val</span> f : 
         <span class="xref-unresolved">{t}1</span>
        </span>
       </code>
      </div><div class="spec-doc"><p><code>t</code></p></div>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/module-type-A/index.html
  cat: html/test/A/module-type-A/index.html: No such file or directory
  [1]
