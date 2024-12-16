#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

sh ${CUR_DIR}/sqlcarto/combine_sql.sh
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2



cd ${CUR_DIR}
cp -rf -u * ${POSTGIS_SRC_PATH}

cd ${POSTGIS_SRC_PATH}
sh patch_dev.sh


make



cd ${POSTGIS_SRC_PATH}

os=$(uname | cut -c 1-5)

if [ "$os" = "MINGW" ] ; then 
make install
else
sudo make install
fi
