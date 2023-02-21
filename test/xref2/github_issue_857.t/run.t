A quick test to repro the issue found in #857

  $ compile a.mli
  File "a.mli", line 3, characters 13-21:
  Warning: Multiple sections named 'first' found. Please alter one to ensure reference is unambiguous. Locations:
    File "a.mli", line 6, character 2
    File "a.mli", line 11, character 6
  File "a.mli", line 11, characters 6-35:
  Warning: While resolving the expansion of include at File "a.mli", line 14, character 0
  Label 'first' is ambiguous. The other occurences are:
    File "a.mli", line 6, character 2
  File "a.mli", line 6, characters 2-31:
  Warning: Label 'first' is ambiguous. The other occurences are:
    File "a.mli", line 11, character 6
  $ odoc html-generate --indent -o html/ a.odocl
  $ odoc latex-generate -o latex/ a.odocl
  $ find latex
  latex
  latex/test
  latex/test/A.tex
  $ cat latex/test/A.tex
  \section{Module \ocamlinlinecode{A}}\label{page-test-module-A}%
  Outer
  
  Reference: \hyperref[page-test-module-A-first]{\ocamlinlinecode{First inner section}[p\pageref*{page-test-module-A-first}]}.
  
  Label:
  
  \subsection{First outer section\label{first}}%
  \label{page-test-module-A-module-type-A}\ocamlcodefragment{\ocamltag{keyword}{module} \ocamltag{keyword}{type} \hyperref[page-test-module-A-module-type-A]{\ocamlinlinecode{A}}}\ocamlcodefragment{ = \ocamltag{keyword}{sig}}\begin{ocamlindent}\subsubsection{First inner section\label{first_2}}%
  \end{ocamlindent}%
  \ocamlcodefragment{\ocamltag{keyword}{end}}\\
  \ocamltag{keyword}{include} \hyperref[page-test-module-A-module-type-A]{\ocamlinlinecode{A}}\subsection{First inner section\label{first_3}}%
  
  
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
     <p>Outer</p><p>Reference: <a href="#first">First inner section</a>.</p>
     <p>Label:</p>
    </header>
    <nav class="odoc-toc">
     <ul><li><a href="#first">First outer section</a></li></ul>
    </nav>
    <div class="odoc-content">
     <h2 id="first"><a href="#first" class="anchor"></a>First outer section
     </h2>
     <div class="odoc-spec">
      <div class="spec module-type anchored" id="module-type-A">
       <a href="#module-type-A" class="anchor"></a>
       <code>
        <span><span class="keyword">module</span> 
         <span class="keyword">type</span> 
         <a href="module-type-A/index.html">A</a>
        </span>
        <span> = <span class="keyword">sig</span> ... 
         <span class="keyword">end</span>
        </span>
       </code>
      </div>
     </div>
     <div class="odoc-include">
      <details open="open">
       <summary class="spec include">
        <code>
         <span><span class="keyword">include</span> 
          <a href="module-type-A/index.html">A</a>
         </span>
        </code>
       </summary>
       <h2 id="first_3"><a href="#first_3" class="anchor"></a>First inner
         section
       </h2>
      </details>
     </div>
    </div>
   </body>
  </html>

  $ cat html/test/A/module-type-A/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>A (test.A.A)</title>
    <link rel="stylesheet" href="../../../odoc.css"/><meta charset="utf-8"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../../highlight.pack.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../../index.html">test</a> &#x00BB; <a href="../index.html">A</a>
      &#x00BB; A
    </nav>
    <header class="odoc-preamble">
     <h1>Module type <code><span>A.A</span></code></h1>
    </header>
    <nav class="odoc-toc">
     <ul><li><a href="#first">First inner section</a></li></ul>
    </nav>
    <div class="odoc-content">
     <h2 id="first"><a href="#first" class="anchor"></a>First inner section
     </h2>
    </div>
   </body>
  </html>
