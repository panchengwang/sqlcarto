#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


sym_shape_path_t* sym_shape_path_create() {
    sym_shape_path_t* path = (sym_shape_path_t*)malloc(sizeof(sym_shape_path_t));
    path->type = SYM_SHAPE_PATH;
    path->closed = 0;
    path->nsubpaths = 0;
    path->subpaths = NULL;
    path->fill = NULL;
    path->stroke = NULL;
    path->offsset_along_line = 0;

    return path;
}


sym_shape_path_t* sym_shape_path_parse_from_json(json_object* obj) {
    sym_shape_path_t* path = sym_shape_path_create();
    JSON_GET_BOOLEAN(obj, "closed", path->closed);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }

    json_object* objstroke;
    JSON_GET_OBJECT(obj, "stroke", objstroke);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }
    path->stroke = sym_stroke_parse_from_json(objstroke);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }
    json_object* objfill;
    JSON_GET_OBJECT(obj, "fill", objfill);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }
    path->fill = sym_fill_parse_from_json(objfill);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }

    json_object* arrsubpaths;
    JSON_GET_ARRAY(obj, "subpaths", arrsubpaths);
    if (!_sym_parse_ok) {
        sym_shape_path_free(path);
        return NULL;
    }
    path->nsubpaths = json_object_array_length(arrsubpaths);
    path->subpaths = (sym_sub_path_t**)malloc(sizeof(sym_sub_path_t*) * path->nsubpaths);
    for (int i = 0; i < path->nsubpaths; ++i) {
        path->subpaths[i] = NULL;
    }
    for (int i = 0; i < path->nsubpaths; ++i) {
        json_object* objsubpath = json_object_array_get_idx(arrsubpaths, i);
        sym_sub_path_t* subpath = sym_sub_path_parse_from_json(objsubpath);
        if (!_sym_parse_ok) {
            sym_shape_path_free(path);
            return NULL;
        }
        path->subpaths[i] = subpath;
    }


    return path;
}


json_object* sym_shape_path_to_json(sym_shape_path_t* path) {
    json_object* obj = json_object_new_object();
    json_object_object_add(obj, "type", json_object_new_string("path"));
    json_object_object_add(obj, "closed", json_object_new_boolean(path->closed));
    if (path->stroke) {
        json_object* stroke = sym_stroke_to_json(path->stroke);
        json_object_object_add(obj, "stroke", stroke);
    }
    if (path->fill) {
        json_object* fill = sym_fill_to_json(path->fill);
        json_object_object_add(obj, "fill", fill);
    }

    json_object* objsubpaths = json_object_new_array();
    for (int i = 0; i < path->nsubpaths; ++i) {
        json_object* objsubpath = sym_sub_path_to_json(path->subpaths[i]);
        json_object_array_add(objsubpaths, objsubpath);
    }
    json_object_object_add(obj, "subpaths", objsubpaths);
    return obj;
}


void sym_shape_path_free(sym_shape_path_t* shape) {
    if (shape->nsubpaths > 0) {
        for (int i = 0; i < shape->nsubpaths; ++i) {
            if (shape->subpaths[i]) {
                sym_sub_path_free(shape->subpaths[i]);
            }
        }
        free(shape->subpaths);
        shape->subpaths = NULL;
        shape->nsubpaths = 0;
    }

    if (shape->fill) {
        sym_fill_free(shape->fill);
        shape->fill = NULL;
    }

    if (shape->stroke) {
        sym_stroke_free(shape->stroke);
        shape->stroke = NULL;
    }
    free(shape);
    shape = NULL;
}

