A quick test to repro the issue found in #857

  $ ocamlc -bin-annot -c a.mli

  $ odoc compile a.cmti
  File "a.mli", line 9, characters 4-9
  File "a.mli", line 9, characters 12-17
  File "a.mli", line 19, characters -3-7
  $ odoc link a.odoc
  File "a.mli", line 19, characters -3-7:
  Warning: Failed to resolve reference unresolvedroot(blibli) Couldn't find "blibli"

  $ odoc html-generate -o html/ a.odocl
  $ odoc support-files -o html/

In html, labels in subpages should not be disambiguated since they won't have the same URL.

  $ find html
  html
  html/fonts
  html/fonts/KaTeX_Script-Regular.woff2
  html/fonts/KaTeX_Size1-Regular.woff2
  html/fonts/fira-sans-v17-latin-500italic.woff2
  html/fonts/KaTeX_Caligraphic-Bold.woff2
  html/fonts/noticia-text-v15-latin-700.woff2
  html/fonts/KaTeX_Typewriter-Regular.woff2
  html/fonts/KaTeX_Size3-Regular.woff2
  html/fonts/KaTeX_Fraktur-Regular.woff2
  html/fonts/fira-sans-v17-latin-500.woff2
  html/fonts/KaTeX_Main-BoldItalic.woff2
  html/fonts/noticia-text-v15-latin-italic.woff2
  html/fonts/KaTeX_SansSerif-Italic.woff2
  html/fonts/fira-sans-v17-latin-italic.woff2
  html/fonts/fira-mono-v14-latin-500.woff2
  html/fonts/fira-sans-v17-latin-700.woff2
  html/fonts/KaTeX_SansSerif-Regular.woff2
  html/fonts/KaTeX_Size2-Regular.woff2
  html/fonts/KaTeX_Math-BoldItalic.woff2
  html/fonts/KaTeX_Caligraphic-Regular.woff2
  html/fonts/KaTeX_Main-Bold.woff2
  html/fonts/KaTeX_Math-Italic.woff2
  html/fonts/KaTeX_Size4-Regular.woff2
  html/fonts/fira-mono-v14-latin-regular.woff2
  html/fonts/KaTeX_AMS-Regular.woff2
  html/fonts/KaTeX_Main-Regular.woff2
  html/fonts/fira-sans-v17-latin-700italic.woff2
  html/fonts/fira-sans-v17-latin-regular.woff2
  html/fonts/KaTeX_Main-Italic.woff2
  html/fonts/KaTeX_SansSerif-Bold.woff2
  html/fonts/noticia-text-v15-latin-regular.woff2
  html/fonts/KaTeX_Fraktur-Bold.woff2
  html/katex.min.js
  html/katex.min.css
  html/A
  html/A/index.html
  html/odoc.css
  html/highlight.pack.js


  $ firefox html/A/index.html
  Gtk-Message: 11:56:56.415: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 11:56:56.416: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
