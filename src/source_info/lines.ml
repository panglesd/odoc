open Odoc_model.Lang.Source_code.Info

let split src =
  let lines = String.split_on_char '\n' src in
  let _, poses, _ =
    List.fold_left
      (fun (i, poses, count) line ->
        let l = String.length line in
        let poses = (Line i, (count, count)) :: poses in
        (i + 1, poses, count + l + 1))
      (1, [], 0) lines
  in
  poses
