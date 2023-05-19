open Odoc_model.Paths
open Odoc_model.Lang

type type_decl_entry = TypeDecl.t

type exception_entry = {
  args : TypeDecl.Constructor.argument;
  res : TypeExpr.t option;
}

type class_type_entry = {
  virtual_ : bool;
  params : TypeDecl.param list;
  expr : ClassType.expr;
      (* expansion field is not included since we include the content as other entries *)
}

type method_entry = { private_ : bool; virtual_ : bool; type_ : TypeExpr.t }

type class_entry = {
  virtual_ : bool;
  params : TypeDecl.param list;
  type_ : Class.decl;
      (* expansion field is not included since we include the content as other entries *)
}

type type_extension_entry = {
  type_path : Path.Type.t;
  type_params : TypeDecl.param list;
  private_ : bool;
}

type extension_constructor_entry = {
  args : TypeDecl.Constructor.argument;
  res : TypeExpr.t option;
}

type constructor_entry = {
  args : TypeDecl.Constructor.argument;
  res : TypeExpr.t;
}

type field_entry = {
  mutable_ : bool;
  type_ : TypeExpr.t;
  parent_type : TypeExpr.t;
}

type module_substitution_entry = { manifest : Path.Module.t }

type instance_variable_entry = {
  mutable_ : bool;
  virtual_ : bool;
  type_ : TypeExpr.t;
}

type doc_entry = Paragraph | Heading | CodeBlock | MathBlock | Verbatim

type value_entry = { value : Value.value; type_ : TypeExpr.t }

type extra =
  | TypeDecl of type_decl_entry
  | Module
  | Value of value_entry
  | Doc of doc_entry
  | Exception of exception_entry
  | Class_type of class_type_entry
  | Method of method_entry
  | Class of class_entry
  | TypeExtension of type_extension_entry
  | ExtensionConstructor of extension_constructor_entry
  | ModuleType
  | Constructor of constructor_entry
  | Field of field_entry
  | FunctorParameter
  | ModuleSubstitution of module_substitution_entry
  | ModuleTypeSubstitution
  | InstanceVariable of instance_variable_entry

module Html = Tyxml.Html

type html =
  Html_types.flow5_without_sectioning_heading_header_footer Html.elt list

type t = {
  id : Odoc_model.Paths.Identifier.Any.t;
  doc : Odoc_model.Comment.docs;
  extra : extra;
}

(* (\* TODO: add from which opam package it comes *\) *)
(* type entry = { id_ : Paths.Identifier.Any.t; doc : Comment.docs option } *)

(* type index = t list *)

(* (\* TODO: make it robust when agregating from multiple package, and multiple *)
(*    times the same index *\) *)
(* let aggregate_index = ( @ ) *)
(* let aggregate_indexes = List.concat *)

(* let add a b = a :: b *)

(* let fold = List.fold_left *)
(* let iter = List.iter *)

(* let empty = [] *)

(* let is_empty = ( = ) [] *)
