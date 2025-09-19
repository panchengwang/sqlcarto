#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_stroke_t* sym_stroke_parse_from_json(json_object* obj) {
    sym_stroke_t* stroke = (sym_stroke_t*)malloc(sizeof(sym_stroke_t));

    const char* strcap;
    JSON_GET_STRING(obj, "cap", strcap);
    if (!_sym_parse_ok) {
        sym_stroke_free(stroke);
        return NULL;
    }
    if (strcmp(strcap, "butt") == 0) {
        stroke->cap = SYM_CAP_BUTT;
    }
    else if (strcmp(strcap, "round") == 0) {
        stroke->cap = SYM_CAP_ROUND;
    }
    else if (strcmp(strcap, "square") == 0) {
        stroke->cap = SYM_CAP_SQUARE;
    }
    else {
        strcpy(_sym_parse_error, "Invalid 'cap' value");
        _sym_parse_ok = 0;
        sym_stroke_free(stroke);
        return NULL;
    }

    const char* strjoin;
    JSON_GET_STRING(obj, "join", strjoin);
    if (!_sym_parse_ok) {
        sym_stroke_free(stroke);
        return NULL;
    }
    if (strcmp(strjoin, "bevel") == 0) {
        stroke->join = SYM_JOIN_BEVEL;
    }
    else if (strcmp(strjoin, "miter") == 0) {
        stroke->join = SYM_JOIN_MITER;
    }
    else if (strcmp(strjoin, "round") == 0) {
        stroke->join = SYM_JOIN_ROUND;
    }
    else {
        strcpy(_sym_parse_error, "Invalid 'join' value");
        _sym_parse_ok = 0;
        sym_stroke_free(stroke);
        return NULL;
    }


    JSON_GET_DOUBLE(obj, "width", stroke->width);
    if (!_sym_parse_ok) {
        sym_stroke_free(stroke);
        return NULL;
    }


    json_object* objcolor;
    objcolor = json_object_object_get(obj, "color");
    if (objcolor == NULL) {
        strcpy(_sym_parse_error, "Missing 'color' key");
        _sym_parse_ok = 0;
        sym_stroke_free(stroke);
        return NULL;
    }
    if (json_object_get_type(objcolor) != json_type_array || json_object_array_length(objcolor) != 4) {
        sprintf(_sym_parse_error, "Invalid 'color' values: %s", json_object_to_json_string(objcolor));
        _sym_parse_ok = 0;
        sym_stroke_free(stroke);
        return NULL;
    }
    sym_color_parse_from_json(objcolor, &stroke->color);
    if (!_sym_parse_ok) {
        sym_stroke_free(stroke);
        return NULL;
    }

    json_object* objdashes;
    objdashes = json_object_object_get(obj, "dashes");
    if (json_object_get_type(objdashes) != json_type_array) {
        strcpy(_sym_parse_error, "Invalid 'dashes' values");
        _sym_parse_ok = 0;
        sym_stroke_free(stroke);
        return NULL;
    }
    int ndash = json_object_array_length(objdashes);
    stroke->ndashes = ndash;

    if (ndash > 0) {
        stroke->dashes = (double*)malloc(sizeof(double) * ndash);

        for (int i = 0; i < ndash; i++) {
            json_object* objdash = json_object_array_get_idx(objdashes, i);

            if (json_object_get_type(objdash) != json_type_double
                && json_object_get_type(objdash) != json_type_int) {
                strcpy(_sym_parse_error, "Invalid 'dasharray' values");
                _sym_parse_ok = 0;
                sym_stroke_free(stroke);
                return NULL;
            }
            stroke->dashes[i] = json_object_get_double(objdash);
        }
    }

    JSON_GET_DOUBLE(obj, "dashesoffset", stroke->dashes_offset);
    if (!_sym_parse_ok) {
        sym_stroke_free(stroke);
        return NULL;
    }
    _sym_parse_ok = 1;
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
