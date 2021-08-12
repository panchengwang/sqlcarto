#!/bin/bash
OS=`uname`

PG_SRC_PATH=~/software/src/postgresql
CONTRIB=${PG_SRC_PATH}/contrib
rm -rf $CONTRIB/sqlcarto
cp -rf ../sqlcarto $CONTRIB/
cd $CONTRIB/sqlcarto
sh tools/create_postgis_lib.sh
INSTALL_PATH=$(dirname `which pg_config`)/..
if test ${OS} = 'Linux' ; then 
  sudo cp -f libs/libpostgis.* $INSTALL_PATH/lib
fi 
make 
sudo make install
