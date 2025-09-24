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

    sym_sub_path_t* subpath = NULL;
    if (strcmp(strtype, "linestring") == 0) {
        subpath = (sym_sub_path_t*)sym_linestring_parse_from_json(obj);
    }
    else if (strcmp(strtype, "polygon") == 0) {
        return (sym_sub_path_t*)sym_polygon_parse_from_json(obj);
    }
    else if (strcmp(strtype, "ellipse") == 0) {
        return (sym_sub_path_t*)sym_ellipse_parse_from_json(obj);
    }
    else if (strcmp(strtype, "circle") == 0) {
        return (sym_sub_path_t*)sym_circle_parse_from_json(obj);
    }
    else if (strcmp(strtype, "arc") == 0) {
        return (sym_sub_path_t*)sym_arc_parse_from_json(obj);
    }
    else if (strcmp(strtype, "chord") == 0) {
        return (sym_sub_path_t*)sym_chord_parse_from_json(obj);
    }
    else if (strcmp(strtype, "pie") == 0) {
        return (sym_sub_path_t*)sym_pie_parse_from_json(obj);
    }
    else if (strcmp(strtype, "regularpolygon") == 0) {
        return (sym_sub_path_t*)sym_regular_polygon_parse_from_json(obj);
    }
    else if (strcmp(strtype, "star") == 0) {
        return (sym_sub_path_t*)sym_star_parse_from_json(obj);
    }
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
    case SYM_SUB_PATH_ELLIPSE:
        return sym_ellipse_to_json((sym_sub_path_ellipse_t*)subpath);
        break;
    case SYM_SUB_PATH_CIRCLE:
        return sym_circle_to_json((sym_sub_path_circle_t*)subpath);
        break;
    case SYM_SUB_PATH_ARC:
        return sym_arc_to_json((sym_sub_path_arc_t*)subpath);
        break;
    case SYM_SUB_PATH_CHORD:
        return sym_chord_to_json((sym_sub_path_chord_t*)subpath);
        break;
    case SYM_SUB_PATH_PIE:
        return sym_pie_to_json((sym_sub_path_pie_t*)subpath);
        break;
    case SYM_SUB_PATH_REGULAR_POLYGON:
        return sym_regular_polygon_to_json((sym_sub_path_regular_polygon_t*)subpath);
        break;
    case SYM_SUB_PATH_STAR:
        return sym_star_to_json((sym_sub_path_star_t*)subpath);
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
    case SYM_SUB_PATH_ELLIPSE:
        sym_ellipse_free((sym_sub_path_ellipse_t*)subpath);
        break;
    case SYM_SUB_PATH_CIRCLE:
        sym_circle_free((sym_sub_path_circle_t*)subpath);
        break;
    case SYM_SUB_PATH_ARC:
        sym_arc_free((sym_sub_path_arc_t*)subpath);
        break;
    case SYM_SUB_PATH_CHORD:
        sym_chord_free((sym_sub_path_chord_t*)subpath);
        break;
    case SYM_SUB_PATH_PIE:
        sym_pie_free((sym_sub_path_pie_t*)subpath);
        break;
    case SYM_SUB_PATH_REGULAR_POLYGON:
        sym_regular_polygon_free((sym_sub_path_regular_polygon_t*)subpath);
        break;
    case SYM_SUB_PATH_STAR:
        sym_star_free((sym_sub_path_star_t*)subpath);
        break;
    default:
        break;
    }
}


