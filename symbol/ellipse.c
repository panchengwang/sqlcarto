#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_ellipse_t* sym_ellipse_create() {
    sym_sub_path_ellipse_t* ellipse = (sym_sub_path_ellipse_t*)malloc(sizeof(sym_sub_path_ellipse_t));
    ellipse->type = SYM_SUB_PATH_ELLIPSE;

    ellipse->rotation = 0;
    ellipse->center.x = 0.0;
    ellipse->center.y = 0.0;
    ellipse->xradius = 0.8f;
    ellipse->yradius = 0.5f;
    return ellipse;
}



sym_sub_path_ellipse_t* sym_ellipse_parse_from_json(json_object* obj) {
    double rotation;
    sym_point_t center;
    double xradius, yradius;

    JSON_GET_DOUBLE(obj, "rotation", rotation);
    if (!_sym_parse_ok) {
        return NULL;
    }

    json_object* objcenter = json_object_object_get(obj, "center");
    if (!sym_point_from_json(&center, objcenter)) {
        return NULL;
    }
    JSON_GET_DOUBLE(obj, "xradius", xradius);
    if (!_sym_parse_ok) {
        return NULL;
    }
    JSON_GET_DOUBLE(obj, "yradius", yradius);
    if (!_sym_parse_ok) {
        return NULL;
    }

    sym_sub_path_ellipse_t* ellipse = sym_ellipse_create();
    ellipse->rotation = rotation;
    ellipse->center = center;
    ellipse->xradius = xradius;
    ellipse->yradius = yradius;
    return ellipse;
}



json_object* sym_ellipse_to_json(sym_sub_path_ellipse_t* ellipse) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "ellipse");
    JSON_SET_DOUBLE(obj, "rotation", ellipse->rotation);
    json_object_object_add(obj, "center", sym_point_to_json(&ellipse->center));
    JSON_SET_DOUBLE(obj, "xradius", ellipse->xradius);
    JSON_SET_DOUBLE(obj, "yradius", ellipse->yradius);
    return obj;
}



void sym_ellipse_free(sym_sub_path_ellipse_t* ellipse) {
    free(ellipse);
    ellipse = NULL;
}


