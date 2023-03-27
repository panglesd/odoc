Make sure wrapped libraries don't interfere with generating the source code.
Test both canonical paths and hidden units.
It's a simpler case than Dune's wrapping.

$ odoc compile -c module-main -c src-source root.mld

  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile -I . main.cmt

  $ odoc link -I . main.odoc

  $ odoc index -I .


  $ cat index.index
  var documents = [
   {
     "name": "Main",
     "url": "Main/index.html",
     
   },
      
  
   {
     "name": "v",
     "url": "Main/index.html#val-v",
     "comment": "title and a reference "
   },
      
  
   {
     "name": "t",
     "url": "Main/index.html#type-t",
     "comment": "A comment"
   },
      
  ] ; 
   
  
    var idx = lunr(function () {
      this.ref('url')
      this.field('name')
      this.field('comment')
  
      documents.forEach(function (doc) {
        this.add(doc)
      }, this)
    })
    
    const options = { keys: ['name', 'comment'] };
    var idx_fuse = new Fuse(documents, options);
  
  document.querySelector(".search-bar").addEventListener("input", (event) => {
      let results = idx_fuse.search(event.target.value);
      let search_result = document.querySelector(".search-result");
      search_result.innerHTML = "";
      let f = (entry) => {
          let container = document.createElement("a");
          container.style = "display:flex; margin: 10px;"
          let name = document.createElement("div");
          name.style = "padding-right: 10px;"
          name.innerText = entry.item.name;
          let comment = document.createElement("div");
          comment.innerText = entry.item.comment;
          container.href = base_url + entry.item.url;
          container.appendChild(name);
          container.appendChild(comment);
          search_result.appendChild(container);
      } ;
      results.map(f);
  });
  


  $ odoc html-generate -o html main.odocl
  $ odoc support-files -o html
  $ cp index.index html/index.js
  $ find html
  html
  html/fonts
  html/fonts/KaTeX_Script-Regular.woff2
  html/fonts/KaTeX_Size1-Regular.woff2
  html/fonts/KaTeX_Caligraphic-Bold.woff2
  html/fonts/KaTeX_Typewriter-Regular.woff2
  html/fonts/KaTeX_Size3-Regular.woff2
  html/fonts/KaTeX_Fraktur-Regular.woff2
  html/fonts/KaTeX_Main-BoldItalic.woff2
  html/fonts/KaTeX_SansSerif-Italic.woff2
  html/fonts/KaTeX_SansSerif-Regular.woff2
  html/fonts/KaTeX_Size2-Regular.woff2
  html/fonts/KaTeX_Math-BoldItalic.woff2
  html/fonts/KaTeX_Caligraphic-Regular.woff2
  html/fonts/KaTeX_Main-Bold.woff2
  html/fonts/KaTeX_Math-Italic.woff2
  html/fonts/KaTeX_Size4-Regular.woff2
  html/fonts/KaTeX_AMS-Regular.woff2
  html/fonts/KaTeX_Main-Regular.woff2
  html/fonts/KaTeX_Main-Italic.woff2
  html/fonts/KaTeX_SansSerif-Bold.woff2
  html/fonts/KaTeX_Fraktur-Bold.woff2
  html/Main
  html/Main/index.html
  html/index.js
  html/katex.min.js
  html/katex.min.css
  html/odoc.css
  html/highlight.pack.js

  $ firefox html/Main/index.html
  Gtk-Message: 10:36:33.250: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 10:36:33.251: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
