#include "json_utils.h"
#include "symbol_parser.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char _sym_parse_error[1024];
uint8_t _sym_parse_ok = 0;

symbol_t* sym_create() {
    symbol_t* sym = (symbol_t*)malloc(sizeof(symbol_t));
    sym->width = 3.0;
    sym->height = 3.0;
    sym->dotspermm = 96.0 / 25.4;
    sym->nshapes = 0;
    sym->shapes = NULL;
    return sym;
}

symbol_t* sym_parse_file(const char* filename) {
    FILE* file = fopen(filename, "r");
    long length;
    symbol_t* sym = NULL;
    char* jsonstr = NULL;
    if (!file) {
        return NULL;
    }
    fseek(file, 0, SEEK_END);
    length = ftell(file);
    rewind(file);
    jsonstr = (char*)malloc(length + 1);
    fread(jsonstr, sizeof(char), length, file);
    jsonstr[length] = '\0'; // Null-terminate the string []
    fclose(file);
    sym = sym_parse_string(jsonstr);
    free(jsonstr);
    return sym;
}


symbol_t* sym_parse_string(const char* jsonstr) {
    json_object* obj = NULL;
    symbol_t* sym = NULL;
    if (jsonstr == NULL) {
        sprintf(_sym_parse_error, "Invalid JSON string");
        _sym_parse_ok = 0;
        return NULL;
    }
    obj = json_tokener_parse(jsonstr);
    if (!obj) {
        sprintf(_sym_parse_error, "Invalid JSON string");
        _sym_parse_ok = 0;
        return NULL;
    }
    sym = sym_parse_from_json(obj);
    json_object_put(obj);

    return sym;
}


symbol_t* sym_parse_from_json(json_object* obj) {

    double width;
    JSON_GET_DOUBLE(obj, "width", width);
    double height;
    JSON_GET_DOUBLE(obj, "height", height);
    double dotspermm;
    JSON_GET_DOUBLE(obj, "dotspermm", dotspermm);
    json_object* objshapes;
    JSON_GET_ARRAY(obj, "shapes", objshapes);

    int32_t nshapes = json_object_array_length(objshapes);
    sym_shape_t** shapes = NULL;
    shapes = (sym_shape_t**)malloc(sizeof(sym_shape_t*) * nshapes);
    for (int32_t i = 0; i < nshapes; ++i) {
        shapes[i] = NULL;
    }
    for (int i = 0; i < nshapes; ++i) {
        json_object* objshp = json_object_array_get_idx(objshapes, i);
        shapes[i] = sym_shape_parse_from_json(objshp);
        if (!_sym_parse_ok) {
            for (int j = 0; j < i; ++j) {
                sym_shape_free(shapes[j]);
            }
            return NULL;
        }
    }
    _sym_parse_ok = 1;
    symbol_t* sym = sym_create();
    sym->width = width;
    sym->height = height;
    sym->dotspermm = dotspermm;
    sym->nshapes = nshapes;
    sym->shapes = shapes;

    return sym;
}



void sym_free(symbol_t* sym) {
    for (int i = 0; i < sym->nshapes; ++i) {
        sym_shape_free(sym->shapes[i]);
    }

    free(sym);
}

uint8_t sym_parse_ok() {
    return _sym_parse_ok;
}


const char* sym_parse_error() {
    return _sym_parse_error;
}


json_object* sym_to_json(symbol_t* sym) {
    json_object* obj;
    if (!sym) {
        return NULL;
    }
    obj = json_object_new_object();

    JSON_SET_DOUBLE(obj, "width", sym->width);
    JSON_SET_DOUBLE(obj, "height", sym->height);
    JSON_SET_DOUBLE(obj, "dotspermm", sym->dotspermm);

    json_object* arrshapes = json_object_new_array();

    for (int i = 0; i < sym->nshapes; ++i) {
        json_object* objshp = sym_shape_to_json(sym->shapes[i]);

        json_object_array_add(arrshapes, objshp);
    }

    json_object_object_add(obj, "shapes", arrshapes);
    return obj;
}




