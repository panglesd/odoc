(**
   {1 Page foo}
   {!//doc/foo} {!/pkg/doc/foo} {!foo}
   {1 Page subdir/bar}
   {!//doc/subdir/bar} {!/pkg/doc/subdir/bar} {!bar}
   {1 Page dup}
   {!//doc/dup} {!/pkg/doc/dup}
   {1 Page subdir/dup}
   {!//doc/subdir/dup} {!/pkg/doc/subdir/dup}
   {1 Module Test}
   {!//libname/Test} {!/pkg/libname/Test} {!./Test} {!Test}
*)

type t
