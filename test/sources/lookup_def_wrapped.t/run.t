Make sure wrapped libraries don't interfere with generating the source code.
Test both canonical paths and hidden units.
It's a simpler case than Dune's wrapping.

  $ odoc compile --child module-main root.mld
  $ ocamlc -c -o main__A.cmi a.mli -bin-annot -I .
  $ ocamlc -c -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -o main__B.cmo b.ml -bin-annot -I .
  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile --source a.ml --source-parent page-root -I . main__A.cmt
  $ odoc compile --source b.ml --source-parent page-root -I . main__B.cmt
  Unknown uid is Main__A.0
  $ odoc compile --source main.ml --source-parent page-root -I . main.cmt

  $ odoc link -I . main__A.odoc
  $ odoc link -I . main__B.odoc
  $ odoc link -I . main.odoc
  Impl info has length 17

  $ odoc html-generate --indent -o html main.odocl
  $ odoc html-generate --hidden --indent -o html main__A.odocl
  $ odoc html-generate --hidden --indent -o html main__B.odocl

Look if all the source files are generated:

  $ find html | sort
  html
  html/Main
  html/Main/A
  html/Main/A/index.html
  html/Main/B
  html/Main/B/index.html
  html/Main/index.html
  html/root
  html/root/a.ml.html
  html/root/b.ml.html
  html/root/main.ml.html

  $ cat html/root/a.ml.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml"><head><title>Source: a.ml (root)</title><link rel="stylesheet" href="../odoc.css"/><meta charset="utf-8"/><meta name="generator" content="odoc %%VERSION%%"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/></head><body class="odoc-src"><nav class="odoc-nav"><a href="index.html">Up</a> – <a href="index.html">root</a> &#x00BB; a.ml</nav><header class="odoc-preamble"><h1>Source file <code><span>a.ml</span></code></h1></header><pre class="source_container"><code class="source_line_column"><a id="L1" class="source_line" href="#L1">1</a>
  </code><code class="source_code"><span><span class="LET">let</span> <span id="x_267"><span id="def-0"><span class="LIDENT">x</span></span></span> <span class="EQUAL">=</span> <span class="INT">1</span><span class="EOL">
  </span></span></code></pre></body></html>
  $ cat html/root/b.ml.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml"><head><title>Source: b.ml (root)</title><link rel="stylesheet" href="../odoc.css"/><meta charset="utf-8"/><meta name="generator" content="odoc %%VERSION%%"/><meta name="viewport" content="width=device-width,initial-scale=1.0"/></head><body class="odoc-src"><nav class="odoc-nav"><a href="index.html">Up</a> – <a href="index.html">root</a> &#x00BB; b.ml</nav><header class="odoc-preamble"><h1>Source file <code><span>b.ml</span></code></h1></header><pre class="source_container"><code class="source_line_column"><a id="L1" class="source_line" href="#L1">1</a>
  </code><code class="source_code"><span><span class="LET">let</span> <span id="x_267"><span id="def-0"><span class="LIDENT">x</span></span></span> <span class="EQUAL">=</span> <span class="UIDENT">Main__A</span><span class="DOT">.</span><span class="LIDENT">x</span><span class="EOL">
  </span></span></code></pre></body></html>

  $ cat html/Main/A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (Main.A)</title>
    <link rel="stylesheet" href="../../odoc.css"/><meta charset="utf-8"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../index.html">Main</a> &#x00BB; A
    </nav>
    <header class="odoc-preamble">
     <h1>Module <code><span>Main.A</span></code>
      <a href="../../root/a.ml.html" class="source_link">Source</a>
     </h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-x">
       <a href="#val-x" class="anchor"></a>
       <a href="../../root/a.ml.html#def-0" class="source_link">Source</a>
       <code><span><span class="keyword">val</span> x : int</span></code>
      </div>
     </div>
    </div>
   </body>
  </html>
