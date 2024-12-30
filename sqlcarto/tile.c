#include "sqlcarto.h"

#include "tile.h"



PG_FUNCTION_INFO_V1(longitude_to_tile_x);
PG_FUNCTION_INFO_V1(latitude_to_tile_y);
PG_FUNCTION_INFO_V1(tile_x_to_longitude);
PG_FUNCTION_INFO_V1(tile_y_to_latitude);

Datum
longitude_to_tile_x(PG_FUNCTION_ARGS){
	double longitude ;
	int z;

	longitude = PG_GETARG_FLOAT8(0);
	z = PG_GETARG_INT32(1);
	PG_RETURN_INT32(long2tilex(longitude,z));
}

Datum
latitude_to_tile_y(PG_FUNCTION_ARGS){
	double latitude ;
	int z;

	latitude = PG_GETARG_FLOAT8(0);
	z = PG_GETARG_INT32(1);
	PG_RETURN_INT32(lat2tiley(latitude,z));
}

Datum
tile_x_to_longitude(PG_FUNCTION_ARGS){
	int x;
	int z;

	x = PG_GETARG_INT32(0);
	z = PG_GETARG_INT32(1);
	PG_RETURN_FLOAT8(tilex2long(x,z));
}

Datum
tile_y_to_latitude(PG_FUNCTION_ARGS){
	int y;
	int z;

	y = PG_GETARG_INT32(0);
	z = PG_GETARG_INT32(1);
	PG_RETURN_FLOAT8(tiley2lat(y,z));
}






int long2tilex(double lon, int z) 
{ 
	return (int)(floor((lon + 180.0) / 360.0 * (1 << z))); 
}

int lat2tiley(double lat, int z)
{ 
  double latrad = lat * M_PI/180.0;
	return (int)(floor((1.0 - asinh(tan(latrad)) / M_PI) / 2.0 * (1 << z))); 
}

double tilex2long(int x, int z) 
{
	return x / (double)(1 << z) * 360.0 - 180;
}

double tiley2lat(int y, int z) 
{
	double n = M_PI - 2.0 * M_PI * y / (double)(1 << z);
	return 180.0 / M_PI * atan(0.5 * (exp(n) - exp(-n)));
}


typedef struct TILE{
	int x,y,z;
} TILE;




#define ASSERT_TILE_P_WKT(tile,p,wkt)				\
	if(*p != '\0'){																		\
		pfree(tile);														\
		elog(ERROR, "Invalid tile: %s",wkt);		\
		PG_RETURN_NULL();												\
	}

PG_FUNCTION_INFO_V1(tile_in);

Datum tile_in(PG_FUNCTION_ARGS){
	char *wkt1 = PG_GETARG_CSTRING(0);
	char *wkt2 = NULL;
	char *p = wkt1;
	TILE *tile;
	int len = strlen(wkt1);
	int i=0;
	wkt2 =(char*) malloc(len+1);

	memset(wkt2,0,len+1);
	while(*p != '\0'){
		if(!isspace(*p)){
			wkt2[i++] = *p;
		}
		p++;
	}

	tile = palloc(sizeof(TILE));
	memset((void*)tile,0,sizeof(TILE));
	if (sscanf(wkt2, "TILE(%d,%d,%d)", &(tile->x), &(tile->y),&(tile->z)) != 3){
		elog(ERROR,"Invalid tile: %s",wkt1);
		pfree(tile);
		free(wkt2);
		PG_RETURN_NULL();
	}

	free(wkt2);

	PG_RETURN_POINTER(tile);
}

PG_FUNCTION_INFO_V1(tile_out);
Datum tile_out(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
  char *wkt;

  wkt = psprintf("TILE(%d,%d,%d)", tile->x,tile->y,tile->z);
  PG_RETURN_CSTRING(wkt);
}

PG_FUNCTION_INFO_V1(tile_x);
Datum tile_x(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
  PG_RETURN_INT32(tile->x);
}


PG_FUNCTION_INFO_V1(tile_set_x);
Datum tile_set_x(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
	int32 x = PG_GETARG_INT32(1);
	TILE *tile2 = palloc(sizeof(TILE));
	memcpy(tile2,tile,sizeof(TILE));
	tile2->x = x;
  PG_RETURN_POINTER(tile2);
}


PG_FUNCTION_INFO_V1(tile_y);
Datum tile_y(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
  PG_RETURN_INT32(tile->y);
}


PG_FUNCTION_INFO_V1(tile_set_y);
Datum tile_set_y(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
	int32 y = PG_GETARG_INT32(1);
	TILE *tile2 = palloc(sizeof(TILE));
	memcpy(tile2,tile,sizeof(TILE));
	tile2->y = y;
  PG_RETURN_POINTER(tile2);
}


PG_FUNCTION_INFO_V1(tile_z);
Datum tile_z(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
  PG_RETURN_INT32(tile->z);
}

PG_FUNCTION_INFO_V1(tile_set_z);
Datum tile_set_z(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
	int32 z = PG_GETARG_INT32(1);
	TILE *tile2 = palloc(sizeof(TILE));
	memcpy(tile2,tile,sizeof(TILE));
	tile2->z = z;
  PG_RETURN_POINTER(tile2);
}

PG_FUNCTION_INFO_V1(tile_to_lonlat);
Datum tile_to_lonlat(PG_FUNCTION_ARGS){
	TILE *tile = (TILE *) PG_GETARG_POINTER(0);
	double lon,lat;
	LWPOINT *point;
	GSERIALIZED *result;

	lon = tilex2long(tile->x,tile->z);
	lat = tiley2lat(tile->y,tile->z);
	point = lwpoint_make2d(4326, lon, lat);

	result = geometry_serialize((LWGEOM *)point);
	PG_RETURN_POINTER(result);
}


PG_FUNCTION_INFO_V1(lonlat_to_tile);

Datum lonlat_to_tile(PG_FUNCTION_ARGS){
	GSERIALIZED* geom;
	LWPOINT *lwpoint;
	POINT4D pt;
	int srid;
	int x,y,z;
	TILE *tile;

	geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	z = PG_GETARG_INT32(1);

	if(geom == NULL){
		PG_RETURN_NULL();
	}
	if (gserialized_get_type(geom) != POINTTYPE){
		elog(ERROR,"geomety must be point");
		PG_FREE_IF_COPY(geom,0);
		PG_RETURN_NULL();
	}

	srid = gserialized_get_srid(geom);
	if(srid != 4326){
		PG_FREE_IF_COPY(geom, 0);
		elog(ERROR, "Input geometry's SRID must be 4326");
		PG_RETURN_NULL();
	}

	lwpoint = (LWPOINT*)lwgeom_from_gserialized(geom);
	getPoint4d_p(lwpoint->point, 0, &pt);
	x = long2tilex(pt.x,z);
	y = lat2tiley(pt.y,z);

	tile = palloc(sizeof(TILE));
	tile->x = x;
	tile->y = y;
	tile->z = z;

	PG_FREE_IF_COPY(geom, 0);
	PG_RETURN_POINTER(tile);
}