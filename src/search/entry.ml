open Odoc_model.Lang
open Odoc_model.Paths

type type_decl_entry = {
  txt : string;
  canonical : Path.Type.t option;
  equation : TypeDecl.Equation.t;
  representation : TypeDecl.Representation.t option;
}

type exception_entry = {
  args : TypeDecl.Constructor.argument;
  res : TypeExpr.t option;
}

type class_type_entry = { virtual_ : bool; params : TypeDecl.param list }

type method_entry = { private_ : bool; virtual_ : bool; type_ : TypeExpr.t }

type class_entry = { virtual_ : bool; params : TypeDecl.param list }

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

module Html = Tyxml.Html

type t = {
  id : Odoc_model.Paths.Identifier.Any.t;
  doc : Odoc_model.Comment.docs;
  extra : extra;
}

let entry ~id ~doc ~extra =
  let id = (id :> Odoc_model.Paths.Identifier.Any.t) in
  { id; extra; doc }

let varify_params =
  List.mapi (fun i param ->
      match param.TypeDecl.desc with
      | Var name -> TypeExpr.Var name
      | Any -> Var (Printf.sprintf "tv_%i" i))

let entry_of_constructor id_parent params (constructor : TypeDecl.Constructor.t)
    =
  let args = constructor.args in
  let res =
    match constructor.res with
    | Some res -> res
    | None ->
        let params = varify_params params in
        TypeExpr.Constr
          ( `Identifier
              ((id_parent :> Odoc_model.Paths.Identifier.Path.Type.t), false),
            params )
  in
  let extra = Constructor { args; res } in
  entry ~id:constructor.id ~doc:constructor.doc ~extra

let entry_of_field id_parent params (field : TypeDecl.Field.t) =
  let params = varify_params params in
  let parent_type =
    TypeExpr.Constr
      ( `Identifier
          ((id_parent :> Odoc_model.Paths.Identifier.Path.Type.t), false),
        params )
  in
  let extra =
    Field { mutable_ = field.mutable_; type_ = field.type_; parent_type }
  in
  entry ~id:field.id ~doc:field.doc ~extra

let rec entries_of_docs (d : Odoc_model.Comment.docs) =
  List.concat_map entries_of_doc d

and entries_of_doc d =
  match d.value with
  | `Paragraph (lbl, _) -> [ entry ~id:lbl ~doc:[ d ] ~extra:(Doc Paragraph) ]
  | `Tag _ -> []
  | `List (_, ds) ->
      List.concat_map entries_of_docs (ds :> Odoc_model.Comment.docs list)
  | `Heading (_, lbl, _) -> [ entry ~id:lbl ~doc:[ d ] ~extra:(Doc Heading) ]
  | `Modules _ -> []
  | `Code_block (lbl, _, _, o) ->
let o = match o with None -> [] | Some o -> entries_of_docs (o :> Odoc_model.Comment.docs) in
      entry ~id:lbl ~doc:[ d ] ~extra:(Doc CodeBlock) :: o
  | `Verbatim (lbl, _) -> [ entry ~id:lbl ~doc:[ d ] ~extra:(Doc Verbatim) ]
  | `Math_block (lbl, _) -> [ entry ~id:lbl ~doc:[ d ] ~extra:(Doc MathBlock) ]
  | `Table _ -> [ ]

let entries_of_item (x : Odoc_model.Fold.item) =
  match x with
  | CompilationUnit u -> (
      match u.content with
      | Module m -> [ entry ~id:u.id ~doc:m.doc ~extra:Module ]
      | Pack _ -> [])
  | TypeDecl td ->
      let txt = Render.text_of_typedecl td in
      let extra =
        TypeDecl
          {
            txt;
            canonical = td.canonical;
            equation = td.equation;
            representation = td.representation;
          }
      in
      let td_entry = entry ~id:td.id ~doc:td.doc ~extra in
      let subtype_entries =
        match td.representation with
        | None -> []
        | Some (Variant li) ->
            List.map (entry_of_constructor td.id td.equation.params) li
        | Some (Record fields) ->
            List.map (entry_of_field td.id td.equation.params) fields
        | Some Extensible -> []
      in
      td_entry :: subtype_entries
  | Module m -> [ entry ~id:m.id ~doc:m.doc ~extra:Module ]
  | Value v ->
      let extra = Value { value = v.value; type_ = v.type_ } in
      [ entry ~id:v.id ~doc:v.doc ~extra ]
  | Exception exc ->
      let extra = Exception { args = exc.args; res = exc.res } in
      [ entry ~id:exc.id ~doc:exc.doc ~extra ]
  | ClassType ct ->
      let extra = Class_type { virtual_ = ct.virtual_; params = ct.params } in
      [ entry ~id:ct.id ~doc:ct.doc ~extra ]
  | Method m ->
      let extra =
        Method { virtual_ = m.virtual_; private_ = m.private_; type_ = m.type_ }
      in
      [ entry ~id:m.id ~doc:m.doc ~extra ]
  | Class cl ->
      let extra = Class { virtual_ = cl.virtual_; params = cl.params } in
      [ entry ~id:cl.id ~doc:cl.doc ~extra ]
  | Extension te -> (
      match te.constructors with
      | [] -> []
      | c :: _ ->
          (* Type extension do not have an ID yet... we use the first
             constructor for the url. Unfortunately, this breaks the uniqueness
             of the ID in the search index... *)
          let type_entry =
            let extra =
              TypeExtension
                {
                  type_path = te.type_path;
                  type_params = te.type_params;
                  private_ = te.private_;
                }
            in
            entry ~id:c.id ~doc:te.doc ~extra
          in
          let extension_constructor (ext_constr : Extension.Constructor.t) =
            let extra =
              ExtensionConstructor
                { args = ext_constr.args; res = ext_constr.res }
            in
            entry ~id:ext_constr.id ~doc:ext_constr.doc ~extra
          in
          type_entry :: List.map extension_constructor te.constructors)
  | ModuleType mt -> [ entry ~id:mt.id ~doc:mt.doc ~extra:ModuleType ]
  | Doc `Stop -> []
  | Doc (`Docs d) -> entries_of_docs d
