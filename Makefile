# contrib/sqlcarto/Makefile

MODULE_big = sqlcarto
OBJS = \
	ensure_libs.o \
	china_trans.o \
	china_proj.o \
	geo_morph.o 

EXTENSION = sqlcarto
DATA = sqlcarto--1.0.sql

EXTRA_CLEAN = tools/libs/*.a tools/libs/libpostgis.so

HEADERS =

REGRESS =

POSTGIS_PATH = ../../../postgis
PG_CPPFLAGS = \
	-DPIC \
	-I$(POSTGIS_PATH) \
	-I$(POSTGIS_PATH)/libpgcommon \
	-I$(POSTGIS_PATH)/liblwgeom \
	-I../../src/backend \
	-I$(shell pg_config --includedir) \
	$(shell sfcgal-config --cflags) \
	$(shell geos-config --cflags)

ifeq ($(shell uname),Darwin)
	SHLIB_LINK_F = \
		-L$(shell pg_config --libdir) \
		-lgeos_c \
		$(shell sfcgal-config --libs) \
		$(shell gdal-config --libs) \
		-lproj \
		./tools/libs/libpostgis.a
endif
ifeq ($(shell uname),Linux)
		SHLIB_LINK_F = \
		-L$(shell pg_config --libdir) \
		-lgeos_c \
		$(shell sfcgal-config --libs) \
		$(shell gdal-config --libs) \
		-lproj \
		-lpostgis 
endif

SHLIB_LINK := $(SHLIB_LINK_F) $(SHLIB_LINK)



ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/sqlcarto
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif



distprep:

maintainer-clean:


test:
	echo $(SHLIB_LINK_F)
