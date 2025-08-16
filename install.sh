#!/bin/sh

CUR_DIR=$(cd `dirname $0`; pwd)
PG_SRC_DIR=~/software/sdb/postgresql-17.0
POSTGIS_SRC_DIR=~/software/sdb/postgis-3.5.3

sh combine_sql.sh

echo "POSTGIS_SRC_DIR=${POSTGIS_SRC_DIR}" > ${CUR_DIR}/Makefile
cat ${CUR_DIR}/Makefile.in >> ${CUR_DIR}/Makefile

rsync -av --exclude='.*' ${CUR_DIR} ${PG_SRC_DIR}/contrib
# cp ${CUR_DIR} ${PG_SRC_DIR}/contrib -r
cd ${PG_SRC_DIR}/contrib/sqlcarto
make 
sudo make install



