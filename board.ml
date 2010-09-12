
(* some stuff to deal with the board *)

open Game_types

let board : Game_types.board = Array.make_matrix 15 15 None

(* add a word to board, used for debugging *)
let () =
	let example_word = "hello" in
	for x = 3 to 3 + String.length example_word - 1 do
		board.(13).(x) <- Some example_word.[x-3]
	done

let t = [|
	(fun x y -> x, y); (* no rotation *)
	(fun x y -> 14 - y, x); (* anti-clockwise turn *)
	(fun x y -> 14 - x, 14 - y); (* 180 degrees *)
	(fun x y -> y, 14 - x); (* clockwise turn *)
|]

(* creates a new array transformed by the passed in function *)
let rotate src transform =
	let arr = Array.make_matrix 15 15 None in
	for y = 0 to 14 do
		for x = 0 to 14 do
			let x',y' = transform x y in
			(* e.g. y <- x; x <- (size-1) - y *)
			arr.(y').(x') <- src.(y).(x)
		done
	done;
	arr

(* debug routine; transform here is opposite direction to rotate above *)
let print_board arr transform =
	for y = 0 to 14 do
		for x = 0 to 14 do
			let x,y = transform x y in
			match arr.(y).(x) with
			| None -> print_string " ~ "
			| Some ch -> print_char ' '; print_char ch; print_char ' '
		done;
		print_newline ();
	done;
	print_newline ()

let () =
	print_board board t.(1);
	print_board (rotate board t.(1)) t.(0);
	exit 0
