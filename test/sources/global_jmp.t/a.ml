let a = 3

module Make (S : sig
  val x : int
end) =
struct
  let y = S.x + 1
end
