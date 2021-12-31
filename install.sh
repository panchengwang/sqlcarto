#!/bin/bash

PG_SRC_PATH=~/software/sdb/postgresql
CONTRIB=${PG_SRC_PATH}/contrib

OS=`uname`
CUR_DIR=$(cd `dirname $0`; pwd)
cat $CUR_DIR/sqlcarto.sql > sqlcarto--1.0.sql
cat $CUR_DIR/china_proj.sql >> sqlcarto--1.0.sql 
cat $CUR_DIR/tile.sql >> sqlcarto--1.0.sql 
cat $CUR_DIR/geo_morph.sql >> sqlcarto--1.0.sql
cat $CUR_DIR/postgis_ext.sql >> sqlcarto--1.0.sql

rm -rf $CONTRIB/sqlcarto
cp -rf ../sqlcarto $CONTRIB/
cd $CONTRIB/sqlcarto
sh tools/create_postgis_lib.sh
INSTALL_PATH=$(dirname `which pg_config`)/..
if test ${OS} = 'Linux' ; then 
  sudo cp -f $CONTRIB/sqlcarto/tools/libs/libpostgis.* $INSTALL_PATH/lib
fi 
make 
sudo make install
