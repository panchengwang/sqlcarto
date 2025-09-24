#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;



sym_shape_line_t* sym_shape_line_create() {
    sym_shape_line_t* line = (sym_shape_line_t*)malloc(sizeof(sym_shape_line_t));
    memset(line, 0, sizeof(sym_shape_line_t));
    line->type = SYM_SHAPE_LINE;
    line->stroke = NULL;
    return line;
}

sym_shape_line_t* sym_shape_line_parse_from_json(json_object* obj) {
    json_object* objstroke;
    JSON_GET_OBJECT(obj, "stroke", objstroke);

    sym_stroke_t* stroke = NULL;
    stroke = sym_stroke_parse_from_json(objstroke);
    if (_sym_parse_ok == 0) {
        return NULL;
    }

    _sym_parse_ok = 1;
    sym_shape_line_t* line = sym_shape_line_create();
    line->stroke = stroke;
    return line;
}


json_object* sym_shape_line_to_json(sym_shape_line_t* shape) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "line");
    json_object* objstroke = sym_stroke_to_json(shape->stroke);
    json_object_object_add(obj, "stroke", objstroke);
    return obj;
}

void sym_shape_line_free(sym_shape_line_t* line) {
    if (!line) return;
    sym_stroke_free(line->stroke);
    free(line);
    line = NULL;
}