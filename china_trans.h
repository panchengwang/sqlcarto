#ifndef __CHINA_TRANS_H
#define __CHINA_TRANS_H

#include "liblwgeom.h"

double transformlat(double lng, double lat);
double transformlng(double lng, double lat);

// lwgeom转换函数的统一形式，采用回调函数实现
typedef void (*coord_convert)(double lng, double lat, double* x, double* y);
int lwgeom_mars_convert(LWGEOM *geom, coord_convert convertor);
int pointarray_mars_convert(POINTARRAY* pa, coord_convert convertor);

// 坐标系转换函数
int lwgeom_gcj02_to_bd09(LWGEOM *geom);
int lwgeom_bd09_to_gcj02(LWGEOM *geom);
int lwgeom_wgs84_to_bd09(LWGEOM *geom);
int lwgeom_bd09_to_wgs84(LWGEOM *geom);
int lwgeom_wgs84_to_gcj02(LWGEOM *geom);
int lwgeom_gcj02_to_wgs84(LWGEOM *geom);

// 实际的转换函数，仅限内部使用
void gcj02_to_bd09_internal(double lng, double lat, double *x, double *y); 		// 火星坐标系->百度坐标系
void bd09_to_gcj02_internal(double lng, double lat, double *x, double *y); 		// 百度坐标系->火星坐标系
void wgs84_to_gcj02_internal(double lng, double lat, double *x, double *y); 		// WGS84坐标系->火星坐标系
void gcj02_to_wgs84_internal(double lng, double lat, double *x, double *y); 		// 火星坐标系->WGS84坐标系
void bd09_to_wgs84_internal(double lng, double lat, double *x, double *y);			// 百度坐标系->WGS84坐标系
void wgs84_to_bd09_internal(double lng, double lat, double *x, double *y); 		// WGS84坐标系->百度坐标系



#endif
