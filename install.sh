#!/bin/bash
# edit PG_SRC_PATH when needed
PG_SRC_PATH=~/software/sdb/postgresql

CONTRIB=${PG_SRC_PATH}/contrib

OS=`uname`
CUR_DIR=$(cd `dirname $0`; pwd)

VERSION=1.0
echo '重写postgis的拓扑创建函数createtopology'



cat $CUR_DIR/sqlcarto.sql > sqlcarto--${VERSION}.sql
cat $CUR_DIR/china_proj.sql >> sqlcarto--${VERSION}.sql 
cat $CUR_DIR/projection.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/tile.sql >> sqlcarto--${VERSION}.sql 
cat $CUR_DIR/geo_morph.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/postgis_ext.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/grid.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/pg_utils.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/topology.sql >> sqlcarto--${VERSION}.sql
cat $CUR_DIR/webmaps.sql >> sqlcarto--${VERSION}.sql


rm -rf $CONTRIB/sqlcarto
cp -rf ../sqlcarto $CONTRIB/
cd $CONTRIB/sqlcarto
sh build_tools/create_postgis_lib.sh
INSTALL_PATH=$(dirname `which pg_config`)/..
if test ${OS} = 'Linux' ; then 
  sudo cp -f $CONTRIB/sqlcarto/build_tools/libs/libpostgis.* $INSTALL_PATH/lib
fi 
make 
sudo make install


make -C tools
