
all: 
	ocamlbuild -tags pkg_json-wheel,pkg_http -tag-line '<game_types.*>: syntax_camlp4o,pkg_json-static' server.byte
	mv server.byte archipelago

clean:
	ocamlbuild -clean
