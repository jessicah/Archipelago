
(* the scrabble dictionary *)

let dictionary =
	let arr = Array.make 267750 "" in
	let dict = open_in "sowpods.txt" in
	for i = 0 to Array.length arr - 1 do
		arr.(i) <- input_line dict
	done;
	close_in dict;
	arr

let rec search word low high =
	if high < low then false
	else begin
		let mid = low + ((high - low) / 2) in
		if dictionary.(mid) > word then search word low (mid-1)
		else if dictionary.(mid) < word then search word (mid+1) high
		else true
	end

let check_word word = search word 0 (Array.length dictionary - 1)
