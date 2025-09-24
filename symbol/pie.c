#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_pie_t* sym_pie_create() {
    sym_sub_path_pie_t* pie = (sym_sub_path_pie_t*)sym_arc_create();
    pie->type = SYM_SUB_PATH_PIE;
    return pie;
}


sym_sub_path_pie_t* sym_pie_parse_from_json(json_object* obj) {
    sym_sub_path_pie_t* pie = (sym_sub_path_pie_t*)sym_arc_parse_from_json(obj);
    if (!_sym_parse_ok)  return NULL;
    pie->type = SYM_SUB_PATH_PIE;
    return pie;

}


json_object* sym_pie_to_json(sym_sub_path_pie_t* pie) {
    json_object* obj = sym_arc_to_json((sym_sub_path_arc_t*)pie);
    JSON_SET_STRING(obj, "type", "pie");
    return obj;
}


void sym_pie_free(sym_sub_path_pie_t* pie) {
    free(pie);
    pie = NULL;
}

