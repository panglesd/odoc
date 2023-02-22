A quick test to repro the issue found in #857

  $ compile a.mli
  File "a.mli", line 13, characters 51-68:
  13 |   Format.formatter -> ('a, Format.formatter, unit) Pervasives.format -> 'a
                                                          ^^^^^^^^^^^^^^^^^
  Alert deprecated: module Stdlib.Pervasives
  Use Stdlib instead.
  
  If you need to stay compatible with OCaml < 4.07, you can use the 
  stdlib-shims library: https://github.com/ocaml/stdlib-shims
  File "a.mli", line 6, characters 28-37:
  Warning: Failed to resolve reference unresolvedroot(Format) Couldn't find "Format"
  File "a.mli", line 5, characters 11-20:
  Warning: Failed to resolve reference unresolvedroot(Format) Couldn't find "Format"
  File "a.mli", line 2, characters 12-43:
  Warning: Failed to resolve reference unresolvedroot(nameconv) Couldn't find "nameconv"
  File "a.mli", line 1, characters 4-13:
  Warning: Failed to resolve reference unresolvedroot(Format) Couldn't find "Format"
  File "a.mli", line 14, characters 12-29:
  Warning: Failed to resolve reference unresolvedroot(Format).fprintf Couldn't find "Format"
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
     <p><code>Format</code> pretty-printer combinators. Consult 
      <span class="xref-unresolved">naming conventions</span> for your 
      pretty-printers. <b>References</b>
     </p>
     <ul><li>The <code>Format</code> module documentation.</li>
      <li>The required reading <code>Format</code> module 
       <a href="https://ocaml.org/learn/tutorials/format.html">tutorial</a>
       .
      </li>
     </ul><p><em>%%VERSION%% - <a href="%%PKG_HOMEPAGE%%">homepage</a></em></p>
    </header>
    <nav class="odoc-toc">
     <ul><li><a href="#formatting">Formatting</a></li></ul>
    </nav>
    <div class="odoc-content">
     <h2 id="formatting"><a href="#formatting" class="anchor"></a>Formatting
     </h2>
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-pf">
       <a href="#val-pf" class="anchor"></a>
       <code>
        <span><span class="keyword">val</span> pf : 
                                                      
         <span><span class="xref-unresolved">Stdlib</span>.Format.formatter
           <span class="arrow">&#45;&gt;</span>
         </span>
                  
         <span>
          <span>
           <span>(<span class="type-var">'a</span>, 
            <span class="xref-unresolved">Stdlib</span>.Format.formatter
            , unit)
           </span> <span class="xref-unresolved">Stdlib</span>.Pervasives
           .format
          </span> <span class="arrow">&#45;&gt;</span>
         </span>
                  
         <span class="type-var">'a</span>
        </span>
       </code>
      </div>
      <div class="spec-doc">
       <p><code>pf</code> is <code>Format</code>.fprintf.</p>
      </div>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/module-type-A/index.html
  cat: html/test/A/module-type-A/index.html: No such file or directory
  [1]
