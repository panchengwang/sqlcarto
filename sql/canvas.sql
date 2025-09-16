create or replace function sc_canvas_create() 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_create'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_destroy(text) 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_destroy'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_begin(text)
returns text 
AS 'MODULE_PATHNAME','sc_canvas_begin'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_end(text)
returns text 
AS 'MODULE_PATHNAME','sc_canvas_end'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_set_size(text,float8,float8)
returns text 
AS 'MODULE_PATHNAME','sc_canvas_set_size'
LANGUAGE C ;


create or replace function sc_canvas_set_dotspermm(text,float8)
returns text 
AS 'MODULE_PATHNAME','sc_canvas_set_dotspermm'
LANGUAGE C ;


create or replace function sc_canvas_set_envelope(text,float8,float8,float8,float8)
returns text 
AS 'MODULE_PATHNAME','sc_canvas_set_envelope'
LANGUAGE C ;


create or replace function sc_canvas_draw_geometry(text, geometry,  symbol, symbol ) returns text 
AS 'MODULE_PATHNAME','sc_canvas_draw_geometry'
LANGUAGE C ;


create or replace function sc_canvas_add_geometry(text, geometry) returns text 
AS 'MODULE_PATHNAME','sc_canvas_add_geometry'
LANGUAGE C  ;
-- create or replace function sc_canvas_draw_geometry(canvas text,geo geometry,symbol,symbol) returns text as 
-- $$
-- declare
--     v_ret text := '1';
-- begin
--     raise notice 'return : %',geo;
--     return v_ret;
-- end;
-- $$ language 'plpgsql';

create or replace function sc_canvas_draw_geometry(
    text,
    geometry
) returns text 
AS $$
    select sc_canvas_draw_geometry($1, $2, NULL,NULL);
$$
LANGUAGE 'sql';


create or replace function sc_canvas_as_png(text)
returns bytea 
AS 'MODULE_PATHNAME','sc_canvas_as_png'
LANGUAGE C IMMUTABLE STRICT;