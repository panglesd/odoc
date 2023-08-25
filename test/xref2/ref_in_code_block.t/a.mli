val f : int -> int
(** A function  *)

val x : int
(** An integer  *)

module X : sig
  val f : int
       (** We can use [f] as follows:


                         {[


      
         let i =
         {{!f}f} {{!x}x} in
         print_int i
      ]}
*)
end

(**

{{!edesff}dd}

   Wrong references are reported well:

       {[    
             ddd  
                {{!blibli}blu}

                      sefesf
]}

    *)
