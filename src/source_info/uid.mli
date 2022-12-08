open Types

#if OCAML_VERSION >= (4,14,0)
type uid = Shape.Uid.t
#else
type uid = unit
#endif

val string_of_uid : uid -> string

val of_value_description : value_description -> uid option
val of_type_declaration : type_declaration -> uid option
val of_extension_constructor : extension_constructor -> uid option
val of_class_type_declaration : class_type_declaration -> uid option
val of_class_declaration : class_declaration -> uid option
val of_module_type_declaration : modtype_declaration -> uid option
