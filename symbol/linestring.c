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
    sym_sub_path_linestring_t* ls = sym_linestring_create();
    json_object* arrpoints = NULL;
    JSON_GET_ARRAY(obj, "points", arrpoints);
    if (!_sym_parse_ok) {
        sym_linestring_free(ls);

        return NULL;
    }
    ls->npoints = json_object_array_length(arrpoints);
    ls->points = (sym_point_t*)malloc(sizeof(sym_point_t) * ls->npoints);
    for (int i = 0; i < ls->npoints; ++i) {
        json_object* pointobj = json_object_array_get_idx(arrpoints, i);
        if (json_object_is_type(pointobj, json_type_object)) {
            JSON_GET_DOUBLE(pointobj, "x", ls->points[i].x);
            if (!_sym_parse_ok) {
                sym_linestring_free(ls);
                return NULL;
            }
            JSON_GET_DOUBLE(pointobj, "y", ls->points[i].y);
            if (!_sym_parse_ok) {
                sym_linestring_free(ls);
                return NULL;
            }
        }
        else if (json_object_is_type(pointobj, json_type_array) && json_object_array_length(pointobj) == 2) {
            json_object* xobj = json_object_array_get_idx(pointobj, 0);
            json_object* yobj = json_object_array_get_idx(pointobj, 1);
            ls->points[i].x = json_object_get_double(xobj);
            ls->points[i].y = json_object_get_double(yobj);

        }
        else {
            _sym_parse_ok = 0;
            sprintf(_sym_parse_error, "Invalid point format: %s", json_object_to_json_string(pointobj));
            return NULL;
        }

    }
    _sym_parse_ok = 1;
    return ls;
}


json_object* sym_linestring_to_json(sym_sub_path_linestring_t* line) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "linestring");
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

