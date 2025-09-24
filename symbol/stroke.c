#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_stroke_t* sym_stroke_parse_from_json(json_object* obj) {

    if (!obj) {
        sprintf(_sym_parse_error, "Missing: stroke ");
        _sym_parse_ok = 0;
        return NULL;
    }

    const char* strcap;
    JSON_GET_STRING(obj, "cap", strcap);
    uint8_t cap;
    if (strcmp(strcap, "butt") == 0) {
        cap = SYM_CAP_BUTT;
    }
    else if (strcmp(strcap, "round") == 0) {
        cap = SYM_CAP_ROUND;
    }
    else if (strcmp(strcap, "square") == 0) {
        cap = SYM_CAP_SQUARE;
    }
    else {
        strcpy(_sym_parse_error, "Invalid 'cap' value");
        _sym_parse_ok = 0;
        return NULL;
    }

    const char* strjoin;
    JSON_GET_STRING(obj, "join", strjoin);

    uint8_t join;
    if (strcmp(strjoin, "bevel") == 0) {
        join = SYM_JOIN_BEVEL;
    }
    else if (strcmp(strjoin, "miter") == 0) {
        join = SYM_JOIN_MITER;
    }
    else if (strcmp(strjoin, "round") == 0) {
        join = SYM_JOIN_ROUND;
    }
    else {
        strcpy(_sym_parse_error, "Invalid 'join' value");
        _sym_parse_ok = 0;
        return NULL;
    }

    double width;
    JSON_GET_DOUBLE(obj, "width", width);
    sym_color_t color;
    JSON_GET_COLOR(obj, "color", color);



    json_object* objdashes;
    objdashes = json_object_object_get(obj, "dashes");
    if (json_object_get_type(objdashes) != json_type_array) {
        strcpy(_sym_parse_error, "Invalid 'dashes' values");
        _sym_parse_ok = 0;
        return NULL;
    }
    int ndash = json_object_array_length(objdashes);
    double* dashes = NULL;

    if (ndash > 0) {
        dashes = (double*)malloc(sizeof(double) * ndash);

        for (int i = 0; i < ndash; i++) {
            json_object* objdash = json_object_array_get_idx(objdashes, i);

            if (json_object_get_type(objdash) != json_type_double
                && json_object_get_type(objdash) != json_type_int) {
                strcpy(_sym_parse_error, "Invalid 'dasharray' values");
                _sym_parse_ok = 0;
                free(dashes);
                return NULL;
            }
            dashes[i] = json_object_get_double(objdash);
        }
    }

    double dashes_offset;
    JSON_GET_DOUBLE(obj, "dashesoffset", dashes_offset);

    _sym_parse_ok = 1;

    sym_stroke_t* stroke = (sym_stroke_t*)malloc(sizeof(sym_stroke_t));
    stroke->cap = cap;
    stroke->join = join;
    stroke->width = width;
    stroke->color = color;
    stroke->ndashes = ndash;
    stroke->dashes = dashes;
    stroke->dashes_offset = dashes_offset;


    return stroke;
}


json_object* sym_stroke_to_json(sym_stroke_t* stroke) {
    json_object* obj = json_object_new_object();

    switch (stroke->cap) {
    case SYM_CAP_BUTT:
        json_object_object_add(obj, "cap", json_object_new_string("butt"));
        break;
    case SYM_CAP_ROUND:
        json_object_object_add(obj, "cap", json_object_new_string("round"));
        break;
    case SYM_CAP_SQUARE:
        json_object_object_add(obj, "cap", json_object_new_string("square"));
        break;
    }

    switch (stroke->join) {
    case SYM_JOIN_BEVEL:
        json_object_object_add(obj, "join", json_object_new_string("bevel"));
        break;
    case SYM_JOIN_MITER:
        json_object_object_add(obj, "join", json_object_new_string("miter"));
        break;
    case SYM_JOIN_ROUND:
        json_object_object_add(obj, "join", json_object_new_string("round"));
        break;
    }

    json_object_object_add(obj, "width", json_object_new_double(stroke->width));
    json_object* objcolor = sym_color_to_json(&stroke->color);
    json_object_object_add(obj, "color", objcolor);
    json_object* objdashes = json_object_new_array();
    for (int i = 0; i < stroke->ndashes; i++) {
        json_object_array_add(objdashes, json_object_new_double(stroke->dashes[i]));
    }
    json_object_object_add(obj, "dashes", objdashes);
    json_object_object_add(obj, "dashesoffset", json_object_new_double(stroke->dashes_offset));


    return obj;
}


void sym_stroke_free(sym_stroke_t* stroke) {
    if (!stroke) return;
    free(stroke->dashes);
    stroke->ndashes = 0;
    stroke->dashes = NULL;
    free(stroke);
    stroke = NULL;
}
