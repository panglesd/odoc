val a : int

module Make (S : sig
  val x : int
end) : sig
  val y : int
end
