#!/bin/bash

set -e 

echo "======================================="
echo "==  开源空间数据库Compile and install 安装脚本              "
echo "==  作者：pcwang                      "
echo "==  QQ： 593723812                    "
echo "======================================="
echo "==  用法："
echo "==    bash $0 [speedup]"
echo "==      speedup表示是否加速"
echo "==      加速有两个作用："
echo "==        1 download 加速"
echo "==        2 Compile and install 加速"

OS=`uname`

# 下面的参数，请根据自己的实际情况作出修改
# 源码目录
SOURCE_PATH=~/software/src
mkdir -p ${SOURCE_PATH}
# 安装目录
INSTALL_PATH=/usr/local/pgsql
sudo mkdir -p /usr/local/pgsql
export PATH=$INSTALL_PATH/bin:$INSTALL_PATH/lib:$PATH
if test ${OS} = 'Linux' ; then
  export LD_LIBRARY_PATH=$INSTALL_PATH/lib:$LD_LIBRARY_PATH
fi

if test ${OS} = 'Darwin' ; then
  export DYLD_LIBRARY_PATH=$INSTALL_PATH/lib:$DYLD_LIBRARY_PATH
fi

# 安装是否加速
SPEED_UP=0
if [ $# -ge 1 ] && [ $1 == "speedup" ]; then
  SPEED_UP=1
fi




echo "==  安装依赖 ........ "
# if test ${OS} = 'Darwin' ; then 
#   brew install axel wget cmake cgal gettext boost readline protobuf-c
# fi

if test ${OS} = 'Linux' ; then 
  source /etc/os-release
  case $ID in
    debian|ubuntu|devuan)
      sudo apt install -y build-essential wget axel cmake libcgal-dev libxml2-dev libcurl4-openssl-dev libtiff-dev libreadline-dev libossp-uuid-dev libsqlite3-dev sqlite3 libprotobuf-dev protobuf-c-compiler libprotobuf-c-dev
      ;;
    centos)
      yumdnf="yum"
      # if test "$(echo "$VERSION_ID >= 22" | bc)" -ne 0; then
      #     yumdnf="dnf"
      # fi
      sudo $yumdnf install -y epel-release
      sudo $yumdnf install -y snapd
      # sudo setenforce 0
      sudo systemctl enable --now snapd.socket
      sudo unlink /snap
      sudo ln -s /var/lib/snapd/snap /snap
      export PATH=/snap/bin:$PATH
      sudo snap install  axel 
      # 安装支持库
      sudo $yumdnf install -y cmake gmp-devel mpfr-devel boost boost-devel \
        mesa-libGL-devel mesa-libGLU-devel libxml2-devel openssl openssl-devel \
        libtiff-devel readline-devel libuuid-devel \
        glibc-headers \
        sqlite sqlite-devel \
        protobuf protobuf-c protobuf-c-compiler protobuf-c-devel protobuf-compiler \
        curl libcurl libcurl-devel \
        autoconf automake gcc gcc-c++ kernel-devel \
        gettext gettext-devel libuuid-devel uuid

      # centos8 软件库里的uuid, uuid-devel不能很好地支持postgresql的扩展模块，下载源码自行编译安装uuid
      wget -c https://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz
      # 经测试，sfcgal只能在较低版本的cgal上编译，这里采用5.0.4的cgal版本
      wget -c -O ${SOURCE_PATH}/cgal-5.0.4.tar.gz https://codeload.github.com/CGAL/cgal/tar.gz/refs/tags/v5.0.4
      
      cd ${SOURCE_PATH}
      rm -rf uuid-1.6.2
      tar zvxf uuid-1.6.2.tar.gz
      cd uuid-1.6.2
      ./configure --prefix=/usr
      make
      sudo make install

      cd ${SOURCE_PATH}
      rm -rf cgal-5.0.4
      tar zvxf cgal-5.0.4.tar.gz 
      cd cgal-5.0.4
      mkdir build
      cd build
      cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..
      sudo make install


      ;;
    *)
      exit 1
      ;;
  esac
  # sudo apt install -y axel cmake libcgal-dev libxml2-dev libcurl4-openssl-dev libtiff-dev libreadline-dev libossp-uuid-dev libsqlite3-dev sqlite3 libprotobuf-dev protobuf-c-compiler
  # sudo apt install -y libprotobuf-c-dev
fi


echo "== 设置PATH、LD_LIBRARY_PATH环境变量 ......."

PATH_LINE=`grep -e "${INSTALL_PATH}/bin" /etc/profile`

