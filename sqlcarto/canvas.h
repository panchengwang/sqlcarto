#include "sqlcarto.h"
#include "sk_capi.h"

typedef struct {
    double  width, height;              // 图纸宽度，高度， 单位厘米
    double  pixelPerMillimeter;         // 点数/毫米
    double  cx,cy;                      // 地图中心点坐标
    double  minx,miny,maxx,maxy;        // 地图四角坐标
    double  scale;
    SK_SURFACE_H skSurface;             // 
    SK_CANVAS_H skCanvas;               // 画布
}MapCanvas;


MapCanvas *sc_canvas_create_internal();
void sc_canvas_destroy_internal(MapCanvas* canvas);
void sc_canvas_save_to_file_internal(MapCanvas* canvas, const char* filename, const char* format);
void sc_canvas_draw_geometry_internal(MapCanvas* canvas, LWGEOM* lwgeom);

text* address_to_hex(void* address);
void* hex_to_address(text* hex);