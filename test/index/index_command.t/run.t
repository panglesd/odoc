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
        {
          "kind": "Root",
          "name": "Main"
        }
      ],
      "url": "Main/index.html",
      "doc": {
        "html": "<div></div>",
        "txt": ""
      },
      "extra": {
        "kind": "Module"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Type",
          "name": "t"
        }
      ],
      "url": "Main/index.html#type-t",
      "doc": {
        "html": "<div><p>A comment</p></div>",
        "txt": "A comment"
      },
      "extra": {
        "kind": "TypeDecl",
        "private": false,
        "manifest": "int",
        "constraints": []
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Label",
          "name": "this-is-a-title"
        }
      ],
      "url": "Main/index.html#this-is-a-title",
      "doc": {
        "html": "<div><p>this is a title</p></div>",
        "txt": "this is a title"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Heading"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Label",
          "name": "search_label_2"
        }
      ],
      "url": "Main/index.html#search_label_2",
      "doc": {
        "html": "<div><p>and this is a paragraph</p></div>",
        "txt": "and this is a paragraph"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Paragraph"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Module",
          "name": "M"
        }
      ],
      "url": "Main/M/index.html",
      "doc": {
        "html": "<div></div>",
        "txt": ""
      },
      "extra": {
        "kind": "Module"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Module",
          "name": "M"
        },
        {
          "kind": "Type",
          "name": "t"
        }
      ],
      "url": "Main/M/index.html#type-t",
      "doc": {
        "html": "<div><p>dsdsd</p></div>",
        "txt": "dsdsd"
      },
      "extra": {
        "kind": "TypeDecl",
        "private": false,
        "manifest": null,
        "constraints": []
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Value",
          "name": "v"
        }
      ],
      "url": "Main/index.html#val-v",
      "doc": {
        "html": "<div><p>a reference <span><code>t</code></span>, and some <em>formatted</em> <b>content</b> with <code>code</code> and</p><pre class=\"language-ocaml\"><code>code blocks</code></pre></div>",
        "txt": "a reference , and some formatted content with code and\ncode blocks"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Value",
          "name": "lorem"
        }
      ],
      "url": "Main/index.html#val-lorem",
      "doc": {
        "html": "<div><p>lorem 1</p></div>",
        "txt": "lorem 1"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Value",
          "name": "lorem2"
        }
      ],
      "url": "Main/index.html#val-lorem2",
      "doc": {
        "html": "<div><p>lorem 2</p></div>",
        "txt": "lorem 2"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Value",
          "name": "lorem3"
        }
      ],
      "url": "Main/index.html#val-lorem3",
      "doc": {
        "html": "<div><p>lorem 3</p></div>",
        "txt": "lorem 3"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      }
    },
    {
      "id": [
        {
          "kind": "Root",
          "name": "Main"
        },
        {
          "kind": "Value",
          "name": "lorem4"
        }
      ],
      "url": "Main/index.html#val-lorem4",
      "doc": {
        "html": "<div><p>lorem 4</p></div>",
        "txt": "lorem 4"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      }
    }
  ]
  $ cat index.json
  [{"id":[{"kind":"Root","name":"Main"}],"url":"Main/index.html","doc":{"html":"<div></div>","txt":""},"extra":{"kind":"Module"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Type","name":"t"}],"url":"Main/index.html#type-t","doc":{"html":"<div><p>A comment</p></div>","txt":"A comment"},"extra":{"kind":"TypeDecl","private":false,"manifest":"int","constraints":[]}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Label","name":"this-is-a-title"}],"url":"Main/index.html#this-is-a-title","doc":{"html":"<div><p>this is a title</p></div>","txt":"this is a title"},"extra":{"kind":"Doc","subkind":"Heading"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Label","name":"search_label_2"}],"url":"Main/index.html#search_label_2","doc":{"html":"<div><p>and this is a paragraph</p></div>","txt":"and this is a paragraph"},"extra":{"kind":"Doc","subkind":"Paragraph"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Module","name":"M"}],"url":"Main/M/index.html","doc":{"html":"<div></div>","txt":""},"extra":{"kind":"Module"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Module","name":"M"},{"kind":"Type","name":"t"}],"url":"Main/M/index.html#type-t","doc":{"html":"<div><p>dsdsd</p></div>","txt":"dsdsd"},"extra":{"kind":"TypeDecl","private":false,"manifest":null,"constraints":[]}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Value","name":"v"}],"url":"Main/index.html#val-v","doc":{"html":"<div><p>a reference <span><code>t</code></span>, and some <em>formatted</em> <b>content</b> with <code>code</code> and</p><pre class=\"language-ocaml\"><code>code blocks</code></pre></div>","txt":"a reference , and some formatted content with code and\u000Acode blocks"},"extra":{"kind":"Value","type":"int"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Value","name":"lorem"}],"url":"Main/index.html#val-lorem","doc":{"html":"<div><p>lorem 1</p></div>","txt":"lorem 1"},"extra":{"kind":"Value","type":"int"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Value","name":"lorem2"}],"url":"Main/index.html#val-lorem2","doc":{"html":"<div><p>lorem 2</p></div>","txt":"lorem 2"},"extra":{"kind":"Value","type":"int"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Value","name":"lorem3"}],"url":"Main/index.html#val-lorem3","doc":{"html":"<div><p>lorem 3</p></div>","txt":"lorem 3"},"extra":{"kind":"Value","type":"int"}}
  ,{"id":[{"kind":"Root","name":"Main"},{"kind":"Value","name":"lorem4"}],"url":"Main/index.html#val-lorem4","doc":{"html":"<div><p>lorem 4</p></div>","txt":"lorem 4"},"extra":{"kind":"Value","type":"int"}}
  ]

The index.js file need to provide a odoc_search command, from a 

  $ cat fuse.js.js > index.js
  $ echo "\n\nlet documents = " >> index.js
  $ cat index.json >> index.js

  $ echo "\n\nconst options = { keys: ['odoc_id', 'doc.txt'] };" >> index.js
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
  Gtk-Message: 14:50:12.981: Failed to load module "xapp-gtk3-module"
  Gtk-Message: 14:50:12.981: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
