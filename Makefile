POSTGIS_SRC_DIR=/home/pcwang/software/sdb/postgis-3.5.3
# contrib/sqlcarto/Makefile

MODULE_big = sqlcarto
OBJS = \
	bytea2cstring.o \
	china_trans.o \
	china_proj.o \
	canvas.o \
	email.o \
	symbol.o \
	sqlcarto.o \


#	symbol/symbol_parser.o \
#	symbol/fill.o \
#	symbol/line.o \
#	symbol/stroke.o

EXTENSION = sqlcarto
DATA = sqlcarto--0.1.sql
PGFILEDESC = ""

REGRESS = 
PG_CPPFLAGS += $(shell pkg-config --cflags mapengine_c) \
	$(shell pkg-config --cflags json-c) \
	-I$(POSTGIS_SRC_DIR)/liblwgeom -I$(POSTGIS_SRC_DIR)/libpgcommon -I/usr/local/pgsql/include/mapengine_c
# SHLIB_LINK += $(POSTGIS_SRC_DIR)/liblwgeom/.libs/liblwgeom.a $(POSTGIS_SRC_DIR)/libpgcommon/libpgcommon.a -lgeos_c -lproj
# SHLIB_LINK += $(shell pkg-config --libs mapengine_c) -L$(shell pg_config --libdir) -llwgeom
SHLIB_LINK +=  $(shell pkg-config --libs mapengine_c) \
	$(shell pkg-config --libs json-c) \
	-L$(PGSQL)/lib -lgeos_c -lproj -llwgeom


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
