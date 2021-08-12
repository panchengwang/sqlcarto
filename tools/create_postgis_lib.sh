#!/bin/bash

# The dynamic library postgis-x.x.so can not be linked by using option "-l",
# we created libpostgis.so(linux) or libpostgis.a(Mac) to support sqlcarto extension.


POSTGIS_SRC_PATH=../../../postgis

OS=`uname`

# macos 
if test ${OS} = 'Darwin' ; then
  ar rcs libpostgis.a ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi

# Linux
if test ${OS} = 'Linux' ; then
  gcc -shared -o libpostgis.so ${POSTGIS_SRC_PATH}/liblwgeom/*.o ${POSTGIS_SRC_PATH}/libpgcommon/*.o ${POSTGIS_SRC_PATH}/deps/ryu/*.o
fi


