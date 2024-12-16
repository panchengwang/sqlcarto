#include "canvas.h"
#include "sqlcarto.h"

MapCanvas *sc_canvas_create_internal(){
    MapCanvas *canvas = (MapCanvas*)malloc(sizeof(MapCanvas));
    canvas->width = 800;
    canvas->height = 500;
    canvas->skSurface= sk_surface_create(canvas->width,canvas->height);
    canvas->skCanvas = sk_canvas_create(canvas->skSurface);
    canvas->scale = 1.0;
    canvas->pixelPerMillimeter = 72.0/25.4;             // 缺省：没英寸72个像素点
    canvas->minx = -180;
    canvas->maxx = 180;
    canvas->miny = -90;
    canvas->maxy = 90;
    return canvas;
}


void sc_canvas_destroy_internal(MapCanvas* canvas){
    if(canvas->skCanvas){
        sk_canvas_destroy(canvas->skCanvas);
    }
    if(canvas->skSurface){
        sk_surface_destroy(canvas->skSurface);
    }
    free(canvas);
}

// 内存地址转换成16进制字符串
text* address_to_hex(void* address){
    char buf[19];
    sprintf(buf,"%016llX",(unsigned long long)address);
    return cstring_to_text(buf);
}


// 从16进制字符串获取内存地址
void* hex_to_address(text* hex){
    unsigned long long address = strtoull(text_to_cstring(hex),NULL,16);
    return (void*)address;
}


void sc_canvas_save_to_file_internal(MapCanvas* canvas, const char* filename, const char* format){
    sk_surface_save_to_file(canvas->skSurface, filename, format);
}


void sc_canvas_draw_geometry_internal(MapCanvas* canvas, LWGEOM* lwgeom){
    SK_CANVAS_H skcanvas = canvas->skCanvas;
    SK_PAINT_H paint = sk_paint_create();
    sk_paint_set_rgba(paint,255,0,0,255);
    sk_paint_set_style(paint,SkPaintStyle_Stroke);
    sk_paint_set_stroke_width(paint,2.0f);
    sk_paint_set_antialias(paint,1);
    // sk_canvas_draw_rect(canvas,paint, 100,100,244.33,255);

    sk_paint_set_rgba(paint, 0,0,255,255);
    sk_paint_set_stroke_width(paint,2);
    sk_canvas_draw_line(skcanvas,paint, 0,0,300,300);
}

/**
 * 
 */
PG_FUNCTION_INFO_V1(sc_canvas_create); 	
Datum sc_canvas_create(PG_FUNCTION_ARGS)
{
    MapCanvas *canvas = sc_canvas_create_internal();
    PG_RETURN_TEXT_P(address_to_hex((void*)canvas));
}


/**
 * 
 */
PG_FUNCTION_INFO_V1(sc_canvas_destroy); 	
Datum sc_canvas_destroy(PG_FUNCTION_ARGS){
    text* hex = PG_GETARG_TEXT_P(0);
    MapCanvas* canvas = (MapCanvas*) hex_to_address(hex);

    sc_canvas_destroy_internal(canvas);

    PG_RETURN_TEXT_P(hex);
}		


PG_FUNCTION_INFO_V1(sc_canvas_draw_geometry); 	
Datum sc_canvas_draw_geometry(PG_FUNCTION_ARGS)
{
    text* hex = PG_GETARG_TEXT_P(0);
    MapCanvas* canvas = (MapCanvas*) hex_to_address(hex);
    GSERIALIZED* geom;
    LWGEOM* lwgeom;

    geom = PG_GETARG_GSERIALIZED_P_COPY(1);
	if(geom == NULL){
		PG_RETURN_TEXT_P(hex);
	}
    lwgeom = lwgeom_from_gserialized(geom);
    sc_canvas_draw_geometry_internal(canvas,lwgeom);
    lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
    PG_RETURN_TEXT_P(hex);
}



PG_FUNCTION_INFO_V1(sc_canvas_save_to_file); 	
Datum sc_canvas_save_to_file(PG_FUNCTION_ARGS){
    text* hex = PG_GETARG_TEXT_P(0);
    MapCanvas* canvas = (MapCanvas*) hex_to_address(hex);
    char* filename = text_to_cstring(PG_GETARG_TEXT_P(1));
    char* format = text_to_cstring(PG_GETARG_TEXT_P(2));

    sc_canvas_save_to_file_internal(canvas,filename,format);
    pfree(filename);
    pfree(format);

    PG_RETURN_TEXT_P(hex);
}	

