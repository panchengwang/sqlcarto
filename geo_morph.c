#include "geo_morph.h"
#include <geos_c.h>
#include <SFCGAL/capi/sfcgal_c.h>


PG_FUNCTION_INFO_V1(has_spines);
Datum has_spines(PG_FUNCTION_ARGS){
  GSERIALIZED* geom;
  LWGEOM* lwgeom;
  double angle_tolerance = 5.0;
  int hasspines = LW_FAILURE;

  geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}
  if(PG_NARGS() == 2){
    angle_tolerance = PG_GETARG_FLOAT8(1);
  }
  lwgeom = lwgeom_from_gserialized(geom);
  hasspines = lwgeom_has_spines(lwgeom,angle_tolerance);
  lwgeom_free(lwgeom);
  PG_FREE_IF_COPY(geom,0);
  if( LW_SUCCESS == hasspines){
    PG_RETURN_BOOL(true);
  }
  PG_RETURN_BOOL(false);
}

int lwgeom_has_spines(LWGEOM* geom, double angle_tolerance){
  uint32_t i;

	/* No points to transform in an empty! */
	if (lwgeom_is_empty(geom))
		return LW_FAILURE;

	switch(geom->type)
	{
		case LINETYPE:
		{
			LWLINE *g = (LWLINE*)geom;
			if (pointarray_has_spines(g->points,angle_tolerance,0) == LW_SUCCESS)
				return LW_SUCCESS;
			break;
		}
		case POLYGONTYPE:
		{
			LWPOLY *g = (LWPOLY*)geom;
			for (i = 0; i < g->nrings; i++)
			{
				if (pointarray_has_spines(g->rings[i],angle_tolerance,1) == LW_SUCCESS)
					return LW_SUCCESS;
			}
			break;
		}
		case MULTILINETYPE:
		case MULTIPOLYGONTYPE:
		{
			LWCOLLECTION *g = (LWCOLLECTION*)geom;
			for (i = 0; i < g->ngeoms; i++)
			{
				if (LW_SUCCESS == lwgeom_has_spines(g->geoms[i],angle_tolerance))
					return LW_SUCCESS;
			}
			break;
		}
		default:
		{
			elog(ERROR,"Cannot handle type '%s'",
			          lwtype_name(geom->type));
			return LW_FAILURE;
		}
	}
	return LW_FAILURE;    
}









PG_FUNCTION_INFO_V1(remove_spines);

Datum remove_spines(PG_FUNCTION_ARGS){
  GSERIALIZED* geom;
	GSERIALIZED* result=NULL;
	LWGEOM* lwgeom;
  double angle_tolerance = 5.0;

  geom = PG_GETARG_GSERIALIZED_P_COPY(0);
	if(geom == NULL){
		PG_RETURN_NULL();
	}

  if(PG_NARGS() == 2){
    angle_tolerance = PG_GETARG_FLOAT8(1);
  }

  lwgeom = lwgeom_from_gserialized(geom);
  if( LW_SUCCESS !=lwgeom_remove_spines(lwgeom,angle_tolerance)){
    lwgeom_free(lwgeom);
    PG_FREE_IF_COPY(geom,0);
    PG_RETURN_NULL();
  }

  if ( lwgeom->bbox )
	{
		lwgeom_refresh_bbox(lwgeom);
	}

	result = geometry_serialize(lwgeom);
	lwgeom_free(lwgeom);

  PG_FREE_IF_COPY(geom,0);
  PG_RETURN_POINTER(result);
};

int lwgeom_remove_spines(LWGEOM* geom,double angle_tolerance){
  uint32_t i;

	/* No points to transform in an empty! */
	if (lwgeom_is_empty(geom))
		return LW_SUCCESS;

	switch(geom->type)
	{
		case LINETYPE:
		{
			LWLINE *g = (LWLINE*)geom;
			if (!pointarray_remove_spines(g->points,angle_tolerance,0))
				return LW_FAILURE;
			break;
		}
		case POLYGONTYPE:
		{
			LWPOLY *g = (LWPOLY*)geom;
			for (i = 0; i < g->nrings; i++)
			{
				if (!pointarray_remove_spines(g->rings[i],angle_tolerance,1))
					return LW_FAILURE;
			}
			break;
		}
		case MULTILINETYPE:
		case MULTIPOLYGONTYPE:
		{
			LWCOLLECTION *g = (LWCOLLECTION*)geom;
			for (i = 0; i < g->ngeoms; i++)
			{
				if (!lwgeom_remove_spines(g->geoms[i],angle_tolerance))
					return LW_FAILURE;
			}
			break;
		}
		default:
		{
			elog(ERROR,"Cannot handle type '%s'",
			          lwtype_name(geom->type));
			return LW_FAILURE;
		}
	}
	return LW_SUCCESS;  
}

static double distance_of(double x1,double y1, double x2,double y2){
  return sqrt( (x1-x2) * (x1-x2) + (y1-y2) * (y1-y2));
}

static double angle_of(POINT4D p1, POINT4D p2, POINT4D p3){
  double a,b,c;
  double angle;
  a = distance_of(p1.x,p1.y,p3.x,p3.y);
  b = distance_of(p2.x,p2.y,p3.x,p3.y);
  c = distance_of(p1.x,p1.y,p2.x,p2.y);
  angle = acos(( b*b + c*c - a*a) / (2.0*b*c));
  return angle;
}

int pointarray_has_spines(POINTARRAY* pa, double angle_tolerance, int isring){
  uint32_t i;
  POINT4D p1,p2,p3;
  double a,b,c;
  double angle;

  if(pa->npoints <= 4){
    return LW_FAILURE;
  }

  for(i=1;i<=pa->npoints-2; i++){
    getPoint4d_p(pa, i-1, &p1);
    getPoint4d_p(pa, i, &p2);
    getPoint4d_p(pa, i+1, &p3);
    angle = angle_of(p1,p2,p3);
    if(angle < angle_tolerance * M_PI/180.0){
      return LW_SUCCESS;
    }
  }

	if ( isring == 1) {
		getPoint4d_p(pa,pa->npoints-2,&p1);
    getPoint4d_p(pa,0);
    getPoint4d_p(pa,1);
    angle = angle_of(p1,p2,p3);
    if(angle < angle_tolerance * M_PI/180.0){
      return LW_SUCCESS;
    }
	}
  return LW_FAILURE;
}

int pointarray_remove_spines(POINTARRAY* pa, double angle_tolerance, int isring){
  uint32_t i;
	POINT4D p1,p2,p3;
  int hasspines = 1;
  double a,b,c;
  double angle;

  if(pa->npoints <= 3){
    return LW_SUCCESS;
  }

  i = 0;
	while(hasspines){
		getPoint4d_p(pa, i, &p1);
    getPoint4d_p(pa, i+1, &p2);
    getPoint4d_p(pa, i+2, &p3);

    a = distance_of(p1.x,p1.y,p3.x,p3.y);
    b = distance_of(p2.x,p2.y,p3.x,p3.y);
    c = distance_of(p1.x,p1.y,p2.x,p2.y);
    angle = acos(( b*b + c*c - a*a) / (2.0*b*c));
    if(angle < angle_tolerance * M_PI/180.0){
      ptarray_remove_point(pa,i+1);
      if(pa->npoints <= 3){
        return LW_SUCCESS;
      }
      i = 0;
      hasspines = 1;
      continue;
    }
    i++;
    if( i == pa->npoints-2){
      hasspines = 0;
    }
	}

	return LW_SUCCESS;
}


