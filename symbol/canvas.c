#include "symbol_parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "json_utils.h"

extern char _sym_parse_error[1024];
extern uint8_t _sym_parse_ok;

#define  _sym_canvas_ok         _sym_parse_ok
#define  _sym_canvas_error      _sym_parse_error

#define CANVAS_MAX_WIDTH  500.0
#define CANVAS_MAX_HEIGHT 500.0
#define CANVAS_MAX_PIXEL_WIDTH  10000
#define CANVAS_MAX_PIXEL_HEIGHT 10000

#define MAX_DPI 300.0

sym_canvas_t* sym_canvas_create() {
    sym_canvas_t* canvas = (sym_canvas_t*)malloc(sizeof(sym_canvas_t));
    canvas->width = 10;
    canvas->height = 10;
    canvas->dotspermm = 96.0 / 25.4;
    canvas->surface = NULL;
    canvas->cairo = NULL;
    return canvas;
}



uint8_t sym_canvas_set_size(sym_canvas_t* canvas, double width, double height) {
    if (width >= CANVAS_MAX_WIDTH || height >= CANVAS_MAX_HEIGHT) {
        _sym_canvas_ok = 0;
        snprintf(_sym_canvas_error, sizeof(_sym_canvas_error),
            "The size of the canvas is too large: %fmm x %fmm, width must be less than %fmm, height must less than %fmm",
            width, height, CANVAS_MAX_WIDTH, CANVAS_MAX_HEIGHT);
        return 0;
    }
    canvas->width = width;
    canvas->height = height;
    return 1;
}



uint8_t sym_canvas_set_dotspermm(sym_canvas_t* canvas, double dotspermm) {
    if (dotspermm < 1 || dotspermm > MAX_DPI / 25.4) {
        _sym_canvas_ok = 0;
        snprintf(_sym_canvas_error, sizeof(_sym_canvas_error), "The dotspermm is too large: %f, it must be less than %f", dotspermm, MAX_DPI / 25.4);
        return 0;
    }

    canvas->dotspermm = dotspermm;
    return 1;
}

uint8_t sym_canvas_set_dpi(sym_canvas_t* canvas, double dpi) {
    if (dpi < 1 || dpi > MAX_DPI) {
        _sym_canvas_ok = 0;
        snprintf(_sym_canvas_error, sizeof(_sym_canvas_error), "The dpi is too large: %f, it must be less than %f", dpi, MAX_DPI);
        return 0;
    }
    canvas->dotspermm = dpi / 25.4;
    return 1;
}

uint8_t sym_canvas_begin(sym_canvas_t* canvas) {
    if (strcasecmp(canvas->format, "png") == 0) {
        double width = canvas->width * canvas->dotspermm;
        double height = canvas->height * canvas->dotspermm;
        if (width > CANVAS_MAX_PIXEL_WIDTH || height > CANVAS_MAX_PIXEL_HEIGHT) {
            _sym_canvas_ok = 0;
            snprintf(_sym_canvas_error, sizeof(_sym_canvas_error), "The size of the canvas is too large: %f x %f, width must be less than %d, height must less than %d",
                width, height, CANVAS_MAX_PIXEL_WIDTH, CANVAS_MAX_PIXEL_HEIGHT);
            return 0;
        }
        canvas->surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, canvas->width * canvas->dotspermm, canvas->height * canvas->dotspermm);
    }
    else if (strcasecmp(canvas->format, "pdf") == 0) {
        canvas->surface = NULL;
        _sym_canvas_ok = 0;
        snprintf(_sym_canvas_error, sizeof(_sym_canvas_error), "Unknown support format: %s, this format will be supported in a few years...", canvas->format);
        return;
    }
    else {
        _sym_canvas_ok = 0;
        snprintf(_sym_canvas_error, sizeof(_sym_canvas_error), "Unknown format: %s", canvas->format);
        return;
    }

    canvas->cairo = cairo_create(canvas->surface);
}



uint8_t sym_canvas_end(sym_canvas_t* canvas) {
    cairo_surface_flush(canvas->surface);
}



uint8_t sym_canvas_free(sym_canvas_t* canvas) {
    if (canvas->cairo != NULL) {
        cairo_destroy(canvas->cairo);
        canvas->cairo = NULL;
    }
    if (canvas->surface != NULL) {
        cairo_surface_destroy(canvas->surface);
        canvas->surface = NULL;
    }

    free(canvas);
    return 1;
}



uint8_t sym_canvas_draw(sym_canvas_t* canvas, symbol_t* symbol) {
    return 1;
}



uint8_t sym_canvas_draw_shape(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_linestring(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_polygon(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_arc(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_pie(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_chord(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_ellipse(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_circle(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_regular_polygon(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_star(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



uint8_t sym_canvas_draw_subpath_text(sym_canvas_t* canvas, sym_shape_t* shape) {
    return 1;
}



char* sym_canvas_get_data(sym_canvas_t* canvas, int32_t* size) {
    return 1;
}


