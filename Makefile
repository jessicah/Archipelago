
all: archipelago

archipelago: chr.cmx game_types.cmx archipelago.cmx server.cmx
	ocamlfind ocamlopt -o $@ $+ -linkpkg -package json-wheel,http

game_types.cmx: game_types.ml chr.cmx
	ocamlfind ocamlopt -c $@ $< -syntax camlp4o -package json-static

%.cmx: %.ml
	ocamlfind ocamlopt -c $@ $< -package json-wheel,http

clean:
	rm -f *.cm[iox] *.o archipelago archipelago.byte
