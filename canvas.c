#include "canvas.h"
#include "sqlcarto.h"
#include "mapengine_c.h"
#include <geos_c.h>
#include "postgis.h"

// 内存地址转换成16进制字符串
text* address_to_hex(void* address) {
    char buf[19];
    sprintf(buf, "%016llX", (unsigned long long)address);
    return cstring_to_text(buf);
}


// 从16进制字符串获取内存地址
void* hex_to_address(text* hex) {
    unsigned long long address = strtoull(text_to_cstring(hex), NULL, 16);
    return (void*)address;
}


PG_FUNCTION_INFO_V1(sc_canvas_create);
Datum sc_canvas_create(PG_FUNCTION_ARGS) {
    MAPCANVAS_H canvas = map_canvas_create();
    PG_RETURN_TEXT_P(address_to_hex(canvas));
}

PG_FUNCTION_INFO_V1(sc_canvas_set_size);
Datum sc_canvas_set_size(PG_FUNCTION_ARGS) {
    MAPCANVAS_H canvas = (MAPCANVAS_H)hex_to_address(PG_GETARG_TEXT_PP(0));
    map_canvas_set_size((MAPCANVAS_H)canvas, PG_GETARG_FLOAT8(1), PG_GETARG_FLOAT8(2));
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


PG_FUNCTION_INFO_V1(sc_canvas_set_dotspermm);
Datum sc_canvas_set_dotspermm(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    map_canvas_set_dotspermm((MAPCANVAS_H)canvas, PG_GETARG_FLOAT8(1));
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


PG_FUNCTION_INFO_V1(sc_canvas_set_envelope);
Datum sc_canvas_set_envelope(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    map_canvas_set_envelope((MAPCANVAS_H)canvas, PG_GETARG_FLOAT8(1), PG_GETARG_FLOAT8(2), PG_GETARG_FLOAT8(3), PG_GETARG_FLOAT8(4));
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}

PG_FUNCTION_INFO_V1(sc_canvas_destroy);
Datum sc_canvas_destroy(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    // map_canvas_destroy((MAPCANVAS_H)canvas);
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


PG_FUNCTION_INFO_V1(sc_canvas_begin);
Datum sc_canvas_begin(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    // elog(NOTICE, "canvas begin");
    map_canvas_begin((MAPCANVAS_H)canvas);
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


PG_FUNCTION_INFO_V1(sc_canvas_end);
Datum sc_canvas_end(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    map_canvas_end((MAPCANVAS_H)canvas);
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}

PG_FUNCTION_INFO_V1(sc_canvas_draw_geometry);
Datum sc_canvas_draw_geometry(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    GSERIALIZED* geom;
    initGEOS(lwpgnotice, lwgeom_geos_error);
    geom = PG_GETARG_GSERIALIZED_P(1);
    LWGEOM* lwgeom = lwgeom_from_gserialized(geom);

    GEOSGeometry* geos_geom = LWGEOM2GEOS(lwgeom, 0);
    map_canvas_draw_geometry((MAPCANVAS_H)canvas, geos_geom, NULL, NULL);


    // elog(NOTICE, "canvas draw geometry");
    // text* geomstr = PG_GETARG_TEXT_PP(1);
    // map_canvas_draw((MAPCANVAS_H)canvas, text_to_cstring(geomstr));

    GEOSGeom_destroy(geos_geom);
    lwgeom_free(lwgeom);
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


PG_FUNCTION_INFO_V1(sc_canvas_add_geometry);
Datum sc_canvas_add_geometry(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    elog(NOTICE, "sc_canvas_add_geometry: %s", text_to_cstring(PG_GETARG_TEXT_PP(1)));
    // text* geomstr = PG_GETARG_TEXT_PP(1);
    // map_canvas_draw((MAPCANVAS_H)canvas, text_to_cstring(geomstr));
    PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
}


// PG_FUNCTION_INFO_V1(sc_canvas_save_to_png);
// Datum sc_canvas_save_to_png(PG_FUNCTION_ARGS) {
//     void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
//     text* filename = PG_GETARG_TEXT_PP(1);
//     map_canvas_save((MAPCANVAS_H)canvas, text_to_cstring(filename));
//     PG_RETURN_TEXT_P(PG_GETARG_TEXT_PP(0));
// }


PG_FUNCTION_INFO_V1(sc_canvas_as_png);
Datum sc_canvas_as_png(PG_FUNCTION_ARGS) {
    void* canvas = hex_to_address(PG_GETARG_TEXT_PP(0));
    char* rawdata = NULL;
    bytea* result = NULL;
    size_t len;
    rawdata = map_canvas_image_data((MAPCANVAS_H)canvas, &len);
    result = palloc(VARHDRSZ + len);
    SET_VARSIZE(result, VARHDRSZ + len);
    memcpy(VARDATA(result), rawdata, len);
    free(rawdata);
    PG_RETURN_BYTEA_P(result);
}