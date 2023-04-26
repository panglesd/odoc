Make sure wrapped libraries don't interfere with generating the source code.
Test both canonical paths and hidden units.
It's a simpler case than Dune's wrapping.

$ odoc compile -c module-main -c src-source root.mld

  $ ocamlc -c main.ml -bin-annot -I .

  $ odoc compile -I . main.cmt
  $ odoc compile -I . page.mld

  $ odoc link -I . main.odoc
  $ odoc link -I . page-page.odoc

  $ odoc compile-index -I .

  $ cat index.json | jq
  [
    {
      "id": [
        "Main",
        "lorem4"
      ],
      "url": "Main/index.html#val-lorem4",
      "doc": {
        "txt": "lorem 4",
        "html": "<div><p>lorem 4</p></div>"
      },
      "kind": {
        "kind": "Value",
        "type": {
          "txt": "int",
          "html": "<div><code><span>int</span></code></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "lorem3"
      ],
      "url": "Main/index.html#val-lorem3",
      "doc": {
        "txt": "lorem 3",
        "html": "<div><p>lorem 3</p></div>"
      },
      "kind": {
        "kind": "Value",
        "type": {
          "txt": "int",
          "html": "<div><code><span>int</span></code></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "lorem2"
      ],
      "url": "Main/index.html#val-lorem2",
      "doc": {
        "txt": "lorem 2",
        "html": "<div><p>lorem 2</p></div>"
      },
      "kind": {
        "kind": "Value",
        "type": {
          "txt": "int",
          "html": "<div><code><span>int</span></code></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "lorem"
      ],
      "url": "Main/index.html#val-lorem",
      "doc": {
        "txt": "lorem 1",
        "html": "<div><p>lorem 1</p></div>"
      },
      "kind": {
        "kind": "Value",
        "type": {
          "txt": "int",
          "html": "<div><code><span>int</span></code></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "v"
      ],
      "url": "Main/index.html#val-v",
      "doc": {
        "txt": "a reference , and some formatted content with code and\ncode blocks",
        "html": "<div><p>a reference <span><code>t</code></span>, and some <em>formatted</em> <b>content</b> with <code>code</code> and</p><pre class=\"language-ocaml\"><code>code blocks</code></pre></div>"
      },
      "kind": {
        "kind": "Value",
        "type": {
          "txt": "int",
          "html": "<div><code><span>int</span></code></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "M",
        "t"
      ],
      "url": "Main/M/index.html#type-t",
      "doc": {
        "txt": "dsdsd",
        "html": "<div><p>dsdsd</p></div>"
      },
      "kind": {
        "kind": "TypeDecl",
        "type": {
          "txt": "type t",
          "html": "<div><div class=\"odoc-spec\"><div class=\"spec type\"><code><span><span class=\"keyword\">type</span> t</span></code></div><div class=\"spec-doc\"><p>dsdsd</p></div></div></div>"
        }
      }
    },
    {
      "id": [
        "Main",
        "M"
      ],
      "url": "Main/M/index.html",
      "doc": {
        "txt": "",
        "html": "<div></div>"
      },
      "kind": {
        "kind": "Module"
      }
    },
    {
      "id": [
        "Main",
        "search_label_2"
      ],
      "url": "Main/index.html#search_label_2",
      "doc": {
        "txt": "and this is a paragraph",
        "html": "<div><p>and this is a paragraph</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "Main",
        "this-is-a-title"
      ],
      "url": "Main/index.html#this-is-a-title",
      "doc": {
        "txt": "this is a title",
        "html": "<div><p>this is a title</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "Main",
        "t"
      ],
      "url": "Main/index.html#type-t",
      "doc": {
        "txt": "A comment",
        "html": "<div><p>A comment</p></div>"
      },
      "kind": {
        "kind": "TypeDecl",
        "type": {
          "txt": "type t = int",
          "html": "<div><div class=\"odoc-spec\"><div class=\"spec type\"><code><span><span class=\"keyword\">type</span> t</span><span> = int</span></code></div><div class=\"spec-doc\"><p>A comment</p></div></div></div>"
        }
      }
    },
    {
      "id": [
        "Main"
      ],
      "url": "Main/index.html",
      "doc": {
        "txt": "",
        "html": "<div></div>"
      },
      "kind": {
        "kind": "Module"
      }
    },
    {
      "id": [
        "page",
        "search_label_5"
      ],
      "url": "page.html#search_label_5",
      "doc": {
        "txt": "bliblib",
        "html": "<div><p>bliblib</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "page",
        "search_label_4"
      ],
      "url": "page.html#search_label_4",
      "doc": {
        "txt": "a list of things",
        "html": "<div><p>a list <em>of</em> things</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "page",
        "search_label_3"
      ],
      "url": "page.html#search_label_3",
      "doc": {
        "txt": "and code",
        "html": "<div><pre class=\"language-ocaml\"><code>and code</code></pre></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "page",
        "search_label_2"
      ],
      "url": "page.html#search_label_2",
      "doc": {
        "txt": "some verbatim",
        "html": "<div><pre>some verbatim</pre></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "page",
        "search_label_1"
      ],
      "url": "page.html#search_label_1",
      "doc": {
        "txt": "A paragraph",
        "html": "<div><p>A paragraph</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    },
    {
      "id": [
        "page",
        "a-title"
      ],
      "url": "page.html#a-title",
      "doc": {
        "txt": "A title",
        "html": "<div><p>A title</p></div>"
      },
      "kind": {
        "kind": "Doc"
      }
    }
  ]

The index.js file need to provide a odoc_search command, from a 

  $ cat fuse.js.js > index.js
  $ echo "\n\nlet documents = " >> index.js
  $ cat index.json >> index.js

  $ echo "\n\nconst options = { keys: ['name', 'comment'] };" >> index.js
  $ echo "\nvar idx_fuse = new Fuse(documents, options);" >> index.js
  $ echo "\nfunction odoc_search(query) {let result = idx_fuse.search(query); return result.map(entry => entry.item)};" >> index.js

  $ odoc html-generate --with-search -o html main.odocl
  $ odoc html-generate --with-search -o html page-page.odocl
  $ odoc support-files -o html
  $ cp index.js html/index.js

  $ find html | sort
  html
  html/Main
  html/Main/M
  html/Main/M/index.html
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
  html/highlight.pack.js
  html/index.js
  html/katex.min.css
  html/katex.min.js
  html/odoc.css
  html/odoc_search.js
  html/page.html

  $ firefox html/Main/index.html
  Gtk-Message: 19:58:39.228: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 19:58:39.229: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
