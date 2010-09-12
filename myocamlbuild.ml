
open Ocamlbuild_plugin

let ocamlfind x = S[A"ocamlfind"; x]

let run_and_read = Ocamlbuild_pack.My_unix.run_and_read

let split s ch =
  let x = ref [] in
  let rec go s =
    let pos = String.index s ch in
    x := (String.before s pos)::!x;
    go (String.after s (pos + 1))
  in
  try
    go s
  with Not_found -> !x
                                                                                                                                                                                                                                             
let split_nl s = split s '\n'

let before_space s =
  try
    String.before s (String.index s ' ')
  with Not_found -> s

(* this lists all supported packages *)
let find_packages () =
  List.map before_space (split_nl & run_and_read "ocamlfind list")

(* this is supposed to list available syntaxes, but I don't know how to do it. *)
let find_syntaxes () = ["camlp4o"; "camlp4r"]

let _ = dispatch begin function
	| Before_options ->
		Options.ocamlc := ocamlfind & A"ocamlc";
		Options.ocamlopt := ocamlfind & A"ocamlopt";
		Options.ocamldep := ocamlfind & A"ocamldep";
		Options.ocamldoc := ocamlfind & A"ocamldoc";
		Options.ocamlmktop := ocamlfind & A"ocamlmktop"
	| After_rules ->
		flag ["ocaml"; "link"; "program"] & A"-linkpkg";
		
		List.iter begin fun pkg ->
			flag ["ocaml"; "compile"; "pkg_"^pkg] & S[A"-package"; A pkg];
			flag ["ocaml"; "ocamldep"; "pkg_"^pkg] & S[A"-package"; A pkg];
			flag ["ocaml"; "doc"; "pkg_"^pkg] & S[A"-package"; A pkg];
			flag ["ocaml"; "link"; "pkg_"^pkg] & S[A"-package"; A pkg];
			flag ["ocaml"; "infer_interface"; "pkg_"^pkg] & S[A"-package"; A pkg];
		end (find_packages ());
		
		List.iter begin fun syntax ->
			flag ["ocaml"; "compile"; "syntax_"^syntax] & S[A"-syntax"; A syntax];
			flag ["ocaml"; "ocamldep"; "syntax_"^syntax] & S[A"-syntax"; A syntax];
			flag ["ocaml"; "doc"; "syntax_"^syntax] & S[A"-syntax"; A syntax];
			flag ["ocaml"; "infer_interface"; "syntax_"^syntax] & S[A"-syntax"; A syntax];
		end (find_syntaxes ())
	| _ -> ()
end
