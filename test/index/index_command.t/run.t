Make sure wrapped libraries don't interfere with generating the source code.
Test both canonical paths and hidden units.
It's a simpler case than Dune's wrapping.

$ odoc compile -c module-main -c src-source root.mld

  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile -I . main.cmt

  $ odoc link -I . main.odoc

  $ odoc fuse-index -I . -o html

  $ cat html/index.js
  var documents = [
   {
     "name": "Main",
     "kind": "root",
     "url": "Main/index.html",
     
   },
      
  
   {
     "name": "lorem",
     "kind": "value",
     "url": "Main/index.html#val-lorem",
     "comment": "Aliquam erat volutpat. Nunc eleifend leo vitae magna. In id erat non orci commodo lobortis. Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus. Sed diam. Praesent fermentum tempor tellus. Nullam tempus. Mauris ac felis vel velit tristique imperdiet. Donec at pede. Etiam vel neque nec dui dignissim bibendum. Vivamus id enim. Phasellus neque orci, porta a, aliquet quis, semper a, massa. Phasellus purus. Pellentesque tristique imperdiet tortor. Nam euismod tellus id erat."
   },
      
  
   {
     "name": "v",
     "kind": "value",
     "url": "Main/index.html#val-v",
     "comment": "a reference "
   },
      
  
   {
     "name": "t",
     "kind": "type",
     "url": "Main/index.html#type-t",
     "comment": "A comment"
   },
      
  ] ; 
   
  const options = { keys: ['name', 'comment'] };
  var idx_fuse = new Fuse(documents, options);
    


  $ odoc html-generate -o html main.odocl
  $ odoc support-files -o html
  $ find html | sort
  html
  html/Main
  html/Main/index.html
  html/fonts
  html/fonts/KaTeX_AMS-Regular.woff2
  html/fonts/KaTeX_Caligraphic-Bold.woff2
  html/fonts/KaTeX_Caligraphic-Regular.woff2
  html/fonts/KaTeX_Fraktur-Bold.woff2
  html/fonts/KaTeX_Fraktur-Regular.woff2
  html/fonts/KaTeX_Main-Bold.woff2
  html/fonts/KaTeX_Main-BoldItalic.woff2
  html/fonts/KaTeX_Main-Italic.woff2
  html/fonts/KaTeX_Main-Regular.woff2
  html/fonts/KaTeX_Math-BoldItalic.woff2
  html/fonts/KaTeX_Math-Italic.woff2
  html/fonts/KaTeX_SansSerif-Bold.woff2
  html/fonts/KaTeX_SansSerif-Italic.woff2
  html/fonts/KaTeX_SansSerif-Regular.woff2
  html/fonts/KaTeX_Script-Regular.woff2
  html/fonts/KaTeX_Size1-Regular.woff2
  html/fonts/KaTeX_Size2-Regular.woff2
  html/fonts/KaTeX_Size3-Regular.woff2
  html/fonts/KaTeX_Size4-Regular.woff2
  html/fonts/KaTeX_Typewriter-Regular.woff2
  html/fuse_search.js
  html/highlight.pack.js
  html/index.js
  html/katex.min.css
  html/katex.min.js
  html/odoc.css

  $ firefox html/Main/index.html
  Gtk-Message: 16:49:28.337: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 16:49:28.338: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
