#include "china_trans.h"
#include "postgres.h"
#include <math.h>
#include "lwgeom_log.h"

#define x_pi  (3.14159265358979324 * 3000.0 / 180.0)
#define pi  3.1415926535897932384626  
#define a  6378245.0                 
#define ee  0.00669342162296594323  



double transformlat(double lng, double lat){
  double ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 
    0.1 * lng * lat + 0.2 * sqrt(fabs(lng));
  ret += (20.0 * sin(6.0 * lng * pi) + 20.0 *
    sin(2.0 * lng * pi)) * 2.0 / 3.0 ;
  ret += (20.0 * sin(lat * pi) + 40.0 *
    sin(lat / 3.0 * pi)) * 2.0 / 3.0 ;
  ret += (160.0 * sin(lat / 12.0 * pi) + 320 *
    sin(lat * pi / 30.0)) * 2.0 / 3.0 ;
  return ret;
}


double transformlng(double lng, double lat){
  double ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 
    0.1 * lng * lat + 0.1 * sqrt(fabs(lng));
  ret += (20.0 * sin(6.0 * lng * pi) + 20.0 *
    sin(2.0 * lng * pi)) * 2.0 / 3.0;
  ret += (20.0 * sin(lng * pi) + 40.0 *
    sin(lng / 3.0 * pi)) * 2.0 / 3.0;
  ret += (150.0 * sin(lng / 12.0 * pi) + 300.0 *
    sin(lng / 30.0 * pi)) * 2.0 / 3.0;
  return ret;
}

// 火星坐标系->百度坐标系
void gcj02_to_bd09_internal(double lng, double lat, double *x, double *y) {
    double z = sqrt(lng * lng + lat * lat) + 0.00002 * sin(lat * x_pi);
    double theta = atan2(lat, lng) + 0.000003 * cos(lng * x_pi);
    *x = z * cos(theta) + 0.0065;
    *y = z * sin(theta) + 0.006;
}		

// 百度坐标系->火星坐标系
void bd09_to_gcj02_internal(double lng, double lat, double *x, double *y) {
    double _x = lng - 0.0065;
    double _y = lat - 0.006;
    double z = sqrt(_x * _x + _y * _y) - 0.00002 * sin(_y * x_pi);
    double theta = atan2(_y, _x) - 0.000003 * cos(_x * x_pi);
    *x = z * cos(theta);
    *y = z * sin(theta);
}	


// WGS84坐标系->火星坐标系
void wgs84_to_gcj02_internal(double lng, double lat, double *x, double *y){
  double dlat = transformlat(lng - 105.0, lat - 35.0);
  double dlng = transformlng(lng - 105.0, lat - 35.0);
  double radlat = lat / 180.0 * pi ;
  double magic = sin(radlat) ;
  magic = 1 - ee * magic * magic;
  double sqrtmagic = sqrt(magic);
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi);
  dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi);
  *y = lat + dlat;
  *x = lng + dlng;
}		

// 火星坐标系->WGS84坐标系
void gcj02_to_wgs84_internal(double lng, double lat, double *x, double *y){
  double dlat = transformlat(lng - 105.0, lat - 35.0);
  double dlng = transformlng(lng - 105.0, lat - 35.0);
  double radlat = lat / 180.0 * pi;
  double magic = sin(radlat);
  magic = 1 - ee * magic * magic;
  double sqrtmagic = sqrt(magic) ;
  dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi) ;
  dlng = (dlng * 180.0) / (a / sqrtmagic * cos(radlat) * pi);
  double mglat = lat + dlat;
  double mglng = lng + dlng;
  *x = lng * 2 - mglng;
  *y = lat * 2 - mglat;
}	


// 百度坐标系->WGS84坐标系
void bd09_to_wgs84_internal(double lng, double lat, double *x, double *y){
  double _x, _y;
  bd09_to_gcj02_internal(lng,lat,&_x,&_y);
  gcj02_to_wgs84_internal(_x,_y,x,y);
}		


