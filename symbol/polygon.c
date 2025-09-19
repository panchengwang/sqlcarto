#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_polygon_t* sym_polygon_create() {
    sym_sub_path_polygon_t* pg = (sym_sub_path_polygon_t*)sym_linestring_create();
    pg->type = SYM_SUB_PATH_POLYGON;
    return pg;
}
sym_sub_path_polygon_t* sym_polygon_parse_from_json(json_object* obj) {
    sym_sub_path_polygon_t* pg = (sym_sub_path_polygon_t*)sym_linestring_parse_from_json(obj);
    if (!_sym_parse_ok) {
        return NULL;
    }
    pg->type = SYM_SUB_PATH_POLYGON;
    return pg;
}
json_object* sym_polygon_to_json(sym_sub_path_polygon_t* pg) {
    json_object* obj = sym_linestring_to_json((sym_sub_path_linestring_t*)pg);
    json_object_object_add(obj, "type", json_object_new_string("polygon"));
    return obj;
}


void sym_polygon_free(sym_sub_path_polygon_t* pg) {
    sym_linestring_free((sym_sub_path_linestring_t*)pg);
}