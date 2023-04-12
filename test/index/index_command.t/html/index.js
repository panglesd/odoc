var documents = [
 {
   "name": "Main",
   "kind": "root",
   "url": "Main/index.html",
   
 },
    

 {
   "name": "cc",
   "kind": "value",
   "url": "Main/index.html#val-cc",
   "comment": ""
 },
    

 {
   "name": "v",
   "kind": "value",
   "url": "Main/index.html#val-v",
   "comment": "title and a reference "
 },
    

 {
   "name": "t",
   "kind": "type",
   "url": "Main/index.html#type-t",
   "comment": "A comment"
 },
    
] ; 
 
const options = { keys: ['name', 'comment'] };
var idx_fuse = new Fuse(documents, options);
  