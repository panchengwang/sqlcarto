## PostGIS/PostgreSQL安装手册(CentOS 7.x)


----------

| 作者  | 王盼成 |
| ------------- | ------------- |
| QQ   | 593723812  |
| EMail  | wang_wang_lao@163.com  |

----------

### 系统要求

硬件：cpu  >= 8核，硬盘 >128G  推荐 512G以上

操作系统：Linux, 推荐centos 7 以上

### 数据库用户

本文档假设你使用的服务器有一个专门用来管理数据库的用户，其名字为postgres。你可以根据具体情况决定你的用户名。
转到root用户，执行以下命令：

```shell
adduser postgres
passwd postgres
```
修改/etc/sudoers，使得postgres能以root权限执行命令, 并且在安装时无需输入密码:
```shell
vi /etc/sudoers

## Allow root to run any commands anywhere
root      ALL=(ALL)       ALL
postgres  ALL=(ALL)       NOPASSWD:ALL

```


### 依赖包安装
下面的命令请使用管理员用户运行：

```shell
yum install -y cmake3 gmp-devel mpfr-devel uuid uuid-devel mesa-libGL-devel mesa-libGLU-devel libxml2-devel openssl openssl-devel  libtiff-devel readline-devel libuuid-devel glibc-headers  curl libcurl libcurl-devel autoconf automake gcc gcc-c++ kernel-devel gettext gettext-devel bzip2
```

cgal需要cmake3的支持：

```shell
ln -s /usr/bin/cmake3 /usr/bin/cmake
```

gcc、g++ 升级到9

centos 7.4缺省用的gcc版本是4.8，版本太低，不支持c++17标准，会导致sfcgal编译不通过，因此需要升级

```shell
yum install -y centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
```

退出系统，重新登录。


### 源码下载

```shell
su postgres
cd ~
mkdir -p software/src
cd software/src
wget --no-check-certificate -c https://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz
wget --no-check-certificate -c  https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz
wget -O cgal-5.0.4.tar.gz -c  https://codeload.github.com/CGAL/cgal/tar.gz/refs/tags/v5.0.4
wget -c http://87.238.57.227/pub/source/v13.3/postgresql-13.3.tar.gz
wget --no-check-certificate -c https://download.osgeo.org/proj/proj-8.1.0.tar.gz
wget --no-check-certificate -c https://download.osgeo.org/postgis/source/postgis-3.1.3.tar.gz
wget -c http://download.osgeo.org/geos/geos-3.9.1.tar.bz2
wget --no-check-certificate -c https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.8/SFCGAL-v1.3.8.tar.gz
wget -c http://download.osgeo.org/gdal/3.3.1/gdal-3.3.1.tar.gz
wget --no-check-certificate -c https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz
wget --no-check-certificate -c https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protobuf-cpp-3.19.1.tar.gz
wget --no-check-certificate -c  https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.0/protobuf-c-1.4.0.tar.gz

```

### 源码编译与安装

#### 环境变量设置
我们计划将数据库安装到/usr/local/pgsql。
修改/etc/profile，设置PATH、LD_LIBRARY_PATH环境变量。在此文件的最后加入两行:

```shell
export PATH=/usr/local/pgsql/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/pgsql/lib:/usr/local/pgsql/lib64:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/pgsql/lib/pkgconfig
```

然后执行：

```shell
source /etc/profile
```

也可以不执行上面的命令，直接注销，重新登录。

#### 编译安装protobuf
```shell
tar zvxf protobuf-cpp-3.19.1.tar.gz
mv protobuf-3.19.1 protobuf
cd protobuf
./configure --prefix=/usr/local/pgsql 
make 
sudo make install
cd ..
```

#### 编译安装protobuf-c
```shell
tar zvxf protobuf-c-1.4.0.tar.gz
mv protobuf-c-1.4.0 protobuf-c
cd protobuf-c
./configure --prefix=/usr/local/pgsql
make
sudo make install
cd ..
```

#### 编译安装uuid
```shell
tar -zvxf uuid-1.6.2.tar.gz 
mv uuid-1.6.2 uuid
cd uuid
./configure --prefix=/usr/local/pgsql 
make
sudo make install
cd ..
```

#### 编译安装boost
cgal需要boost库支持。
```shell
tar -zvxf boost_1_78_0.tar.gz
mv boost_1_78_0 boost
cd boost
./bootstrap.sh --prefix=/usr/local/pgsql
./b2
sudo ./b2 install
cd ..
```

#### 编译安装cgal
sfcgal需要cgal库支持。

```shell
tar -zvxf cgal-5.0.4.tar.gz 
mv cgal-5.0.4 cgal
cd cgal
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/pgsql ..
make
sudo make install
cd ../..
```

#### 编译SFCGAL
geos的高级空间分析功能（特别是3D空间分析）需要sfcgal支持。

```shell
tar zvxf SFCGAL-v1.3.8.tar.gz
mv SFCGAL-v1.3.8 sfcgal
cd sfcgal
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/pgsql ..
make 
sudo make install
cd ../..
```

#### 编译postgresql
```shell
tar zvxf postgresql-13.3.tar.gz
mv postgresql-13.3 postgresql
cd postgresql
./configure --prefix=/usr/local/pgsql --with-uuid=ossp
make 
sudo make install
cd contrib/uuid-ossp
make 
cd ../..
sudo make install
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
cd ..
```

#### 编译sqlite3(proj4需要）:
proj4需要sqlite3支持，并且必须带上SQLITE_ENABLE_COLUMN_METADATA=1参数。

```shell
tar zvxf sqlite-autoconf-3370000.tar.gz
mv sqlite-autoconf-3370000 sqlite
cd sqlite 
CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1" ./configure --prefix=/usr/local/pgsql
make 
sudo make install
cd ..
```

#### 编译proj4
postgis的投影变换功能需要proj4。

```shell
tar zvxf proj-8.1.0.tar.gz
mv proj-8.1.0 proj
cd proj
./configure --prefix=/usr/local/pgsql 
make 
sudo make install
cd ..
```

#### 编译geos
postgis的空间分析需要geos。

```shell
tar -jvxf geos-3.9.1.tar.bz2
mv geos-3.9.1 geos
cd geos
./configure --prefix=/usr/local/pgsql 
make 
sudo make install
cd ..
```

#### 编译gdal
postgis的raster模块必须gdal支持。

```shell
tar zvxf gdal-3.3.1.tar.gz
mv gdal-3.3.1 gdal
cd gdal

./configure --prefix=/usr/local/pgsql --with-proj=/usr/local/pgsql --with-sfcgal=/usr/local/pgsql/bin/sfcgal-config --with-geos=/usr/local/pgsql/bin/geos-config --with-sqlite3=/usr/local/pgsql  --with-pg=yes  
make
sudo make install 
cd ..
```

#### 编译postgis
```shell
tar zvxf postgis-3.1.3.tar.gz
mv postgis-3.1.3 postgis
cd postgis
./configure --prefix=/usr/local/pgsql --with-sfcgal
make
sudo make install
cd ..
```

### 安装后的清理工作

修改/etc/sudoers，使得postgres能以root权限执行命令, 并且在安装时需要输入密码:
```shell
vi /etc/sudoers

## Allow root to run any commands anywhere
root      ALL=(ALL)       ALL
postgres  ALL=(ALL)       ALL

```