// WGS84坐标系->百度坐标系
void wgs84_to_bd09_internal(double lng, double lat, double *x, double *y){
  double _x, _y;
  wgs84_to_gcj02_internal(lng, lat,&_x,&_y);
  gcj02_to_bd09_internal(_x,_y,x,y);
} 		


int lwgeom_mars_convert(LWGEOM *geom, coord_convert convertor){
	uint32_t i;

	/* No points to transform in an empty! */
	if (lwgeom_is_empty(geom))
		return LW_SUCCESS;

	switch(geom->type)
	{
		case POINTTYPE:
		case LINETYPE:
		case CIRCSTRINGTYPE:
		case TRIANGLETYPE:
		{
			LWLINE *g = (LWLINE*)geom;
			if (!pointarray_mars_convert(g->points,convertor))
				return LW_FAILURE;
			break;
		}
		case POLYGONTYPE:
		{
			LWPOLY *g = (LWPOLY*)geom;
			for (i = 0; i < g->nrings; i++)
			{
				if (!pointarray_mars_convert(g->rings[i],convertor))
					return LW_FAILURE;
			}
			break;
		}
		case MULTIPOINTTYPE:
		case MULTILINETYPE:
		case MULTIPOLYGONTYPE:
		case COLLECTIONTYPE:
		case COMPOUNDTYPE:
		case CURVEPOLYTYPE:
		case MULTICURVETYPE:
		case MULTISURFACETYPE:
		case POLYHEDRALSURFACETYPE:
		case TINTYPE:
		{
			LWCOLLECTION *g = (LWCOLLECTION*)geom;
			for (i = 0; i < g->ngeoms; i++)
			{
				if (!lwgeom_mars_convert(g->geoms[i],convertor))
					return LW_FAILURE;
			}
			break;
		}
		default:
		{
			lwerror("gcj02_to_bd09: Cannot handle type '%s'",
			          lwtype_name(geom->type));
			return LW_FAILURE;
		}
	}
	return LW_SUCCESS;  
}

int lwgeom_gcj02_to_bd09(LWGEOM *geom)
{
	return lwgeom_mars_convert(geom,gcj02_to_bd09_internal);
}

int lwgeom_bd09_to_gcj02(LWGEOM *geom){
  return lwgeom_mars_convert(geom,bd09_to_gcj02_internal);
}

int lwgeom_wgs84_to_gcj02(LWGEOM *geom)
{
	return lwgeom_mars_convert(geom,wgs84_to_gcj02_internal);
}

int lwgeom_gcj02_to_wgs84(LWGEOM *geom){
  return lwgeom_mars_convert(geom,gcj02_to_wgs84_internal);
}

int lwgeom_bd09_to_wgs84(LWGEOM *geom)
{
	return lwgeom_mars_convert(geom,bd09_to_wgs84_internal);
}

int lwgeom_wgs84_to_bd09(LWGEOM *geom){
  return lwgeom_mars_convert(geom,wgs84_to_bd09_internal);
}

int pointarray_mars_convert(POINTARRAY* pa, coord_convert convertor){
  uint32_t i;
	POINT4D p;

	for (i = 0; i < pa->npoints; i++)
	{
		getPoint4d_p(pa, i, &p);
		convertor(p.x, p.y, &(p.x),&(p.y)); 
    ptarray_set_point4d(pa, i, &p);
	}

	return LW_SUCCESS;
}

// int ptarray_gcj02_to_bd09(POINTARRAY *pa)
// {
// 	uint32_t i;
// 	POINT4D p;

// 	for (i = 0; i < pa->npoints; i++)
// 	{
// 		getPoint4d_p(pa, i, &p);
// 		gcj02_to_bd09_internal(p.x, p.y, &(p.x),&(p.y)); 
//     ptarray_set_point4d(pa, i, &p);
// 	}

// 	return LW_SUCCESS;
// }