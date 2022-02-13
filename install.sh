#!/bin/bash
# edit PG_SRC_PATH when needed
PG_SRC_PATH=~/software/sdb/postgresql

CONTRIB=${PG_SRC_PATH}/contrib

OS=`uname`
CUR_DIR=$(cd `dirname $0`; pwd)

VERSION=1.0
echo '重写postgis的拓扑创建函数createtopology'
EXTENSION_DIR=`pg_config --sharedir`/extension
CONTROL_FILE=$EXTENSION_DIR/postgis_topology.control
POSTGIS_VER=`grep 'default_version' $CONTROL_FILE | sed "s/.*'\(.*\)'/\1/g"`
SQL_FILE=${EXTENSION_DIR}/postgis_topology--${POSTGIS_VER}.sql
if [ ! -f ${SQL_FILE}.bak ]; then
  sudo cp $SQL_FILE ${SQL_FILE}.bak
fi
sudo cp -f ${SQL_FILE}.bak ${SQL_FILE}
sudo sh -c "cat ${CUR_DIR}/postgis_topology_patch.sql >> ${SQL_FILE}"



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
