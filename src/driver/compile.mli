type compiled

val init_stats : Packages.set -> unit

val compile : Fpath.t -> Packages.set -> compiled list

type linked

val link : compiled list -> linked list

val index : linked list -> unit

val html_generate : Fpath.t -> linked list -> unit