  $ ocamlc -c -bin-annot unit.ml

  $ odoc compile --output-dir _odoc/ --parent-id pkg/doc/dir1 dir1/my_page.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/doc/dir1 dir1/index.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/doc file.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/doc index.mld
  $ odoc compile --output-dir _odoc/ --parent-id pkg/lib/libname unit.cmt

  $ odoc_print _odoc/pkg/doc/page-index.odoc

  $ odoc link -P pkg:_odoc/pkg/doc/ _odoc/pkg/doc/page-file.odoc
  $ odoc link -P pkg:_odoc/pkg/doc/ _odoc/pkg/doc/dir1/page-my_page.odoc
  $ odoc link -P pkg:_odoc/pkg/doc/ _odoc/pkg/doc/dir1/page-index.odoc
  $ odoc link -P pkg:_odoc/pkg/doc/ _odoc/pkg/doc/page-index.odoc
  $ odoc link -P pkg:_odoc/pkg/doc/ _odoc/pkg/lib/libname/unit.odoc

  $ odoc compile-index -P pkg:_odoc/pkg/doc/ -L libname:_odoc/pkg/lib/libname -o sidebar.odoc-index
  $ odoc html-generate --indent --index sidebar.odoc-index -o html _odoc/pkg/doc/page-file.odocl
  $ odoc html-generate --indent --index sidebar.odoc-index -o html _odoc/pkg/doc/dir1/page-my_page.odocl
  $ odoc html-generate --indent --index sidebar.odoc-index -o html _odoc/pkg/doc/dir1/page-index.odocl
  $ odoc html-generate --indent --index sidebar.odoc-index -o html _odoc/pkg/doc/page-index.odocl
  $ odoc html-generate --indent --index sidebar.odoc-index -o html _odoc/pkg/lib/libname/unit.odocl

  $ cat html/pkg/doc/index.html | grep odoc-global-toc -A 15
     <nav class="odoc-toc odoc-global-toc"><b>pkg's Pages</b>
      <ul><li>root<ul></ul></li></ul><b>Libraries</b>
      <ul>
       <li><b>libname</b>
        <ul><li><a href="../lib/libname/Unit/index.html">Unit</a></li></ul>
       </li>
      </ul>
     </nav>
    </div><div class="odoc-content"></div>
   </body>
  </html>

  $ cat html/pkg/lib/libname/Unit/index.html | grep odoc-global-toc -A 15
     <nav class="odoc-toc odoc-global-toc"><b>pkg's Pages</b>
      <ul><li>root<ul></ul></li></ul><b>Libraries</b>
      <ul>
       <li><b>libname</b>
        <ul><li><a href="#" class="current_unit">Unit</a></li></ul>
       </li>
      </ul>
     </nav>
    </div>
    <div class="odoc-content">
     <div class="odoc-spec">
      <div class="spec value anchored" id="val-x">
       <a href="#val-x" class="anchor"></a>
       <code><span><span class="keyword">val</span> x : int</span></code>
      </div>
     </div>

  $ odoc support-files -o html
$ cp -r html /tmp/html
