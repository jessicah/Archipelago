
(* Archipelago game engine *)

open Dictionary
open Board

let () = Random.init (Unix.getpid () lxor (int_of_float (Unix.time ())))

let letters = [
		1, "JKQXZ"; 2, "_BCFHMPVWY";
		3, "G"; 4, "DLSU"; 6, "NRT";
		8, "O"; 9, "AI"; 12, "E"
	]

let make_letters () =
	(* returns a list of chars of the scrabble letter set *)
	let queue = Queue.create () in
	List.iter begin fun (count, chars) ->
		(* foreach char in chars, repeat count times, and add to newlist *)
		String.iter begin fun ch ->
			for i = 1 to count do
				Queue.add ch queue
			done
		end chars
	end letters;
	List.sort compare (Queue.fold begin fun lst ch -> ch :: lst end [] queue)
	
let board : Game_types.board = Array.make_matrix 15 15 None

type person = {
	id : int;
	mutable name : string;
	mutable transform : (int * int) -> (int * int);
}

type player = {
	person : person;
	mutable rack : char list;
	mutable bag : char list;
	mutable words : string list;
	mutable stats : stats;
} and stats = {
	played : int;
	captured : int;
	lost : int;
}

exception Game_full
exception Already_in_game

let people = ref []

let players = Queue.create ()

let next_id = ref (Random.int 1000)

let default_transform p = p

let enter name =
	incr next_id;
	people := {
		id = !next_id; name = name;
		transform = default_transform;
	} :: !people

let join id =
	(* ensure the game has room for more players *)
	if Queue.length players = 4 then raise Game_full;
	(* todo: check that the game hasn't started yet *)
	(* find the person who wants to join *)
	let person = List.find (fun p -> p.id = id) !people in
	(* and make sure they're not already joined *)
	if Queue.fold (fun b p -> b || p.person.id = id) false players
		then raise Already_in_game;
	(* finally, add them to the game *)
	Queue.add {
		person = person;
		rack = [];
		bag = make_letters ();
		words = [];
		stats = { played = 0; captured = 0; lost = 0 }
	} players;;

(*(* just a lil helper function for testing :) *)
let update_board () =
	let word = dictionary.(Random.int (Array.length dictionary)) in
	let len = String.length word in
	let i = Random.int 15 - len - 1 in
	let i = if i < 0 then 0 else i in
	let j = Random.int 15 in
	let horizontal = Random.bool () in
	if horizontal then
		for x = i to i + len - 1 do
			board.(x).(j) <- Some word.[x-i]
		done
	else
		for y = i to i + len - 1 do
			board.(j).(y) <- Some word.[y-i]
		done*)

let get_board id : Game_types.board = board
