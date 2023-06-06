This is what happens when a dune user write a toplevel module.
Similar to the lookup_def_wrapped test.

  $ odoc compile -c module-a -c src-source root.mld

  $ ocamlc -c -o main__.cmo main__.ml -bin-annot -w -49 -no-alias-deps -I .
  $ ocamlc -c -open Main__ -o main__A.cmo a.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__C.cmo c.ml -bin-annot -I .
  $ ocamlc -c -open Main__ -o main__B.cmo b.ml -bin-annot -I .
  $ ocamlc -c -open Main__ main.ml -bin-annot -I .

  $ odoc compile --count-occurrences -I . main__A.cmt
  $ odoc compile --count-occurrences -I . main__C.cmt
  $ odoc compile --count-occurrences -I . main__B.cmt
  $ odoc compile --count-occurrences -I . main__.cmt
  $ odoc compile --count-occurrences -I . main.cmt

  $ odoc link -I . main.odoc
  $ odoc link -I . main__A.odoc
  $ odoc link -I . main__B.odoc
  $ odoc link -I . main__C.odoc
  $ odoc link -I . main__.odoc

  $ odoc html-generate --indent -o html main.odocl
  $ odoc html-generate --hidden --indent -o html main__.odocl
  $ odoc html-generate --hidden --indent -o html main__A.odocl
  $ odoc html-generate --hidden --indent -o html main__B.odocl
  $ odoc html-generate --hidden --indent -o html main__C.odocl

Look if all the source files are generated:

  $ find html | sort
  html
  html/Main
  html/Main/A
  html/Main/A/index.html
  html/Main/B
  html/Main/B/Z
  html/Main/B/Z/index.html
  html/Main/B/index.html
  html/Main/index.html

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
     <h1>Module <code><span>Main.A</span></code></h1>
    </header>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-x">
       <a href="#val-x" class="anchor"></a>
       <code><span><span class="keyword">val</span> x : int</span></code>
      </div>
     </div>
    </div>
   </body>
  </html>

Now count occurrences

  $ odoc count-occurrences -I . -o occurrences.txt

Uses of A and B are counted correctly, since the path is rewritten correctly.
Uses of C are not counted, since the canonical destination does not exists.
Uses of values Y.x and Z.y (in b.ml) are not counted since they come from a "local" module.
Uses of values Main__.C.y and Main__.A.x are not rewritten since we use references instead of paths.

  $ cat occurrences.txt
  Main.A.x was used 2 times
  Main.A was used 3 times
  Main.B was used 1 times
