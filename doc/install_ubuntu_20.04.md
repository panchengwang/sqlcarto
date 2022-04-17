<link rel="stylesheet" type="text/css" href="title_number.css" />

# Ubuntu20.04操作系统下的PostGIS/PostgreSQL安装

## 编译工具安装
```shell
sudo apt install build-essential cmake pkg-config
```
检查一下cmake的版本。如果版本号小于3.11，则要升级到3.11以上。建议从cmake官网下载最新的cmake编译安装。
```shell
sudo apt libssl-dev
tar zvxf cmake-3.22.3.tar.gz
cd cmake-3.22.3
./configure --prefix=/usr
make
sudo make install
```

## 依赖库安装
```shell
sudo apt install libossp-uuid-dev libjson-c-dev libxml2-dev libreadline-dev zlib1g-dev libgeotiff-dev libpng-dev libcgal-dev libcurl4 libcurl4-openssl-dev sqlite3 libsqlite3-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler libpcre3-dev
```
如果出现下面的错误:
```shell
...
libcurl4-openssl-dev : Depends: libcurl4 (= 7.68.0-1ubuntu2.7) but 7.68.0-1ubuntu2.8 is to be installed
...
```
则可以执行下面的命令来解决这个问题:
```shell
sudo apt purge libcurl4
```

## 环境变量设置
修改/etc/profile，设置PATH、LD_LIBRARY_PATH环境变量。如计划将数据库安装到/usr/local/pgsql，则在此文件的最后加入:

```shell
export PGSQL=/usr/local/pgsql
export PATH=$PGSQL/bin:$PATH
export LD_LIBRARY_PATH=$PGSQL/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PGSQL/lib/pkgconfig
```

## 下载源码
去相关网站下载源码：sfcgal, gdal, proj4, geos, postgis, postgresql，将源码保存到~/software/src

## 安装postgresql
解压postgresql源码，进入postgresql源码目录，执行:
```shell
./configure --prefix=$PGSQL --with-ossp-uuid
make -j 16        #并行编译时使用-j选项并执行并行数，否则直接使用make即可
sudo make install
```
## 安装proj4
解压proj4源码，进入proj4源码目录，执行:
```shell
mkdir build
cd build
# proj4源码的单元测试采用了googletest, 编译时需要联网下载googletest。但由于众所周知的原因，在某些地区并不能连上google下载需要的文件，因此需要指定BUILD_TESTING=OFF跳过测试环节
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
make -j 16
sudo make install
```

## 安装sfcgal
解压sfcgal源码， 进入sfcgal源码目录，执行:
```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release ..
make -j 16
sudo make install
```

## 安装geos
解压geos源码， 进入geos源码目录，执行:
```shell
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PGSQL -DCMAKE_BUILD_TYPE=Release ..
make -j 16
sudo make install
```

## 安装gdal
解压gdal源码， 进入gdal源码目录，执行:
```shell
./configure PQ_CFLAGS="-I$PGSQL/include" PQ_LIBS="-L$PGSQL/lib -lpq" --prefix=$PGSQL --with-pg
make -j 16
sudo make install
```

## 安装postgis
解压postgis源码， 进入postgis源码目录，执行:
```shell
./configure --prefix=$PGSQL
make -j 16
sudo make install
```


## 将上面的安装代码放到一个脚本文件中
```
tar zvxf postgresql-14.2.tar.gz
mv postgresql-14.2.tar.gz postgresql
tar proj-8.2.
```

## 初始化数据库并启动数据库服务
```shell
PGDATA_PATH=~/database
mkdir $PGDATA_PATH
initdb -D $PGDATA_PATH -E utf8
pg_ctl -D $PGDATA_PATH start
```