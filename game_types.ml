
(* Types for archipelago, with json helpers where required *)

type json board = Chr.t option array array

and statistics = {
	played : int;
	captured : int;
	lost : int
}

and player = {
	id : int;
	mutable name : string;
	mutable rack : Chr.t list;
	mutable statistics : statistics;
	mutable word_list : string list
}

and game_state = {
	board : board;
	players : player list
}

(* A Queue.t would be simpler than a list, but this works with json-static *)
