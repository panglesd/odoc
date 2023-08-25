A quick test to repro the issue found in #857

  $ ocamlc -bin-annot -c a.mli

  $ odoc compile a.cmti
  indentation is 9, nb_blank_lines is 4
  text is
  "let i =
  {{!f}f} {{!x}x} in
  print_int i"
  Before : File "a.mli", line 2, characters 0-5 
  After File "a.mli", line 17, characters 9-14
  Before : File "a.mli", line 2, characters 8-13 
  After File "a.mli", line 17, characters 17-22
  File "a.mli", line 17, characters 9-14
  File "a.mli", line 17, characters 17-22
  indentation is 13, nb_blank_lines is 1
  text is
  "ddd  
     {{!blibli}blu}
  
           sefesf"
  Before : File "a.mli", line 2, characters 3-13 
  After File "a.mli", line 31, characters 16-26
  File "a.mli", line 31, characters 16-26
  $ odoc link a.odoc
  File "a.mli", line 31, characters 16-26:
  Warning: Failed to resolve reference unresolvedroot(blibli) Couldn't find "blibli"
  File "a.mli", line 25, characters 0-13:
  Warning: Failed to resolve reference unresolvedroot(edesff) Couldn't find "edesff"

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
  html/A/X
  html/A/X/index.html
  html/A/index.html
  html/odoc.css
  html/highlight.pack.js


  $ firefox html/A/index.html
  Gtk-Message: 15:06:57.184: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 15:06:57.184: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