if [ -z "${PATH_LINE}" ]; then 
  echo "export PATH=${INSTALL_PATH}/bin:$PATH" | sudo tee -a  /etc/profile

  if [ "${OS}" == 'Darwin' ]; then
    echo "export DYLD_LIBRARY_PATH=${INSTALL_PATH}/lib:$DYLD_LIBRARY_PATH" | sudo tee -a /etc/profile
  fi

  if [ "${OS}" == 'Linux' ]; then
    echo "export LD_LIBRARY_PATH=${INSTALL_PATH}/lib:${INSTALL_PATH}/lib64:$LD_LIBRARY_PATH" | sudo tee -a /etc/profile
  fi
  source /etc/profile
fi



echo ""
echo "=========== download 源码 ==========="
# 具体使用时请根据需要改变
PG_VERSION=13.3
PROJ_VERSION=8.1.0
POSTGIS_VERSION=3.1.3
GEOS_VERSION=3.9.1
GDAL_VERSION=3.3.1
SFCGAL_VERSION=1.3.8
GETTEXT_VERSION=0.21
# 由于众所周知的原因，有些时候域名解析器不能很好的解析ftp.postgresql.org
# PG_URL=https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz
# 因此采用IP直接下载，87.238.57.227没有采用经过认证的证书，只能使用http协议
PG_URL=http://87.238.57.227/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz
PROJ_URL=https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz
POSTGIS_URL=https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz
GEOS_URL=http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2
SFCGAL_URL=https://gitlab.com/Oslandia/SFCGAL/-/archive/v${SFCGAL_VERSION}/SFCGAL-v${SFCGAL_VERSION}.tar.gz
GDAL_URL=http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
GETTEXT_URL=https://ftp.gnu.org/pub/gnu/gettext/gettext-${GETTEXT_VERSION}.tar.gz

DOWNLOAD_SPEED=
if test ${SPEED_UP} = 1 ; then 
  DOWNLOAD_SPEED="-n 10"
  echo "==  正在使用download 加速"
fi

# download postgresql
PG_FILE=${SOURCE_PATH}/postgresql-${PG_VERSION}.tar.gz
# if [ ! -f ${PG_FILE} ] || [ -f ${PG_FILE}.st ] ; then
#   axel ${DOWNLOAD_SPEED} -o ${PG_FILE} ${PG_URL}
# fi
wget -c -O ${PG_FILE} ${PG_URL}
# download proj4
PROJ_FILE=${SOURCE_PATH}/proj-${PROJ_VERSION}.tar.gz
if [ ! -f ${PROJ_FILE} ] || [ -f ${PROJ_FILE}.st ] ; then
  axel ${DOWNLOAD_SPEED} -o ${PROJ_FILE} ${PROJ_URL}
fi
# download geos
GEOS_FILE=${SOURCE_PATH}/geos-${GEOS_VERSION}.tar.bz2
if [ ! -f ${GEOS_FILE} ] || [ -f ${GEOS_FILE}.st ] ; then
  axel ${DOWNLOAD_SPEED} -o ${GEOS_FILE} ${GEOS_URL}
fi
# download sfcgal
SFCGAL_FILE=${SOURCE_PATH}/SFCGAL-v${SFCGAL_VERSION}.tar.gz
if [ ! -f ${SFCGAL_FILE} ] || [ -f ${SFCGAL_FILE}.st ] ; then
  axel ${DOWNLOAD_SPEED} -o ${SFCGAL_FILE} ${SFCGAL_URL}
fi
# download gdal
GDAL_FILE=${SOURCE_PATH}/gdal-${GDAL_VERSION}.tar.gz
if [ ! -f ${GDAL_FILE} ] || [ -f ${GDAL_FILE}.st ] ; then
  axel ${DOWNLOAD_SPEED} -o ${GDAL_FILE} ${GDAL_URL}
fi
# download postgis
POSTGIS_FILE=${SOURCE_PATH}/postgis-${POSTGIS_VERSION}.tar.gz
if [ ! -f ${POSTGIS_FILE} ] || [ -f ${POSTGIS_FILE}.st ] ; then
  axel ${DOWNLOAD_SPEED} -o ${POSTGIS_FILE} ${POSTGIS_URL}
fi

if test ${OS} = 'Darwin' ; then
  # download gettext
  GETTEXT_FILE=${SOURCE_PATH}/gettext-${GETTEXT_VERSION}.tar.gz
  if [ ! -f ${GETTEXT_FILE} ] || [ -f ${GETTEXT_FILE}.st ] ; then
    axel ${DOWNLOAD_SPEED} -o ${GETTEXT_FILE} ${GETTEXT_URL}
  fi
fi



echo "==      finish donload sources , unzip .....    "
rm -rf ${SOURCE_PATH}/postgresql
tar -zvxf ${PG_FILE} -C ${SOURCE_PATH} 
mv ${SOURCE_PATH}/postgresql-${PG_VERSION} ${SOURCE_PATH}/postgresql

