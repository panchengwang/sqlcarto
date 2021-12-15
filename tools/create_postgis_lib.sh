#!/bin/bash

# The dynamic library postgis-x.x.so can not be linked by using option "-l",
# we created libpostgis.so(linux) or libpostgis.a(Mac) to support sqlcarto extension.


POSTGIS_SRC_PATH=~/software/src/postgis

OS=`uname`

CUR_DIR=$(cd `dirname $0`; pwd)
mkdir $CUR_DIR/libs

# macos 
if test ${OS} = 'Darwin' ; then
  ar rcs $CUR_DIR/libs/libpostgis.a ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi

# Linux
if test ${OS} = 'Linux' ; then

  gcc -shared -o $CUR_DIR/libs/libpostgis.so ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi

ls -l $CUR_DIR/libs
