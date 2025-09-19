#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


sym_sub_path_t* sym_sub_path_parse_from_json(json_object* obj) {
    const char* strtype;

    JSON_GET_STRING(obj, "type", strtype);
    if (!_sym_parse_ok) {
        return NULL;
    }

    sym_sub_path_t* subpath = NULL;
    if (strcmp(strtype, "linestring") == 0) {
        subpath = (sym_sub_path_t*)sym_linestring_parse_from_json(obj);
    }
    else if (strcmp(strtype, "polygon") == 0) {
        return (sym_sub_path_t*)sym_polygon_parse_from_json(obj);
    }
    // else if (strcmp(strtype, "arc") == 0) {
    //     return (sym_sub_path_t*)sym_arc_parse_from_json_path(obj);
    // }
    else {
        _sym_parse_ok = 0;
        sprintf(_sym_parse_error, "Invalid sub path type: %s", strtype);
        return NULL;
    }

    if (!_sym_parse_ok) {
        return NULL;
    }

    _sym_parse_ok = 1;
    return subpath;

}



json_object* sym_sub_path_to_json(sym_sub_path_t* subpath) {
    switch (subpath->type) {
    case SYM_SUB_PATH_LINESTRING:
        return sym_linestring_to_json((sym_sub_path_linestring_t*)subpath);
        break;
    case SYM_SUB_PATH_POLYGON:
        return sym_polygon_to_json((sym_sub_path_polygon_t*)subpath);
        break;
    default:
        break;
    }
    return NULL;
}



void sym_sub_path_free(sym_sub_path_t* subpath) {
    switch (subpath->type) {
    case SYM_SUB_PATH_LINESTRING:
        sym_linestring_free((sym_sub_path_linestring_t*)subpath);
        break;
    case SYM_SUB_PATH_POLYGON:
        sym_polygon_free((sym_sub_path_polygon_t*)subpath);
        break;
    default:
        break;
    }
}


