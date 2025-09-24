#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


sym_sub_path_star_t* sym_star_create() {
    sym_sub_path_star_t* star = (sym_sub_path_star_t*)malloc(sizeof(sym_sub_path_star_t));
    star->type = SYM_SUB_PATH_STAR;
    star->center.x = 0;
    star->center.y = 0;
    star->radius = 0.8;
    star->rotation = 0;
    star->sides = 3;
    star->radius2 = 0.4;
    return star;
}



sym_sub_path_star_t* sym_star_parse_from_json(json_object* obj) {
    double rotation = 0;
    double radius = 0.8;
    double radius2 = 0.4;
    int sides = 3;
    sym_point_t center;

    JSON_GET_DOUBLE(obj, "rotation", rotation);
    JSON_GET_POINT(obj, "center", center);
    JSON_GET_INT(obj, "sides", sides);
    JSON_GET_DOUBLE(obj, "radius", radius);
    JSON_GET_DOUBLE(obj, "radius2", radius2);

    sym_sub_path_star_t* star = sym_star_create();
    star->center = center;
    star->rotation = rotation;
    star->sides = sides;
    star->radius = radius;
    star->radius2 = radius2;
    return star;
}



json_object* sym_star_to_json(sym_sub_path_star_t* star) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "star");
    JSON_SET_DOUBLE(obj, "rotation", star->rotation);
    JSON_SET_POINT(obj, "center", star->center);
    JSON_SET_INT(obj, "sides", star->sides);
    JSON_SET_DOUBLE(obj, "radius", star->radius);
    JSON_SET_DOUBLE(obj, "radius2", star->radius2);
    return obj;
}



void sym_star_free(sym_sub_path_star_t* star) {
    free(star);
    star = NULL;
}


