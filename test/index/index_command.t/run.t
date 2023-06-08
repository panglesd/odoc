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
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "a-title"
        }
      ],
      "url": "page.html#a-title",
      "doc": {
        "html": "<div><p>A title</p></div>",
        "txt": "A title"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Heading"
      },
      "display": {
        "id": [
          "page",
          "a-title"
        ],
        "url": "page.html#a-title",
        "kind": "doc",
        "doc": "<div><p>A title</p></div>"
      }
    },
    {
      "id": [
        {
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "search_label_1"
        }
      ],
      "url": "page.html#search_label_1",
      "doc": {
        "html": "<div><p>A paragraph</p></div>",
        "txt": "A paragraph"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Paragraph"
      },
      "display": {
        "id": [
          "page",
          "search_label_1"
        ],
        "url": "page.html#search_label_1",
        "kind": "doc",
        "doc": "<div><p>A paragraph</p></div>"
      }
    },
    {
      "id": [
        {
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "search_label_2"
        }
      ],
      "url": "page.html#search_label_2",
      "doc": {
        "html": "<div><pre>some verbatim</pre></div>",
        "txt": "some verbatim"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Verbatim"
      },
      "display": {
        "id": [
          "page",
          "search_label_2"
        ],
        "url": "page.html#search_label_2",
        "kind": "doc",
        "doc": "<div><pre>some verbatim</pre></div>"
      }
    },
    {
      "id": [
        {
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "search_label_3"
        }
      ],
      "url": "page.html#search_label_3",
      "doc": {
        "html": "<div><pre class=\"language-ocaml\"><code>and code</code></pre></div>",
        "txt": "and code"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "CodeBlock"
      },
      "display": {
        "id": [
          "page",
          "search_label_3"
        ],
        "url": "page.html#search_label_3",
        "kind": "doc",
        "doc": "<div><pre class=\"language-ocaml\"><code>and code</code></pre></div>"
      }
    },
    {
      "id": [
        {
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "search_label_4"
        }
      ],
      "url": "page.html#search_label_4",
      "doc": {
        "html": "<div><p>a list <em>of</em> things</p></div>",
        "txt": "a list of things"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Paragraph"
      },
      "display": {
        "id": [
          "page",
          "search_label_4"
        ],
        "url": "page.html#search_label_4",
        "kind": "doc",
        "doc": "<div><p>a list <em>of</em> things</p></div>"
      }
    },
    {
      "id": [
        {
          "kind": "Page",
          "name": "page"
        },
        {
          "kind": "Label",
          "name": "search_label_5"
        }
      ],
      "url": "page.html#search_label_5",
      "doc": {
        "html": "<div><p>bliblib</p></div>",
        "txt": "bliblib"
      },
      "extra": {
        "kind": "Doc",
        "subkind": "Paragraph"
      },
      "display": {
        "id": [
          "page",
          "search_label_5"
        ],
        "url": "page.html#search_label_5",
        "kind": "doc",
        "doc": "<div><p>bliblib</p></div>"
      }
    },
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
      },
      "display": {
        "id": [
          "Main"
        ],
        "url": "Main/index.html",
        "kind": "module",
        "doc": "<div></div>"
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
      },
      "display": {
        "rhs": " = int",
        "id": [
          "Main",
          "t"
        ],
        "url": "Main/index.html#type-t",
        "kind": "type",
        "doc": "<div><p>A comment</p></div>"
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
      },
      "display": {
        "id": [
          "Main",
          "this-is-a-title"
        ],
        "url": "Main/index.html#this-is-a-title",
        "kind": "doc",
        "doc": "<div><p>this is a title</p></div>"
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
      },
      "display": {
        "id": [
          "Main",
          "search_label_2"
        ],
        "url": "Main/index.html#search_label_2",
        "kind": "doc",
        "doc": "<div><p>and this is a paragraph</p></div>"
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
      },
      "display": {
        "id": [
          "Main",
          "M"
        ],
        "url": "Main/M/index.html",
        "kind": "module",
        "doc": "<div></div>"
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
      },
      "display": {
        "id": [
          "Main",
          "M",
          "t"
        ],
        "url": "Main/M/index.html#type-t",
        "kind": "type",
        "doc": "<div><p>dsdsd</p></div>"
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
      },
      "display": {
        "rhs": " : int",
        "id": [
          "Main",
          "v"
        ],
        "url": "Main/index.html#val-v",
        "kind": "val",
        "doc": "<div><p>a reference <span><code>t</code></span>, and some <em>formatted</em> <b>content</b> with <code>code</code> and</p><pre class=\"language-ocaml\"><code>code blocks</code></pre></div>"
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
        "html": "<div><p>lorem 1 and a <span>link</span></p></div>",
        "txt": "lorem 1 and a link"
      },
      "extra": {
        "kind": "Value",
        "type": "int"
      },
      "display": {
        "rhs": " : int",
        "id": [
          "Main",
          "lorem"
        ],
        "url": "Main/index.html#val-lorem",
        "kind": "val",
        "doc": "<div><p>lorem 1 and a <span>link</span></p></div>"
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
      },
      "display": {
        "rhs": " : int",
        "id": [
          "Main",
          "lorem2"
        ],
        "url": "Main/index.html#val-lorem2",
        "kind": "val",
        "doc": "<div><p>lorem 2</p></div>"
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
      },
      "display": {
        "rhs": " : int",
        "id": [
          "Main",
          "lorem3"
        ],
        "url": "Main/index.html#val-lorem3",
        "kind": "val",
        "doc": "<div><p>lorem 3</p></div>"
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
      },
      "display": {
        "rhs": " : int",
        "id": [
          "Main",
          "lorem4"
        ],
        "url": "Main/index.html#val-lorem4",
        "kind": "val",
        "doc": "<div><p>lorem 4</p></div>"
      }
    }
  ]

The index.js file need to provide a odoc_search command, from a 

  $ cat fuse.js.js > index.js
  $ echo "\n\nlet documents = " >> index.js
  $ cat index.json >> index.js

  $ echo "\n\nconst options = { keys: ['id', 'doc.txt'] };" >> index.js
  $ echo "\nvar idx_fuse = new Fuse(documents, options);" >> index.js
  $ echo "\nonmessage = (m) => {\n  let query = m.data;\n  let result = idx_fuse.search(query);\n  postMessage(result.slice(0,200).map(a => a.item.display));};" >> index.js

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

Run
 $ firefox html/Main/index.html
to manually test the search
