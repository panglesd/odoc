  $ ocamlc -c -bin-annot unit.ml

  $ odoc compile --output-dir _odoc/ --parent-id pkg/dir1 dir1/my_page.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/dir1 dir1/index.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg file.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg index.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/libname unit.cmt

  $ odoc link -P pkg:_odoc/pkg/ -L libname:_odoc/pkg/libname _odoc/pkg/page-file.odoc
  $ odoc link -P pkg:_odoc/pkg/ _odoc/pkg/dir1/page-my_page.odoc
  $ odoc link -P pkg:_odoc/pkg/ _odoc/pkg/dir1/page-index.odoc
  $ odoc link -P pkg:_odoc/pkg/ _odoc/pkg/page-index.odoc
  $ odoc link -P pkg:_odoc/pkg/ _odoc/pkg/libname/unit.odoc

  $ odoc compile-index -P pkg:_odoc/pkg/ -L libname:_odoc/pkg/libname -o sidebar.odoc-index
  $ odoc sidebar-generate sidebar.odoc-index
  $ odoc html-generate --indent --sidebar sidebar.odoc-sidebar -o html _odoc/pkg/page-file.odocl
  $ odoc html-generate --indent --sidebar sidebar.odoc-sidebar -o html _odoc/pkg/dir1/page-my_page.odocl
  $ odoc html-generate --indent --sidebar sidebar.odoc-sidebar -o html _odoc/pkg/dir1/page-index.odocl
  $ odoc html-generate --indent --sidebar sidebar.odoc-sidebar -o html _odoc/pkg/page-index.odocl
  $ odoc html-generate --indent --sidebar sidebar.odoc-sidebar -o html _odoc/pkg/libname/unit.odocl

  $ odoc sidebar-generate --json sidebar.odoc-index
  $ cat sidebar.json | jq
  {
    "pages": [
      {
        "name": "pkg",
        "pages": {
          "node": {
            "url": "pkg/index.html",
            "kind": "leaf-page",
            "content": "<a href=\"pkg/index.html\">Package <code>pkg</code></a>"
          },
          "children": [
            {
              "node": {
                "url": "pkg/dir1/index.html",
                "kind": "leaf-page",
                "content": "<a href=\"pkg/dir1/index.html\">A directory</a>"
              },
              "children": [
                {
                  "node": {
                    "url": "pkg/dir1/my_page.html",
                    "kind": "leaf-page",
                    "content": "<a href=\"pkg/dir1/my_page.html\">My page</a>"
                  },
                  "children": []
                }
              ]
            },
            {
              "node": {
                "url": "pkg/file.html",
                "kind": "leaf-page",
                "content": "<a href=\"pkg/file.html\">File</a>"
              },
              "children": []
            }
          ]
        }
      }
    ],
    "libraries": [
      {
        "name": "libname",
        "pages": [
          {
            "node": {
              "url": "pkg/libname/Unit/index.html",
              "kind": "module",
              "content": "<a href=\"pkg/libname/Unit/index.html\">Unit</a>"
            },
            "children": [
              {
                "node": {
                  "url": "pkg/libname/Unit/X/index.html",
                  "kind": "module",
                  "content": "<a href=\"pkg/libname/Unit/X/index.html\">X</a>"
                },
                "children": []
              },
              {
                "node": {
                  "url": "pkg/libname/Unit/module-type-Y/index.html",
                  "kind": "module-type",
                  "content": "<a href=\"pkg/libname/Unit/module-type-Y/index.html\">Y</a>"
                },
                "children": []
              }
            ]
          }
        ]
      }
    ]
  }

  $ cat html/pkg/index.html | grep odoc-global-toc -A 15
     <nav class="odoc-toc odoc-global-toc">
      <ul class="odoc-modules">
       <li><b>Library <code>libname</code></b>
        <ul><li><a href="libname/Unit/index.html">Unit</a></li></ul>
       </li>
      </ul><b>Documentation</b>
      <ul class="odoc-pages">
       <li><a href="#" class="current_unit">Package <code>pkg</code></a>
        <ul>
         <li><a href="dir1/index.html">A directory</a>
          <ul><li><a href="dir1/my_page.html">My page</a></li></ul>
         </li><li><a href="file.html">File</a></li>
        </ul>
       </li>
      </ul>
     </nav>

  $ cat html/pkg/libname/Unit/index.html | grep odoc-global-toc -A 15
     <nav class="odoc-toc odoc-global-toc">
      <ul class="odoc-modules">
       <li><b>Library <code>libname</code></b>
        <ul>
         <li><a href="#" class="current_unit">Unit</a>
          <ul><li><a href="X/index.html">X</a></li>
           <li><a href="module-type-Y/index.html">Y</a></li>
          </ul>
         </li>
        </ul>
       </li>
      </ul><b>Documentation</b>
      <ul class="odoc-pages">
       <li><a href="../../index.html">Package <code>pkg</code></a>
        <ul>
         <li><a href="../../dir1/index.html">A directory</a>

  $ odoc support-files -o html
$ cp -r html /tmp/html
