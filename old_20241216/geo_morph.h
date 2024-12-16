#ifndef __GEO_MORPH_H
#define __GEO_MORPH_H


#include "sqlcarto.h"

int lwgeom_has_spines(LWGEOM* geom, double angle_tolerance);
int lwgeom_remove_spines(LWGEOM* geom, double angle_tolerance);
int pointarray_remove_spines(POINTARRAY* pa, double angle_tolerance, int isring);
int pointarray_has_spines(POINTARRAY* pa, double angle_tolerance, int isring);

#endif
