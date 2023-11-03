let x = 1

type t = string

module type M = sig end

let (||>) x y = x + y

type t1 = A | B

type t2 = A | B

let _ = (A : t1)

let _ = (A : t2)

let _ = x + x

module M = struct end

module N = M
