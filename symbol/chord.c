#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

sym_sub_path_chord_t* sym_chord_create() {
    sym_sub_path_chord_t* chord = (sym_sub_path_chord_t*)sym_arc_create();
    chord->type = SYM_SUB_PATH_CHORD;
    return chord;
}


sym_sub_path_chord_t* sym_chord_parse_from_json(json_object* obj) {
    sym_sub_path_chord_t* chord = (sym_sub_path_chord_t*)sym_arc_parse_from_json(obj);
    if (!_sym_parse_ok)  return NULL;
    chord->type = SYM_SUB_PATH_CHORD;
    return chord;

}


json_object* sym_chord_to_json(sym_sub_path_chord_t* chord) {
    json_object* obj = sym_arc_to_json((sym_sub_path_arc_t*)chord);
    JSON_SET_STRING(obj, "type", "chord");
    return obj;
}


void sym_chord_free(sym_sub_path_chord_t* chord) {
    free(chord);
    chord = NULL;
}

