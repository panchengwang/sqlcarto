#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

sh ${CUR_DIR}/sqlcarto/combine_sql.sh
POSTGIS_SRC_PATH=~/software/sdb/postgis-3.4.2

# 开发时，为提高编译安装效率，注释以下三行
cd ${POSTGIS_SRC_PATH}/../
rm ${POSTGIS_SRC_PATH} -rf
tar -zvxf ${POSTGIS_SRC_PATH}.tar.gz

cd ${CUR_DIR}
cp -rf -u * ${POSTGIS_SRC_PATH}

cd ${POSTGIS_SRC_PATH}
sh patch.sh

# 开发时，为提高编译安装效率，注释以下一行
./configure --prefix=${PGSQL} --without-protobuf

# make
make -j 32

# 下面5行仅仅在开发时使用
# cd ${POSTGIS_SRC_PATH}/extensions/postgis_sqlcarto
# make uninstall
# make clean
# make 
# make install


cd ${POSTGIS_SRC_PATH}

os=$(uname | cut -c 1-5)

if [ "$os" = "MINGW" ] ; then 
make install
else
sudo make install
fi
