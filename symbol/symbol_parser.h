#ifndef __SYMBOL_PARSER_H__
#define __SYMBOL_PARSER_H__

#include <stdint.h>
#include <json-c/json.h>

#define SYM_SUB_PATH_LINESTRING                 1
#define SYM_SUB_PATH_POLYGON                    2
#define SYM_SUB_PATH_ARC                        3
#define SYM_SUB_PATH_PIE                        4
#define SYM_SUB_PATH_CHORD                      5
#define SYM_SUB_PATH_CIRCLE                     6
#define SYM_SUB_PATH_ELLIPSE                    7
#define SYM_SUB_PATH_RECTANGLE                  8
#define SYM_SUB_PATH_ROUNDEDRECTANGLE           9
#define SYM_SUB_PATH_REGULAR_POLYGON            10
#define SYM_SUB_PATH_STAR                       11
#define SYM_SUB_PATH_TEXT                       12

#define SYM_SHAPE_LINE                          1
#define SYM_SHAPE_FILL                          2
#define SYM_SHAPE_PATH                          3
#define SYM_SHAPE_IMAGE                         4

#define SYM_FILL_NONE                           0
#define SYM_FILL_SOLID                          1
#define SYM_FILL_GRADIENT                       2
#define SYM_FILL_IMAGE                          3

#define SYM_CAP_BUTT                            0
#define SYM_CAP_ROUND                           1
#define SYM_CAP_SQUARE                          2

#define SYM_JOIN_MITER                          0
#define SYM_JOIN_ROUND                          1
#define SYM_JOIN_BEVEL                          2

typedef struct sym_point_t {
    double x, y;
}sym_point_t;

typedef struct sym_color_t {
    uint8_t r, g, b, a;
} sym_color_t;

typedef struct sym_stroke_t {
    uint8_t cap;
    uint8_t join;
    sym_color_t color;
    double width;
    uint32_t ndashes;
    double* dashes;
    double dashes_offset;
}sym_stroke_t;

typedef struct sym_fill_t {
    uint8_t type;
}sym_fill_t;

typedef struct sym_fill_solid_t {
    uint8_t type;
    sym_color_t color;
}sym_fill_solid_t;

typedef struct sym_shape_t {
    uint8_t type;
} sym_shape_t;

typedef struct sym_sub_path_t {
    uint8_t type;
    double rotation;
}sym_sub_path_t;

typedef struct sym_sub_path_linestring_t {
    uint8_t type;
    double rotation;
    sym_point_t* points;
    uint32_t npoints;
}sym_sub_path_linestring_t;

typedef struct sym_sub_path_polygon_t {
    uint8_t type;
    double rotation;
    sym_point_t* points;
    uint32_t npoints;
}sym_sub_path_polygon_t;

typedef struct sym_sub_path_ellipse_t {
    uint8_t type;
    double rotation;
    sym_point_t center;
    double radiusx;
    double radiusy;
}sym_sub_path_ellipse_t;

typedef struct sym_sub_path_arc_t {
    uint8_t type;
    double rotation;
    sym_point_t center;
    double radiusx;
    double radiusy;
    double start_angle;
    double end_angle;
}sym_sub_path_arc_t;





typedef struct sym_shape_path_t {
    uint8_t type;
    sym_stroke_t* stroke;
    sym_fill_t* fill;
    uint8_t closed;
    double offsset_along_line;
    int32_t nsubpaths;
    sym_sub_path_t** subpaths;
}sym_shape_path_t;

typedef struct sym_shape_line_t {
    uint8_t type;
    sym_stroke_t* stroke;
}sym_shape_line_t;

typedef struct sym_shape_fill_t {
    uint8_t type;
    sym_fill_t* fill;
}sym_shape_fill_t;

typedef struct symbol_t {
    double width, height;
    double dotspermm;
    int32_t nshapes;
    sym_shape_t** shapes;
} symbol_t;




symbol_t* sym_create();
symbol_t* sym_parse_file(const char* filename);
symbol_t* sym_parse_string(const char* string);
symbol_t* sym_parse_from_json(json_object* obj);
void sym_free(symbol_t* symbol);
uint8_t sym_parse_ok();
const char* sym_parse_error();

json_object* sym_to_json(symbol_t* symbol);
char* sym_to_string(symbol_t* symbol);


void sym_color_parse_from_json(json_object* obj, sym_color_t* color);
json_object* sym_color_to_json(sym_color_t* color);

sym_stroke_t* sym_stroke_parse_from_json(json_object* obj);
json_object* sym_stroke_to_json(sym_stroke_t* stroke);
void sym_stroke_free(sym_stroke_t* stroke);

sym_fill_t* sym_fill_parse_from_json(json_object* obj);
json_object* sym_fill_to_json(sym_fill_t* fill);
void sym_fill_free(sym_fill_t* fill);

sym_fill_solid_t* sym_fill_solid_create();
sym_fill_solid_t* sym_fill_solid_parse_from_json(json_object* obj);
json_object* sym_fill_solid_to_json(sym_fill_solid_t* fill);
void sym_fill_solid_free(sym_fill_solid_t* fill);

sym_shape_t* sym_shape_parse_from_json(json_object* obj);
json_object* sym_shape_to_json(sym_shape_t* shape);
void sym_shape_free(sym_shape_t* shape);

sym_shape_line_t* sym_shape_line_create();
sym_shape_line_t* sym_shape_line_parse_from_json(json_object* obj);
json_object* sym_shape_line_to_json(sym_shape_line_t* shape);
void sym_shape_line_free(sym_shape_line_t* shape);

sym_shape_path_t* sym_shape_path_create();
sym_shape_path_t* sym_shape_path_parse_from_json(json_object* obj);
json_object* sym_shape_path_to_json(sym_shape_path_t* shape);
void sym_shape_path_free(sym_shape_path_t* shape);


sym_sub_path_t* sym_sub_path_parse_from_json(json_object* obj);
json_object* sym_sub_path_to_json(sym_sub_path_t* subpath);
void sym_sub_path_free(sym_sub_path_t* subpath);

sym_shape_fill_t* sym_shape_fill_create();
sym_shape_fill_t* sym_shape_fill_parse_from_json(json_object* obj);
json_object* sym_shape_fill_to_json(sym_shape_fill_t* shape);
void sym_shape_fill_free(sym_shape_fill_t* shape);


sym_sub_path_linestring_t* sym_linestring_create();
sym_sub_path_linestring_t* sym_linestring_parse_from_json(json_object* obj);
json_object* sym_linestring_to_json(sym_sub_path_linestring_t* line);
void sym_linestring_free(sym_sub_path_linestring_t* line);

sym_sub_path_polygon_t* sym_polygon_create();
sym_sub_path_polygon_t* sym_polygon_parse_from_json(json_object* obj);
json_object* sym_polygon_to_json(sym_sub_path_polygon_t* pg);
void sym_polygon_free(sym_sub_path_polygon_t* pg);


sym_sub_path_arc_t* sym_arc_create();
sym_sub_path_arc_t* sym_arc_parse_from_json(json_object* obj);
json_object* sym_arc_to_json(sym_sub_path_arc_t* arc);
void sym_arc_free(sym_sub_path_arc_t* arc);


sym_sub_path_ellipse_t* sym_ellipse_create();
sym_sub_path_ellipse_t* sym_ellipse_parse_from_json(json_object* obj);
json_object* sym_ellipse_to_json(sym_sub_path_ellipse_t* ellipse);
void sym_ellipse_free(sym_sub_path_ellipse_t* ellipse);

#endif