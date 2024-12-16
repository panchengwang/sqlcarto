
set -e 

echo '安装编译工具'
sudo apt install -y build-essential cmake pkg-config unzip axel wget 
echo '安装支持库'
sudo apt install -y libossp-uuid-dev libjson-c-dev libxml2-dev libreadline-dev zlib1g-dev libgeotiff-dev libpng-dev libcgal-dev libcurl4 libcurl4-openssl-dev sqlite3 libsqlite3-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler libpcre3-dev libxml2-dev

i=`sed -n '/PGSQL/'p /etc/profile | wc -l`
if [ "$i" = '0' ]; then
  echo "" | sudo tee -a /etc/profile
  echo "export PGSQL=/usr/local/pgsql" | sudo tee -a /etc/profile
  echo "export PATH=\$PGSQL/bin:\$PATH" | sudo tee -a /etc/profile
  echo "export LD_LIBRARY_PATH=\$PGSQL/lib:\$LD_LIBRARY_PATH" | sudo tee -a /etc/profile
  echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:\$PGSQL/lib/pkgconfig" | sudo tee -a /etc/profile
  
fi

sh /etc/profile

echo '解压源码'
rm -rf postgresql proj geos gdal postgis sfcgal sqlcarto
tar zvxf ${PG_SRC}.tar.gz
mv ${PG_SRC} postgresql
tar zvxf ${HTTP_SRC}.tar.gz 
mv ${HTTP_SRC} postgresql/contrib/http
tar zvxf ${PROJ_SRC}.tar.gz
mv ${PROJ_SRC} proj
tar zvxf ${SFCGAL_SRC}.tar.gz
mv ${SFCGAL_SRC} sfcgal
tar jvxf ${GEOS_SRC}.tar.bz2
mv ${GEOS_SRC} geos
tar zvxf ${POSTGIS_SRC}.tar.gz
mv ${POSTGIS_SRC} postgis
tar zvxf ${GDAL_SRC}.tar.gz
mv ${GDAL_SRC} gdal
unzip ${SQLCARTO_SRC}.zip


CORE_NUM=1

echo '编译postgresql'
cd postgresql
./configure --prefix=$PGSQL --with-ossp-uuid
make -j $CORE_NUM        #并行编译时使用-j选项并执行并行数，否则直接使用make即可
sudo make install
cd contrib/uuid-ossp
make 
sudo make install
cd ../postgres_fdw
make 
sudo make install
cd ../http
# 为pgsql-http的Makefile打补丁
echo "ifdef USE_PGXS" >> Makefile
echo "PG_CONFIG = pg_config" >> Makefile
echo "PGXS := \$(shell \$(PG_CONFIG) --pgxs)" >> Makefile
echo "include \$(PGXS)" >> Makefile
echo "else" >> Makefile
echo "subdir = contrib/http" >> Makefile
echo "top_builddir = ../.." >> Makefile
echo "include \$(top_builddir)/src/Makefile.global" >> Makefile
echo "include \$(top_srcdir)/contrib/contrib-global.mk" >> Makefile
echo "endif" >> Makefile

sudo make install
cd ../../..

echo '编译proj4'
cd proj
mkdir build
cd build
# proj4源码的单元测试采用了googletest, 编译时需要联网下载googletest。但由于众所周知的原因，在某些地区并不能连上google下载需要的文件，因此需要指定BUILD_TESTING=OFF跳过测试环节
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
make -j $CORE_NUM
sudo make install
cd ../..

echo '编译sfcgal'
cd sfcgal
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release ..
make -j $CORE_NUM
sudo make install
cd ../..

echo '编译安装geos'
cd geos
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release ..
make -j $CORE_NUM
sudo make install
cd ../..

echo '编译安装gdal'
cd gdal
./configure PQ_CFLAGS="-I$PGSQL/include" PQ_LIBS="-L$PGSQL/lib -lpq" --prefix=$PGSQL --with-pg
make -j $CORE_NUM
sudo make install
cd ..

echo '编译安装postgis'
cd postgis
./configure --prefix=$PGSQL
make -j $CORE_NUM
sudo make install
cd ..


echo '编译sqlcarto'
cd sqlcarto
sh install.sh