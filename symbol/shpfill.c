#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;



sym_shape_fill_t* sym_shape_fill_create() {
    sym_shape_fill_t* fillshp = (sym_shape_fill_t*)malloc(sizeof(sym_shape_fill_t));
    memset(fillshp, 0, sizeof(sym_shape_fill_t));
    fillshp->type = SYM_SHAPE_FILL;
    fillshp->fill = NULL;
}

sym_shape_fill_t* sym_shape_fill_parse_from_json(json_object* obj) {
    sym_shape_fill_t* shape = sym_shape_fill_create();

    json_object* objfill = NULL;
    JSON_GET_OBJECT(obj, "fill", objfill);
    if (!_sym_parse_ok) {
        sym_shape_fill_free(shape);
        return NULL;
    }

    shape->fill = sym_fill_parse_from_json(objfill);
    if (!_sym_parse_ok) {
        sym_shape_fill_free(shape);
        return NULL;
    }
    _sym_parse_ok = 1;
    return shape;

}


json_object* sym_shape_fill_to_json(sym_shape_fill_t* shape) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "fill");
    if (shape->fill) {
        json_object* objfill = sym_fill_to_json(shape->fill);
        json_object_object_add(obj, "fill", objfill);
    }
    return obj;
}


void sym_shape_fill_free(sym_shape_fill_t* shape) {
    if (shape->fill) {
        sym_fill_free(shape->fill);
    }
    free(shape);
}

