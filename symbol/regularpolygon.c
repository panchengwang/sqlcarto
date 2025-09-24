#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


sym_sub_path_regular_polygon_t* sym_regular_polygon_create() {
    sym_sub_path_regular_polygon_t* regular_polygon = (sym_sub_path_regular_polygon_t*)malloc(sizeof(sym_sub_path_regular_polygon_t));
    regular_polygon->type = SYM_SUB_PATH_REGULAR_POLYGON;
    regular_polygon->rotation = 0;
    regular_polygon->center.x = 0;
    regular_polygon->center.y = 0;
    regular_polygon->radius = 0.5;
    regular_polygon->sides = 3;
    return regular_polygon;
}



sym_sub_path_regular_polygon_t* sym_regular_polygon_parse_from_json(json_object* obj) {
    double rotation;
    sym_point_t center;
    double radius;
    int32_t sides;

    JSON_GET_DOUBLE(obj, "rotation", rotation);
    JSON_GET_POINT(obj, "center", center);
    JSON_GET_INT(obj, "sides", sides);
    JSON_GET_DOUBLE(obj, "radius", radius);
    sym_sub_path_regular_polygon_t* regular_polygon = sym_regular_polygon_create();
    regular_polygon->rotation = rotation;
    regular_polygon->center = center;
    regular_polygon->sides = sides;
    regular_polygon->radius = radius;
    return regular_polygon;
}



json_object* sym_regular_polygon_to_json(sym_sub_path_regular_polygon_t* regular_polygon) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "regularpolygon");
    JSON_SET_DOUBLE(obj, "rotation", regular_polygon->rotation);
    JSON_SET_POINT(obj, "center", regular_polygon->center);
    JSON_SET_INT(obj, "sides", regular_polygon->sides);
    JSON_SET_DOUBLE(obj, "radius", regular_polygon->radius);
    return obj;
}



void sym_regular_polygon_free(sym_sub_path_regular_polygon_t* regular_polygon) {
    free(regular_polygon);
    regular_polygon = NULL;
}


