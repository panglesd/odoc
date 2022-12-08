open Odoc_model.Paths
type impl_shape

val lookup_def :
  impl_shape -> Identifier.t -> Odoc_model.Lang.Locations.uid option

val of_cmt : Cmt_format.cmt_infos -> impl_shape option
(** Returns [None] if the cmt doesn't have a shape (eg. if it is not an
    implementation). Returns [Some _] even if shapes are not implemented.

    In case of [Some _], returns both the shape and the relevant infos taken
    from the [cmt]. *)
