
(* Helper module for representing characters as json *)

open Json_type

type t = char

let of_json = function
	| String s when String.length s = 1 -> s.[0]
	| _ -> raise (Json_error "not a char")

let to_json ch = String (String.make 1 ch)
