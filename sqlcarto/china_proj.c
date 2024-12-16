/******************************************************************************
  contrib/sqlcarto/china_proj.c
	
******************************************************************************/

#include "sqlcarto.h"

#include "china_trans.h"



/*
** Input/Output routines
*/
PG_FUNCTION_INFO_V1(gcj02_to_bd09); 		// 火星坐标系->百度坐标系
PG_FUNCTION_INFO_V1(bd09_to_gcj02); 		// 百度坐标系->火星坐标系
PG_FUNCTION_INFO_V1(wgs84_to_gcj02); 		// WGS84坐标系->火星坐标系
PG_FUNCTION_INFO_V1(gcj02_to_wgs84); 		// 火星坐标系->WGS84坐标系
PG_FUNCTION_INFO_V1(bd09_to_wgs84);			// 百度坐标系->WGS84坐标系
PG_FUNCTION_INFO_V1(wgs84_to_bd09); 		// WGS84坐标系->百度坐标系


Datum 
gcj02_to_bd09(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_gcj02_to_bd09(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}

Datum 
bd09_to_gcj02(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_bd09_to_gcj02(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}

Datum 
wgs84_to_gcj02(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_wgs84_to_gcj02(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}

Datum 
gcj02_to_wgs84(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_gcj02_to_wgs84(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}

Datum 
bd09_to_wgs84(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_bd09_to_wgs84(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}


Datum 
wgs84_to_bd09(PG_FUNCTION_ARGS)
{
	GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
	int srid;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "gcj02_to_bd09: Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwgeom = lwgeom_from_gserialized(geom);
	
	lwgeom_wgs84_to_bd09(lwgeom);

	if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);
	PG_FREE_IF_COPY(geom, 0);
 	PG_RETURN_POINTER(result);
}