char* sym_to_string(symbol_t* symbol) {
    json_object* obj = sym_to_json(symbol);
    char* str = strdup(json_object_to_json_string(obj));
    json_object_put(obj);
    return str;
}




sym_shape_t* sym_shape_parse_from_json(json_object* obj) {

    if (json_object_get_type(obj) != json_type_object) {
        strcpy(_sym_parse_error, "Invalid shape object");
        _sym_parse_ok = 0;
        return NULL;
    }
    const char* strtype;
    JSON_GET_STRING(obj, "type", strtype);


    sym_shape_t* shp = NULL;
    if (strcmp(strtype, "line") == 0) {
        shp = (sym_shape_t*)sym_shape_line_parse_from_json(obj);
    }
    else if (strcmp(strtype, "fill") == 0) {
        shp = (sym_shape_t*)sym_shape_fill_parse_from_json(obj);
    }
    else if (strcmp(strtype, "path") == 0) {
        shp = (sym_shape_t*)sym_shape_path_parse_from_json(obj);
    }
    else {
        sprintf(_sym_parse_error, "Unknown shape type: %s", strtype);
        _sym_parse_ok = 0;
        return NULL;
    }

    if (!_sym_parse_ok) {
        return NULL;
    }
    _sym_parse_ok = 1;
    return shp;
}



json_object* sym_shape_to_json(sym_shape_t* shape) {
    json_object* obj = NULL;

    if (shape->type == SYM_SHAPE_LINE) {
        obj = sym_shape_line_to_json((sym_shape_line_t*)shape);
    }
    else if (shape->type == SYM_SHAPE_FILL) {
        obj = sym_shape_fill_to_json((sym_shape_fill_t*)shape);
    }
    else if (shape->type == SYM_SHAPE_PATH) {
        obj = sym_shape_path_to_json((sym_shape_path_t*)shape);
    }

    return obj;
}

void sym_shape_free(sym_shape_t* shape) {
    if (!shape) return;
    if (shape->type == SYM_SHAPE_LINE) {
        sym_shape_line_free(((sym_shape_line_t*)shape));
    }
    else if (shape->type == SYM_SHAPE_FILL) {
        sym_shape_fill_free(((sym_shape_fill_t*)shape));
    }

}




void sym_color_parse_from_json(json_object* obj, sym_color_t* color) {

    json_object* objval = json_object_array_get_idx(obj, 0);
    if (json_object_get_type(objval) != json_type_int || json_object_get_int(objval) < 0 || json_object_get_int(objval) > 255) {
        strcpy(_sym_parse_error, "Invalid 'color' values");
        _sym_parse_ok = 0;
        return;
    }
    color->r = json_object_get_int(objval);
    objval = json_object_array_get_idx(obj, 1);
    if (json_object_get_type(objval) != json_type_int || json_object_get_int(objval) < 0 || json_object_get_int(objval) > 255) {
        strcpy(_sym_parse_error, "Invalid 'color' values");
        _sym_parse_ok = 0;
        return;
    }
    color->g = json_object_get_int(objval);
    objval = json_object_array_get_idx(obj, 2);
    if (json_object_get_type(objval) != json_type_int || json_object_get_int(objval) < 0 || json_object_get_int(objval) > 255) {
        strcpy(_sym_parse_error, "Invalid 'color' values");
        _sym_parse_ok = 0;
        return;
    }
    color->b = json_object_get_int(objval);
    objval = json_object_array_get_idx(obj, 3);
    if (json_object_get_type(objval) != json_type_int || json_object_get_int(objval) < 0 || json_object_get_int(objval) > 255) {
        strcpy(_sym_parse_error, "Invalid 'color' values");
        _sym_parse_ok = 0;
        return;
    }
    color->a = json_object_get_int(objval);
    _sym_parse_ok = 1;
}


json_object* sym_color_to_json(sym_color_t* color) {
    json_object* obj = json_object_new_array();
    json_object_array_add(obj, json_object_new_int(color->r));
    json_object_array_add(obj, json_object_new_int(color->g));
    json_object_array_add(obj, json_object_new_int(color->b));
    json_object_array_add(obj, json_object_new_int(color->a));
    return obj;
}