rm -rf ${SOURCE_PATH}/proj
tar -zvxf ${PROJ_FILE} -C ${SOURCE_PATH}
mv ${SOURCE_PATH}/proj-${PROJ_VERSION} ${SOURCE_PATH}/proj

rm -rf ${SOURCE_PATH}/postgis
tar -zvxf ${POSTGIS_FILE} -C ${SOURCE_PATH}
mv ${SOURCE_PATH}/postgis-${POSTGIS_VERSION} ${SOURCE_PATH}/postgis

rm -rf ${SOURCE_PATH}/geos
tar -jvxf ${GEOS_FILE} -C ${SOURCE_PATH}
mv ${SOURCE_PATH}/geos-${GEOS_VERSION} ${SOURCE_PATH}/geos

if test ${OS} = 'Linux' ; then
  rm -rf ${SOURCE_PATH}/sfcgal
  tar -zvxf ${SFCGAL_FILE} -C ${SOURCE_PATH}
  mv ${SOURCE_PATH}/SFCGAL-v${SFCGAL_VERSION} ${SOURCE_PATH}/sfcgal
fi

rm -rf ${SOURCE_PATH}/gdal
tar -zvxf ${GDAL_FILE} -C ${SOURCE_PATH}
mv ${SOURCE_PATH}/gdal-${GDAL_VERSION} ${SOURCE_PATH}/gdal

if test ${OS} = 'Darwin' ; then
  rm -rf ${SOURCE_PATH}/gettext
  tar -zvxf ${GETTEXT_FILE} -C ${SOURCE_PATH}
  mv ${SOURCE_PATH}/gettext-${GETTEXT_VERSION} ${SOURCE_PATH}/gettext
fi


if test ${OS} = 'Linux' ; then 
  CORENUM=`cat /proc/cpuinfo| grep "processor"| wc -l`
  NTHREADS=`expr 2 \* ${CORENUM}`
fi
if test ${OS} = 'Darwin' ; then 
  CORENUM=`sysctl -n machdep.cpu.core_count`
  NTHREADS=`expr 2 \* ${CORENUM}`
fi

COMPILESPEED=
if test ${SPEED_UP} = 1 ; then 
  COMPILESPEED="-j ${CORENUM}"
fi




echo "==      compile and install postgresql ....... "
cd ${SOURCE_PATH}/postgresql
UUID=ossp
if test ${OS} = 'Darwin' ; then
  UUID=e2fs
fi
./configure --prefix=${INSTALL_PATH} --with-uuid=${UUID}
make ${COMPILESPEED}
sudo make install
cd contrib/uuid-ossp
make 
sudo make install
cd ${SOURCE_PATH}/postgresql/contrib/pgcrypto
make 
sudo make install
cd ${SOURCE_PATH}/postgresql/contrib/dblink
make
sudo make install
cd ${SOURCE_PATH}/postgresql/contrib/postgres_fdw
make
sudo make install

# Compile and install proj4
cd ${SOURCE_PATH}/proj
./configure --prefix=${INSTALL_PATH}
make ${COMPILESPEED}
sudo make install

# Compile and install sfcgal
# There is some error when sfcgal is compiled on MacOS.
# So we  use sfcgal provied by "brew install sfcgal".
if test ${OS} = 'Linux' ; then 
  cd ${SOURCE_PATH}/sfcgal
  mkdir build
  cd build
  cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} ..
  make ${COMPILESPEED}
  sudo make install
fi

# Compile and install geos
cd ${SOURCE_PATH}/geos
./configure --prefix=${INSTALL_PATH} 
make ${COMPILESPEED}
sudo make install

# Compile and install gdal
GEOS_CONFIG=${INSTALL_PATH}/bin/geos-config
SFCGAL_CONFIG=${INSTALL_PATH}/bin/sfcgal-config
if test ${OS} = 'Darwin' ; then 
  SFCGAL_CONFIG=yes
fi
cd ${SOURCE_PATH}/gdal
./configure --prefix=${INSTALL_PATH} \
  --with-proj=${INSTALL_PATH} \
  --with-sfcgal=${SFCGAL_CONFIG} \
  --with-geos=${GEOS_CONFIG} \
  --with-pg=yes \
  PQ_CFLAGS="-I${INSTALL_PATH}/include" \
  PQ_LIBS="-L${INSTALL_PATH}/lib -lpq"

make ${COMPILESPEED}
sudo make install

# Compile and install gettext
if test ${OS} = 'Darwin' ; then 
  cd ${SOURCE_PATH}/gettext
  ./configure --prefix=${INSTALL_PATH} 
  make ${COMPILESPEED}
  sudo make install
fi


# Compile and install postgis
cd ${SOURCE_PATH}/postgis
./configure --prefix=${INSTALL_PATH} --with-projdir=${INSTALL_PATH} --with-sfcgal
make ${COMPILESPEED}
sudo make install

