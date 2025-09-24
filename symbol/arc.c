#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_arc_t* sym_arc_create() {
    sym_sub_path_arc_t* arc = (sym_sub_path_arc_t*)malloc(sizeof(sym_sub_path_arc_t));
    arc->type = SYM_SUB_PATH_ARC;
    arc->rotation = 0.0f;
    arc->center.x = 0.0f;
    arc->center.y = 0.0f;
    arc->xradius = 0.8f;
    arc->yradius = 0.5f;
    arc->start_angle = 0.0f;
    arc->end_angle = 180.f;
    return arc;
}


sym_sub_path_arc_t* sym_arc_parse_from_json(json_object* obj) {
    double rotation;
    JSON_GET_DOUBLE(obj, "rotation", rotation);
    if (!_sym_parse_ok) return NULL;

    sym_point_t center;
    JSON_GET_POINT(obj, "center", center);
    if (!_sym_parse_ok) return NULL;

    double xradius;
    JSON_GET_DOUBLE(obj, "xradius", xradius);
    if (!_sym_parse_ok) return NULL;

    double yradius;
    JSON_GET_DOUBLE(obj, "yradius", yradius);
    if (!_sym_parse_ok) return NULL;

    double start_angle;
    JSON_GET_DOUBLE(obj, "startangle", start_angle);
    if (!_sym_parse_ok) return NULL;

    double end_angle;
    JSON_GET_DOUBLE(obj, "endangle", end_angle);
    if (!_sym_parse_ok) return NULL;

    sym_sub_path_arc_t* arc = sym_arc_create();
    arc->rotation = rotation;
    arc->center = center;
    arc->xradius = xradius;
    arc->yradius = yradius;
    arc->start_angle = start_angle;
    arc->end_angle = end_angle;
    return arc;

}


json_object* sym_arc_to_json(sym_sub_path_arc_t* arc) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "arc");
    JSON_SET_DOUBLE(obj, "rotation", arc->rotation);
    JSON_SET_POINT(obj, "center", arc->center);
    JSON_SET_DOUBLE(obj, "xradius", arc->xradius);
    JSON_SET_DOUBLE(obj, "yradius", arc->yradius);
    JSON_SET_DOUBLE(obj, "startangle", arc->start_angle);
    JSON_SET_DOUBLE(obj, "endangle", arc->end_angle);
    return obj;
}


void sym_arc_free(sym_sub_path_arc_t* arc) {
    free(arc);
    arc = NULL;
}

