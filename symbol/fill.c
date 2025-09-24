#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


sym_fill_t* sym_fill_parse_from_json(json_object* obj) {
    const char* strtype;
    JSON_GET_STRING(obj, "type", strtype);


    sym_fill_t* fill = NULL;
    if (strcmp(strtype, "solid") == 0) {
        fill = (sym_fill_t*)sym_fill_solid_parse_from_json(obj);
    }
    else {
        sprintf(_sym_parse_error, "Unknown fill type: %s", strtype);
        _sym_parse_ok = 0;
        return NULL;
    }

    return fill;


}


json_object* sym_fill_to_json(sym_fill_t* fill) {
    switch (fill->type) {
    case SYM_FILL_SOLID:
        return sym_fill_solid_to_json((sym_fill_solid_t*)fill);
    }
    return NULL;
}


void sym_fill_free(sym_fill_t* fill) {
    switch (fill->type) {
    case SYM_FILL_SOLID:
        sym_fill_solid_free((sym_fill_solid_t*)fill);
        break;
    }
}




sym_fill_solid_t* sym_fill_solid_create() {
    sym_fill_solid_t* solid = (sym_fill_solid_t*)malloc(sizeof(sym_fill_solid_t));
    solid->type = SYM_FILL_SOLID;
    solid->color.a = 255;
    solid->color.r = 0;
    solid->color.g = 0;
    solid->color.b = 255;
    return solid;
}


sym_fill_solid_t* sym_fill_solid_parse_from_json(json_object* obj) {
    sym_color_t color;
    JSON_GET_COLOR(obj, "color", color);
    _sym_parse_ok = 1;
    sym_fill_solid_t* solid = sym_fill_solid_create();
    solid->color = color;
    solid->type = SYM_FILL_SOLID;
    return solid;
}


json_object* sym_fill_solid_to_json(sym_fill_solid_t* fill) {
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "type", json_object_new_string("solid"));
    json_object* objcolor = sym_color_to_json(&fill->color);
    json_object_object_add(obj, "color", objcolor);
    return obj;
}


void sym_fill_solid_free(sym_fill_solid_t* fill) {
    free(fill);
    fill = NULL;
}

