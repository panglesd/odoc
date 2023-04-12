A quick test to repro the issue found in #851

  $ ocamlc -bin-annot -c a.mli

  $ odoc compile a.cmti
  $ odoc link a.odoc

  $ odoc html-generate --indent -o html/ a.odocl

  $ find html
  html
  html/A
  html/A/V1
  html/A/V1/Pkg_config
  html/A/V1/Pkg_config/index.html
  html/A/V1/index.html
  html/A/index.html

  $ cat html/A/V1/Pkg_config/index.html
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head><title>Pkg_config (A.V1.Pkg_config)</title>
    <link rel="stylesheet" href="../../../odoc.css"/><meta charset="utf-8"/>
    <meta name="generator" content="odoc %%VERSION%%"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
    <script src="../../../highlight.pack.js"></script>
    <script>let base_url = '../../../'</script>
    <script src="https://cdn.jsdelivr.net/npm/fuse.js/dist/fuse.js"></script>
    <script src="../../../index.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
   </head>
   <body class="odoc">
    <nav class="odoc-nav"><a href="../index.html">Up</a> – 
     <a href="../../index.html">A</a> &#x00BB; <a href="../index.html">V1</a>
      &#x00BB; Pkg_config
    </nav>
    <header class="odoc-preamble">
     <h1>Module <code><span>V1.Pkg_config</span></code></h1>
    </header>
    <nav class="odoc-toc">
     <div class="odoc-search"><h4>Search</h4>
      <input class="search-bar" placeholder="🔎 Search..."/>
      <div class="search-result"></div>
     </div>
    </nav>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec type anchored" id="type-configurator">
       <a href="#type-configurator" class="anchor"></a>
       <code><span><span class="keyword">type</span> configurator</span>
        <span> = <a href="../index.html#type-t">t</a></span>
       </code>
      </div>
     </div>
     <div class="odoc-spec">
      <div class="spec type anchored" id="type-t">
       <a href="#type-t" class="anchor"></a>
       <code><span><span class="keyword">type</span> t</span></code>
      </div>
     </div>
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-get">
       <a href="#val-get" class="anchor"></a>
       <code>
        <span><span class="keyword">val</span> get : 
         <span><a href="#type-configurator">configurator</a> 
          <span class="arrow">&#45;&gt;</span>
         </span> <span><a href="#type-t">t</a> option</span>
        </span>
       </code>
      </div>
      <div class="spec-doc">
       <p>Search pkg-config in the PATH. Returns <code>None</code> if 
        pkg-config is not found.
       </p>
      </div>
     </div>
    </div><script src="../../../fuse_search.js"></script>
   </body>
  </html>
