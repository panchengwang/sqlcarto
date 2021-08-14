#!/bin/bash
OS=`uname`
CUR_DIR=$(cd `dirname $0`; pwd)
cat $CUR_DIR/sqlcarto.sql > sqlcarto--1.0.sql
cat $CUR_DIR/china_proj.sql >> sqlcarto--1.0.sql 
cat $CUR_DIR/tile.sql >> sqlcarto--1.0.sql 
cat $CUR_DIR/geo_morph.sql >> sqlcarto--1.0.sql

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
