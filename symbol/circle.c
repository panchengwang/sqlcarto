#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_circle_t* sym_circle_create() {
    sym_sub_path_circle_t* circle = (sym_sub_path_circle_t*)malloc(sizeof(sym_sub_path_circle_t));
    circle->type = SYM_SUB_PATH_CIRCLE;
    circle->center.x = 0;
    circle->center.y = 0;
    circle->radius = 0.8;
    return circle;
}



sym_sub_path_circle_t* sym_circle_parse_from_json(json_object* obj) {
    sym_point_t center;
    double radius;

    json_object* objcenter = json_object_object_get(obj, "center");
    if (!objcenter) {
        sprintf(_sym_parse_error, "error: circle center not found");
        _sym_parse_ok = 0;
        return NULL;
    }
    if (!sym_point_from_json(&center, objcenter)) {
        return NULL;
    }

    JSON_GET_DOUBLE(obj, "radius", radius);
    if (!_sym_parse_ok) {
        return NULL;
    }
    _sym_parse_ok = 1;
    sym_sub_path_circle_t* circle = sym_circle_create();
    circle->center = center;
    circle->radius = radius;
    return circle;
}



json_object* sym_circle_to_json(sym_sub_path_circle_t* circle) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "circle");
    json_object_object_add(obj, "center", sym_point_to_json(&circle->center));
    json_object_object_add(obj, "radius", json_object_new_double(circle->radius));
    return obj;
}



void sym_circle_free(sym_sub_path_circle_t* circle) {
    free(circle);
    circle = NULL;
}


