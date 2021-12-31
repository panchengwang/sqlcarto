## SQLCarto/PostGIS/PostgreSQL安装手册(Ubuntu)

----------

| 作者  | pcwang（麓山老将) |
| ------------- | ------------- |
| QQ   | 593723812  |
| EMail  | sqlcarto@163.com , sqlcarto@gmail.com |

----------

### 系统要求

硬件：cpu  >= 4核，内存 >= 8G, 硬盘 >128G  推荐 512G以上

操作系统：Ubuntu



### 约定

源码下载在/Users/<用户名>/software/sdb, 安装后的二进制包放在/usr/local/pgsql
```shell
export SDB_SRC=/home/pcwang/software/sdb
mkdir -p ${SDB_SRC}
export INSTALL_PATH=/usr/local/pgsql
```

### 环境变量设置
我们计划将数据库安装到/usr/local/pgsql。
修改/etc/profile，设置PATH、LD_LIBRARY_PATH环境变量。在此文件的最后加入两行:

```shell
export PATH=/usr/local/pgsql/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/pgsql/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/pgsql/lib/pkgconfig
```

### 工具安装
```shell
sudo apt install -y build-essential wget axel cmake libcgal-dev libxml2-dev libcurl4-openssl-dev libtiff-dev libreadline-dev libossp-uuid-dev libsqlite3-dev sqlite3 libprotobuf-dev protobuf-c-compiler libprotobuf-c-dev
```

### 下载源码
请根据你的具体情况修改版本号。
```shell
cd ${SDB_SRC}
wget -O json-c.zip -c https://codeload.github.com/json-c/json-c/zip/refs/heads/master
wget -c https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz
wget -O cgal-5.0.tar.gz -c https://codeload.github.com/CGAL/cgal/tar.gz/refs/tags/v5.0
wget -c https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz
wget -c https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.gz
wget -c https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz
wget -c http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
wget -c https://ftp.gnu.org/pub/gnu/gettext/gettext-0.21.tar.gz
wget -c https://cairographics.org/snapshots/cairo-1.17.4.tar.xz
wget -c https://ftp.postgresql.org/pub/source/v14.1/postgresql-14.1.tar.bz2 
wget -c https://download.osgeo.org/postgis/source/postgis-3.2.0.tar.gz
wget -c http://download.osgeo.org/geos/geos-3.10.1.tar.bz2
wget -c https://download.osgeo.org/proj/proj-8.2.0.tar.gz
wget -O sfcgal-1.3.8.tar.gz -c https://github.com/Oslandia/SFCGAL/archive/refs/tags/v1.3.8.tar.gz
wget --no-check-certificate -c http://download.osgeo.org/gdal/3.4.0/gdal-3.4.0.tar.gz
wget -O sqlcarto-0.0.tar.gz -c https://github.com/panchengwang/sqlcarto/archive/refs/tags/v0.0.tar.gz
```


### 编译安装

#### json-c
```shell
cd ${SDB_SRC}
unzip json-c.zip
cd json-c-master
mkdir build
cd build 
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} -DCMAKE_BUILD_TYPE=release ..
make
sudo make install 
```

#### boost
```shell
cd ${SDB_SRC}
tar zvxf boost_1_78_0.tar.gz
cd boost_1_78_0
./bootstrap.sh --prefix=${INSTALL_PATH}
./b2
sudo ./b2 install

```

#### cgal
sfcgal需要cgal支持。注意版本是5.0！
```shell
cd ${SDB_SRC}
tar zvxf cgal-5.0.tar.gz
cd cgal-5.0
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} ..
make
sudo make install

```

#### gmp
注意一定要加上--enable-cxx配置项！
```shell
cd ${SDB_SRC}
tar -xvJf gmp-6.2.1.tar.xz
cd gmp-6.2.1
./configure --prefix=${INSTALL_PATH} --enable-cxx
make
sudo make install
```

#### mpfr
```shell
cd ${SDB_SRC}
tar zvxf mpfr-4.1.0.tar.gz
cd mpfr-4.1.0
./configure --prefix=${INSTALL_PATH}
make
sudo make install
```



#### 编译SFCGAL
geos的高级空间分析功能（特别是3D空间分析）需要sfcgal支持。

```shell
cd ${SDB_SRC}
tar zvxf sfcgal-1.3.8.tar.gz
cd SFCGAL-1.3.8
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} ..
make 
sudo make install 
```



#### libxml2
postgis需要libxml2。
```shell
cd ${SDB_SRC}
tar zvxf libxml2-2.9.12.tar.gz
cd libxml2-2.9.12
./configure --prefix=${INSTALL_PATH}
make
sudo make install
```


#### 编译postgresql
基础数据库

```shell
cd ${SDB_SRC}
tar jvxf postgresql-14.1.tar.bz2
mv postgresql-14.1 postgresql
cd postgresql
./configure --prefix=${INSTALL_PATH} --with-uuid=e2fs
make 
sudo make install
cd contrib/uuid-ossp
make 
sudo make install
cd ../..
cd contrib/pgcrypto
make 
sudo make install
cd ../..
cd contrib/dblink
make
sudo make install
cd ../..
cd contrib/postgres_fdw
make
sudo make install
cd ../..

```


#### sqlite3
proj4需要sqlite3支持，并且必须带上SQLITE_ENABLE_COLUMN_METADATA=1参数。

```shell
cd ${SDB_SRC}
tar zvxf sqlite-autoconf-3370000.tar.gz
mv sqlite-autoconf-3370000 sqlite
cd sqlite 
CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1" ./configure --prefix=${INSTALL_PATH}
make 
sudo make install

```


#### 编译proj4
postgis的投影变换功能需要proj4。

```shell
cd ${SDB_SRC}
tar zvxf proj-8.2.0.tar.gz
mv proj-8.2.0 proj
cd proj
./configure --prefix=${INSTALL_PATH} 
make 
sudo make install
```

#### 编译geos
postgis的空间分析需要geos。

```shell
cd ${SDB_SRC}
tar -jvxf geos-3.10.1.tar.bz2
mv geos-3.10.1 geos
cd geos
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} ..
make 
sudo make install

```



#### 编译gdal
postgis的raster模块必须gdal支持。

```shell
cd ${SDB_SRC}
tar zvxf gdal-3.4.0.tar.gz
mv gdal-3.4.0 gdal
cd gdal

./configure --prefix=${INSTALL_PATH} --with-pg=yes  PQ_CFLAGS="-I${INSTALL_PATH}/include" PQ_LIBS="-L${INSTALL_PATH}/lib -lpq" --with-libjson-c=${INSTALL_PATH} --with-sqlite3=${INSTALL_PATH} --with-proj=${INSTALL_PATH} --with-sfcgal=${INSTALL_PATH}/bin/sfcgal-config --with-geos=${INSTALL_PATH}/bin/geos-config   
make -j 8
sudo make install 

```

#### gettext
```shell
cd ${SDB_SRC}
tar zvxf gettext-0.21.tar.gz
cd gettext-0.21
./configure --prefix=${INSTALL_PATH}
make -j 8
sudo make install
```

#### 编译postgis
```shell
cd ${SDB_SRC}
tar zvxf postgis-3.2.0.tar.gz
mv postgis-3.2.0 postgis
cd postgis
./configure --prefix=${INSTALL_PATH} --with-sfcgal
make
sudo make install

```