# SQLCarto

SQLCarto is an extension to render map image embedded in PostGIS/PostgreSQL.

## Install

### Set some environment variables
If you want to install postgis/postgresql in a directory which is not specified by PATH environment variable, 
you must set PATH .
In this document, we assume you want to install postgis/postgresql to /usr/local/pgsql.

```
sudo vi /etc/profile
```
Append the following code to the end of /etc/profile:

Linux:

```shell
# set PG_PATH to which directory you want to install postgis/postgresql binaries.
PG_PATH=/usr/local/pgsql   
export PATH=.:$PG_PATH/bin:$PG_PATH/lib:$PATH
export LD_LIBRARY_PATH=.:$PG_PATH/lib:$LD_LIBRARY_PATH
```

Mac:

```shell
# set PG_PATH to which directory you want to install postgis/postgresql binaries.
PG_PATH=/usr/local/pgsql   
export PATH=.:$PG_PATH/bin:$PG_PATH/lib:$PATH
export DYLD_LIBRARY_PATH=.:$PG_PATH/lib:$DYLD_LIBRARY_PATH
```

To enable settings:

```shell
source /etc/profile
```






### Compile and install PostGIS/PostgreSQL from source code

Compile and install PostGIS/PostgreSQL from source code is a complex work. There is a "postgis_install.sh" shell script  to help you. This shell script is located in directory "tools".

```shell
cd tools
vi postgis_install.sh
```

Edit postgis_install.sh:

```shell
...

# set SOURCE_PATH to the directory which source code will be saved.
SOURCE_PATH=~/software/src
mkdir -p ${SOURCE_PATH}
# set INSTALL_PATH to the deirectory that you want to insall all spatial database libraries and executable files.
INSTALL_PATH=/usr/local/pgsql

...
```

Execute postgis_install.sh:
```
bash ./postgis_install.sh
```


### Build postgis libraries wrapper to support SQLCarto

After install PostGIS extension for PostgreSQL, a dynamic library which name is similar to 'postgis-*.*.so' is created. This library is located in /usr/local/pgsql/lib. But postgis-*.*.so only support postgresql calling. We can not link to postgis-*.*.so. So postgis libraries wrapper must be create to be called by SQLCarto extension.

There is a shell script located in diretory "tools", which name is create_postgis_lib.sh . To build postgis library wrapper, run this shell script: 

```shell
bash create_postgis_lib.sh
```

