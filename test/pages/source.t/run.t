Files containing some values:

  $ cat a.ml
  let x = 2
  let y = x + 1
  let z = x + y
  $ cat a.mli
  val x : int
  val y : int
  val z : int

Compile the modules:

  $ ocamlc -c a.mli -bin-annot

Compile the pages:

  $ odoc compile a.cmti
  $ for i in *.odoc; do odoc link -I . $i; done
  $ odoc html --impl a.ml --intf a.mli -o html a.odoc

Check the generated pages:

  $ find html -type f | sort
  html/A/index.html
  html/a.ml
  html/a.mli

  $ tidy -q -w 160 -ashtml -utf8 html/a.ml
  <!DOCTYPE html>
  <html>
  <head>
  <meta name="generator" content="HTML Tidy for HTML5 for Apple macOS version 5.8.0">
  <meta charset="utf-8">
  <title>a.ml (a.ml)</title>
  <link rel="stylesheet" href="odoc.css">
  <meta name="generator" content="odoc %%VERSION%%">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <script src="highlight.pack.js"></script>
  <script>
  hljs.initHighlightingOnLoad();
  </script>
  </head>
  <body class="odoc">
  <header class="odoc-preamble"></header>
  <div class="odoc-content">
  <div class="odoc-spec">
  <div class="spec anchored" id="L1"><a href="#L1" class="anchor"></a><code>let x = 2</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L2"><a href="#L2" class="anchor"></a><code>let y = x + 1</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L3"><a href="#L3" class="anchor"></a><code>let z = x + y</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L4"><a href="#L4" class="anchor"></a></div>
  </div>
  </div>
  </body>
  </html>

  $ tidy -q -w 160 -ashtml -utf8 html/a.mli
  <!DOCTYPE html>
  <html>
  <head>
  <meta name="generator" content="HTML Tidy for HTML5 for Apple macOS version 5.8.0">
  <meta charset="utf-8">
  <title>a.mli (a.mli)</title>
  <link rel="stylesheet" href="odoc.css">
  <meta name="generator" content="odoc %%VERSION%%">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <script src="highlight.pack.js"></script>
  <script>
  hljs.initHighlightingOnLoad();
  </script>
  </head>
  <body class="odoc">
  <header class="odoc-preamble"></header>
  <div class="odoc-content">
  <div class="odoc-spec">
  <div class="spec anchored" id="L1"><a href="#L1" class="anchor"></a><code>val x : int</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L2"><a href="#L2" class="anchor"></a><code>val y : int</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L3"><a href="#L3" class="anchor"></a><code>val z : int</code></div>
  </div>
  <div class="odoc-spec">
  <div class="spec anchored" id="L4"><a href="#L4" class="anchor"></a></div>
  </div>
  </div>
  </body>
  </html>
