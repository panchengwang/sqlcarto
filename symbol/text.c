#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;


// uint8_t type;
// double rotation;
// sym_point_t center;
// uint8_t outlined;
// double outlined_width;
// uint8_t weight;
// uint8_t slant;
// double font_size;
// char* font_name;
// char* text;
sym_sub_path_text_t* sym_text_create() {
    sym_sub_path_text_t* text = (sym_sub_path_text_t*)malloc(sizeof(sym_sub_path_text_t));
    text->type = SYM_SUB_PATH_TEXT;
    text->rotation = 0;
    text->center.x = 0.0;
    text->center.y = 0.0;
    text->outlined = 0;
    text->outlined_width = 0.2;
    text->weight = SYM_FONT_WEIGHT_NORMAL;
    text->slant = SYM_FONT_SLANT_NORMAL;
    text->font_size = 0.7;
    text->font_name = NULL;
    text->text = NULL;

    return text;
}


sym_sub_path_text_t* sym_text_parse_from_json(json_object* obj) {
    double rotation;
    JSON_GET_DOUBLE(obj, "rotation", rotation);
    sym_point_t center;
    JSON_GET_POINT(obj, "center", center);
    uint8_t outlined;
    JSON_GET_BOOLEAN(obj, "outlined", outlined);
    double outlined_width;
    JSON_GET_DOUBLE(obj, "outlinedwidth", outlined_width);

    const char* strweight;
    JSON_GET_STRING(obj, "weight", strweight);
    uint8_t weight;
    if (strcmp(strweight, "normal") == 0) {
        weight = SYM_FONT_WEIGHT_NORMAL;
    }
    else if (strcmp(strweight, "bold") == 0) {
        weight = SYM_FONT_WEIGHT_BOLD;
    }
    else {
        sprintf(_sym_parse_error, "Invalid font weight: %s", strweight);
        _sym_parse_ok = 0;
        return NULL;
    }

    const char* strslant;
    JSON_GET_STRING(obj, "slant", strslant);
    uint8_t slant;
    if (strcmp(strslant, "normal") == 0) {
        slant = SYM_FONT_SLANT_NORMAL;
    }
    else if (strcmp(strslant, "italic") == 0) {
        slant = SYM_FONT_SLANT_ITALIC;
    }
    else if (strcmp(strslant, "oblique") == 0) {
        slant = SYM_FONT_SLANT_OBLIQUE;
    }
    else {
        sprintf(_sym_parse_error, "Invalid font slant: %s", strslant);
        _sym_parse_ok = 0;
        return NULL;
    }

    double font_size;
    JSON_GET_DOUBLE(obj, "fontsize", font_size);
    const char* font_name;
    JSON_GET_STRING(obj, "fontname", font_name);
    const char* strtext;
    JSON_GET_STRING(obj, "text", strtext);
    sym_sub_path_text_t* text = sym_text_create();
    text->rotation = rotation;
    text->center = center;
    text->outlined = outlined;
    text->outlined_width = outlined_width;
    text->weight = weight;
    text->slant = slant;
    text->font_size = font_size;
    text->font_name = strdup(font_name);
    text->text = strdup(strtext);
    return text;
}


json_object* sym_text_to_json(sym_sub_path_text_t* text) {
    json_object* obj = json_object_new_object();
    JSON_SET_STRING(obj, "type", "text");
    JSON_SET_DOUBLE(obj, "rotation", text->rotation);
    JSON_SET_POINT(obj, "center", text->center);
    JSON_SET_BOOLEAN(obj, "outlined", text->outlined);
    JSON_SET_DOUBLE(obj, "outlinedwidth", text->outlined_width);
    switch (text->weight) {
    case SYM_FONT_WEIGHT_NORMAL:
        JSON_SET_STRING(obj, "weight", "normal");
        break;
    case SYM_FONT_WEIGHT_BOLD:
        JSON_SET_STRING(obj, "weight", "bold");
        break;
    default:
        sprintf(_sym_parse_error, "Invalid weight: %d", text->weight);
        json_object_put(obj);
        _sym_parse_ok = 0;
        return NULL;
    }
    switch (text->slant) {
    case SYM_FONT_SLANT_NORMAL:
        JSON_SET_STRING(obj, "slant", "normal");
        break;
    case SYM_FONT_SLANT_ITALIC:
        JSON_SET_STRING(obj, "slant", "italic");
        break;
    case SYM_FONT_SLANT_OBLIQUE:
        JSON_SET_STRING(obj, "slant", "oblique");
        break;
    default:
        sprintf(_sym_parse_error, "Invalid slant: %d", text->slant);
        json_object_put(obj);
        _sym_parse_ok = 0;
        return NULL;
    }
    JSON_SET_DOUBLE(obj, "fontsize", text->font_size);
    JSON_SET_STRING(obj, "fontname", text->font_name);
    JSON_SET_STRING(obj, "text", text->text);
    return obj;
}


void sym_text_free(sym_sub_path_text_t* text) {
    free(text->font_name);
    free(text->text);
    free(text);
    text = NULL;
}

