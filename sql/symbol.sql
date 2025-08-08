
CREATE OR REPLACE FUNCTION sc_symbol_in(cstring)
	RETURNS symbol
	AS 'MODULE_PATHNAME','SYMBOL_in'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION sc_symbol_out(symbol)
	RETURNS cstring
	AS 'MODULE_PATHNAME','SYMBOL_out'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE TYPE symbol (
	internallength = variable,
	input = sc_symbol_in,
	output = sc_symbol_out,
	alignment = double,
	storage = main
);


-- CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,text,float8)
-- 	RETURNS bytea
-- 	AS 'MODULE_PATHNAME','sc_symbol_as_image'
-- 	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,float8)
	RETURNS bytea
	AS 'MODULE_PATHNAME','sc_symbol_as_image'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


-- CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,text,float8,float8)
-- 	RETURNS bytea
-- 	AS 'MODULE_PATHNAME','sc_symbol_as_image_with_size'
-- 	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;

