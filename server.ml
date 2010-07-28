
(* Archipelago http daemon *)

open Http_daemon
open Http_types
open Game_types

type req = Http_types.request

let board_for_player id json out =
	let board = Archipelago.get_board id in
	let body = Json_io.string_of_json (json_of_board board) in
	respond ~headers:["Cache-Control", "no-cache"; "content-type", "application/json"] ~body out;
	close_out out

let join_game id json out = respond_error out

let exchange_tiles id json out = respond_error out

let play_word id json out = respond_error out

let send_message id json out = respond_error out


let callback (req : req) out =
	let invoke f =
		let id = int_of_string (req#param "id") in
		let json = try
				Some (Json_io.json_of_string req#body)
			with _ -> None
		in
		f id json out
	in
	(* the dispatch loop *)
	match req#path with
		| "/board" -> invoke board_for_player
		| "/join" -> invoke join_game
		| "/exchange" -> invoke exchange_tiles
		| "/play" -> invoke play_word
		| "/msg" -> invoke send_message
		| "/" -> respond_file "index.html" out
		| _ -> respond_error out

(* configures and starts up our lil http daemon *)
let spec =
	{ default_spec with
			callback = callback;
			port = 8080;
			auto_close = true;
			mode = `Single;
	}

let () =
	main spec
