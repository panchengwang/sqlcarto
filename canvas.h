#include "sqlcarto.h"
#include "postgres.h"
#include "fmgr.h"


text* address_to_hex(void* address);
void* hex_to_address(text* hex);


Datum sc_canvas_create(PG_FUNCTION_ARGS);
Datum sc_canvas_set_size(PG_FUNCTION_ARGS);
Datum sc_canvas_set_envelope(PG_FUNCTION_ARGS);
Datum sc_canvas_set_dotspermm(PG_FUNCTION_ARGS);
Datum sc_canvas_destroy(PG_FUNCTION_ARGS);
Datum sc_canvas_begin(PG_FUNCTION_ARGS);
Datum sc_canvas_end(PG_FUNCTION_ARGS);
Datum sc_canvas_add_geometry(PG_FUNCTION_ARGS);
Datum sc_canvas_draw_geometry(PG_FUNCTION_ARGS);
// Datum sc_canvas_save_to_png(PG_FUNCTION_ARGS);
Datum sc_canvas_as_png(PG_FUNCTION_ARGS);