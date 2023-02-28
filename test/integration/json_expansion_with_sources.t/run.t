Test the JSON output in the presence of expanded modules.

  $ odoc compile --child module-a --child src-source root.mld
  ERROR: Failed to parse child reference: Unknown reference qualifier 'src'.
  [1]

  $ printf "a.ml\nmain.ml\n" > source_tree.map
  $ odoc source-tree -I . --parent page-root -o src-source.odoc source_tree.map
  ERROR: Couldn't find specified parent page
  [1]


  $ ocamlc -c -bin-annot -o main__A.cmo a.ml -I .
  $ ocamlc -c -bin-annot main.ml -I .
  $ odoc compile --source-name a.ml --source-parent-file src-source.odoc -I . main__A.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc compile --source-name main.ml --source-parent-file src-source.odoc -I . main.cmt
  odoc: option '--source-parent-file': no 'src-source.odoc' file or directory
  Usage: odoc compile [OPTION]… FILE
  Try 'odoc compile --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . main__A.odoc
  odoc: FILE.odoc argument: no 'main__A.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]
  $ odoc link -I . main.odoc
  odoc: FILE.odoc argument: no 'main.odoc' file or directory
  Usage: odoc link [--open=MODULE] [OPTION]… FILE.odoc
  Try 'odoc link --help' or 'odoc --help' for more information.
  [2]

  $ odoc html-targets --source a.ml -o html main__A.odocl
  odoc: FILE.odocl argument: no 'main__A.odocl' file or directory
  Usage: odoc html-targets [OPTION]… FILE.odocl
  Try 'odoc html-targets --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-targets --source main.ml -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-targets [OPTION]… FILE.odocl
  Try 'odoc html-targets --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-targets --source a.ml --as-json -o html main__A.odocl
  odoc: FILE.odocl argument: no 'main__A.odocl' file or directory
  Usage: odoc html-targets [OPTION]… FILE.odocl
  Try 'odoc html-targets --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-targets --source main.ml --as-json -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-targets [OPTION]… FILE.odocl
  Try 'odoc html-targets --help' or 'odoc --help' for more information.
  [2]

  $ odoc html-generate --source a.ml --as-json -o html main__A.odocl
  odoc: FILE.odocl argument: no 'main__A.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]
  $ odoc html-generate --source main.ml --as-json -o html main.odocl
  odoc: FILE.odocl argument: no 'main.odocl' file or directory
  Usage: odoc html-generate [OPTION]… FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.
  [2]

  $ cat html/Main/index.html.json
  cat: html/Main/index.html.json: No such file or directory
  [1]

  $ cat html/Main/A/index.html.json
  cat: html/Main/A/index.html.json: No such file or directory
  [1]

  $ cat html/Main/A/B/index.html.json
  cat: html/Main/A/B/index.html.json: No such file or directory
  [1]

  $ cat html/root/source/a.ml.html.json
  cat: html/root/source/a.ml.html.json: No such file or directory
  [1]
