# SQLCarto

SQLCarto 是一个嵌入在开源空间数据库 PostGIS/PostgreSQL 中能提供地图生成的扩展。它同时还提供：中国特殊坐标的转换、地图瓦片计算、几何形态学等功能。

## 安装

### 环境变量设置
如果想将PostGIS/PostgreSQL安装在一个指定的目录并且这个目录没有包含在PATH环境变量中，首先应该设置PATH环境变量。
本文档假设PostGIS/PostgreSQL的安装目录为/usr/local/pgsql。
执行以下命令：
```
sudo vi /etc/profile
```
在文件/etc/profile的最后添加下面的代码:

Linux系统:

```shell
# set PG_PATH to which directory you want to install postgis/postgresql binaries.
PG_PATH=/usr/local/pgsql   
export PATH=.:$PG_PATH/bin:$PG_PATH/lib:$PATH
export LD_LIBRARY_PATH=.:$PG_PATH/lib:$LD_LIBRARY_PATH
```

Mac系统:

```shell
# set PG_PATH to which directory you want to install postgis/postgresql binaries.
PG_PATH=/usr/local/pgsql   
export PATH=.:$PG_PATH/bin:$PG_PATH/lib:$PATH
export DYLD_LIBRARY_PATH=.:$PG_PATH/lib:$DYLD_LIBRARY_PATH
```

执行下面的命令使得刚才的设置生效：

```shell
source /etc/profile
```






### 从源码编译安装PostGIS/PostgreSQL
为使用SQLCarto扩展，应该从源码开始安装PostGIS/PostgreSQL，然后在此基础上再编译SQLCarto。

#### 分步安装
下面以ubutun为例演示数据库的编译安装过程。


#### 一键安装
从上面的分步安装可以看到，从源码编译和安装PostGIS/PostgreSQL有点复杂。SQLCarto的源码包里提供了一个"postgis_install.sh"来简化安装过程，此脚本位于tools子目录中。

```shell
cd tools
vi postgis_install.sh
```

修改 postgis_install.sh:

```shell
...

# 将 SOURCE_PATH 设置为源代码要存放的目录
SOURCE_PATH=~/software/src
mkdir -p ${SOURCE_PATH}
# 将 INSTALL_PATH 设置为安装目录
INSTALL_PATH=/usr/local/pgsql

...
```

执行 postgis_install.sh:
```
bash ./postgis_install.sh
```

在安装的过程会提示需要sudo密码，您根据要求输入就可以了。

### 安装SQLCarto
SQLCarto的安装是非常简单的。不过安装过程与典型的PostgreSQL扩展不一样。
修改install.sh脚本，将PG_SRC_PATH设置为postgresql源码所在的目录：
```shell
#!/bin/bash

# 修改 PG_SRC_PATH 为postgresql源码所在的目录
PG_SRC_PATH=~/software/src/postgresql
CONTRIB=${PG_SRC_PATH}/contrib

.........
```
执行安装脚本：
```shell
bash install.sh
```


