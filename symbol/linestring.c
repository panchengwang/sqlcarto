#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;



sym_sub_path_linestring_t* sym_linestring_create() {
    sym_sub_path_linestring_t* ls = (sym_sub_path_linestring_t*)malloc(sizeof(sym_sub_path_linestring_t));
    ls->type = SYM_SUB_PATH_LINESTRING;
    ls->npoints = 0;
    ls->points = NULL;
}


sym_sub_path_linestring_t* sym_linestring_parse_from_json(json_object* obj) {
    double rotation = 0;
    JSON_GET_DOUBLE(obj, "rotation", rotation);

    json_object* arrpoints = NULL;
    JSON_GET_ARRAY(obj, "points", arrpoints);

    int32_t npoints = json_object_array_length(arrpoints);
    sym_point_t* points;
    points = (sym_point_t*)malloc(sizeof(sym_point_t) * npoints);
    for (int i = 0; i < npoints; ++i) {
        json_object* pointobj = json_object_array_get_idx(arrpoints, i);
        if (!sym_point_from_json(&points[i], pointobj)) {
            free(points);
            return NULL;
        }
    }
    sym_sub_path_linestring_t* ls = sym_linestring_create();
    ls->npoints = npoints;
    ls->points = points;
    ls->rotation = rotation;
    _sym_parse_ok = 1;
    return ls;
}


json_object* sym_linestring_to_json(sym_sub_path_linestring_t* line) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "linestring");
    JSON_SET_DOUBLE(obj, "rotation", line->rotation);
    json_object* arrpoints = json_object_new_array();
    for (int i = 0; i < line->npoints; ++i) {
        json_object* pointobj = json_object_new_array();
        json_object_array_add(pointobj, json_object_new_double(line->points[i].x));
        json_object_array_add(pointobj, json_object_new_double(line->points[i].y));
        json_object_array_add(arrpoints, pointobj);
    }
    json_object_object_add(obj, "points", arrpoints);
    return obj;
}


void sym_linestring_free(sym_sub_path_linestring_t* line) {
    free(line->points);
    line->npoints = 0;
    line->points = NULL;
    free(line);
    line = NULL;
}

