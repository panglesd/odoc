open Or_error

val compile :
  binary:bool ->
  resolver:'a ->
  parent:'b ->
  output:Fs.file ->
  warnings_options:Odoc_model.Error.warnings_options ->
  Fs.directory list ->
  (unit, [> msg ]) result
