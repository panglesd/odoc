open Or_error

val index :
  output:Fs.file ->
  warnings_options:Odoc_model.Error.warnings_options ->
  Fs.directory list ->
  (unit, [> msg ]) result

val compile :
  resolver:'a ->
  parent:'b ->
  output:Fs.file ->
  warnings_options:Odoc_model.Error.warnings_options ->
  Fs.directory list ->
  (unit, [> msg ]) result

val generate :
  output:Fpath.t -> warnings_options:'a -> Fpath.t -> (unit, [> msg ]) result
