/**
 *  此文件里面的代码没什么用
 *  仅仅是为了确保pangis.so能够链接到
 *    sfgcal、proj4、geos_c
 *  而编写的无聊代码
 *  不要删哦
 */
#include <geos_c.h>
#include <proj.h>
#include <SFCGAL/capi/sfcgal_c.h>
#include "ensure_libs.h"


void ensure_geos_c_api(){
  GEOSGeom_destroy(NULL);
}

void ensure_sfcgal_api(){
	sfcgal_geometry_is_valid(NULL);
}

void ensure_proj4_api(){
  proj_context_create();
}

