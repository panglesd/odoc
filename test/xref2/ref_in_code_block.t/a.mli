val f : int -> int
(** A function  *)

val x : int
(** An integer  *)

(** We can use [f] as follows:

    {[
      let i = {{!f}f} {{!x}x} in
      print_int i
    ]}
*)
