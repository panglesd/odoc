let _ = A.a

module C = A.Make (struct
  let x = 2
end)

let _ = C.y
