#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

uint8_t sym_point_from_json(sym_point_t* point, json_object* obj) {
    if (json_object_get_type(obj) == json_type_object) {
        JSON_GET_DOUBLE_WITHOUT_RETURN(obj, "x", point->x);
        if (!_sym_parse_ok) {
            return 0;
        }
        JSON_GET_DOUBLE_WITHOUT_RETURN(obj, "y", point->y);
        if (!_sym_parse_ok) {
            return 0;
        }
        return 1;
    }
    else if (json_object_is_type(obj, json_type_array) && json_object_array_length(obj) == 2) {
        json_object* x = json_object_array_get_idx(obj, 0);
        json_object* y = json_object_array_get_idx(obj, 1);
        if (!json_object_is_type(x, json_type_double) || !json_object_is_type(y, json_type_double)) {
            sprintf(_sym_parse_error, "Expecting an array of length 2, include two double values such as : [0.5,0.5]");
            _sym_parse_ok = 0;
            return 0;
        }
        point->x = json_object_get_double(x);
        point->y = json_object_get_double(y);
        return 1;
    }

    sprintf(_sym_parse_error, "Expecting an object or array of length 2");
    _sym_parse_ok = 0;
    return 0;
}


json_object* sym_point_to_json(sym_point_t* point) {
    json_object* obj = json_object_new_array();
    json_object_array_add(obj, json_object_new_double(point->x));
    json_object_array_add(obj, json_object_new_double(point->y));
    return obj;
}

