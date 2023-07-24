Blablabla

  $ cat index.mld
  {0 Package page}
  
  Some image:
  {%html: <img src="caml.gif" />%}
  
  With the correct {{!asset-"caml.gif"}reference}
  
  
  Directly with an image tag {img!asset-"caml.gif" reference}  {img:https://picsum.photos/200/300 reference}
  
  {image!asset-"caml.gif" reference}
  
  {image:https://picsum.photos/200/300 reference}

And we'll have a module that we'll put underneath this package page.

  $ cat test.mli 
  (** Humpf, let's try accessing the asset:
    {%html: <img src="../caml.gif" />%}
  
      And with a {{!asset-"caml.gif"}reference}
  
      Directly with an image tag {img!asset-"caml.gif" reference}  {img:https://picsum.photos/200/300 reference}
  
  
      {image!asset-"caml.gif" reference}
  
      {image:https://picsum.photos/200/300 reference}
    *)
  
  type t
  (** Nevermind *)

Compile the module first

  $ ocamlc -c -bin-annot test.mli

Then we need to odoc-compile the package mld file, listing its children

  $ odoc compile index.mld --child module-test --child asset-caml.gif

This will have produced a file called 'page-index.odoc'.
Now we can odoc-compile the module odoc file passing that file as parent.

  $ odoc compile test.cmti -I . --parent index

Link and generate the HTML (forgetting the asset!):

  $ for i in *.odoc; do odoc link -I . $i; done
  $ for i in *.odocl; do odoc html-generate $i -o html; done
  File "caml.gif":
  Warning: asset is missing.

Note that the html was generated despite the missing asset (there might be dead refs!)

  $ find html -type f | sort
  html/index/Test/index.html
  html/index/index.html

Which matches the output of the targets command (which emits no warning):

  $ odoc html-targets page-index.odocl -o html
  html/index/index.html

Trying to pass an asset which doesn't exist:
(also: some sed magic due to cmdliner output changing based on the version)

  $ odoc html-generate page-index.odocl --asset caml.gif -o html 2>&1 | \
  > sed 's/…/.../' | sed "s/\`/'/g"
  odoc: option '--asset': no 'caml.gif' file or directory
  Usage: odoc html-generate [OPTION]... FILE.odocl
  Try 'odoc html-generate --help' or 'odoc --help' for more information.

Passing the asset alongside an incorrect one:

  $ mv caml.gif_hidden caml.gif
  $ odoc html-generate page-index.odocl --asset caml.gif --asset test.mli -o html
  File "test.mli":
  Warning: this asset was not declared as a child of index

This time, the asset should have been copied at the right place:

  $ find html -type f | sort
  html/index/Test/index.html
  html/index/caml.gif
  html/index/index.html

Which once again matches the output of the targets command (still no warning!):

  $ odoc html-targets page-index.odocl --asset caml.gif --asset test.mli -o html
  html/index/index.html
  html/index/caml.gif

Let's make sure the manpage and latex renderers "work" too

  $ for i in *.odocl; do odoc man-generate $i -o man; odoc latex-generate $i -o latex; done

  $ find man -type f | sort
  man/index.3o
  man/index/Test.3o

  $ find latex -type f | sort
  latex/index.tex
  latex/index/Test.tex

Notice that the assets are *not* there. This should probably be fixed for the latex backend.
