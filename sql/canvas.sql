create or replace function sc_canvas_create() 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_create'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_destroy(text) 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_destroy'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_draw_geometry(text,geometry) 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_draw_geometry'
LANGUAGE C IMMUTABLE STRICT;


create or replace function sc_canvas_save_to_file(text, text, text) 
returns text 
AS 'MODULE_PATHNAME','sc_canvas_save_to_file'
LANGUAGE C IMMUTABLE STRICT;