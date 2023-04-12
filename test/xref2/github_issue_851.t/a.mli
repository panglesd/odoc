module V1 : sig
  type t
  module Pkg_config : sig
    type configurator = t

    type t

    val get : configurator -> t option
    (** Search pkg-config in the PATH. Returns [None] if pkg-config is not found. *)
  end
end
