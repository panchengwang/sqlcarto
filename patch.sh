#!/bin/sh

# 以下内容为首次安装时使用，仅仅调试sqlcarto时，注释掉
#######################################################################################
sed -i 's/^[ \t]*SUBDIRS[ \t]*=[ \t]*postgis[ \t]*$/SUBDIRS = postgis postgis_sqlcarto/g' extensions/Makefile.in 
sed -i 's/^[ \t]*SUBDIRS[ \t]*=.*loader[ \t]*$/SUBDIRS = liblwgeom @RASTER@ loader sqlcarto/g' GNUmakefile.in 

os=$(uname | cut -c 1-5)

if [ "$os" = "MINGW" ] ; then 
    sed -i 's/#include <geos_c.h>//g' postgis_config.h.in
    sed -i 's/#define bzero(buf,n) memset(buf,0,n)//g' postgis_config.h.in
    #sed -i 's/#undef HAVE_SQLCARTO//g' postgis_config.h.in
    sed -i '/^$/{N;/^\n*$/D}' postgis_config.h.in
    sed -i '5i #include <geos_c.h>' postgis_config.h.in
    sed -i '6i #define bzero(buf,n) memset(buf,0,n)' postgis_config.h.in
fi



sed -i 's/ac_config_files+=" extensions\/postgis_sqlcarto\/Makefile sqlcarto\/Makefile//g' configure
linenum=`grep -rn 'ac_config_files GNUmakefile' configure | awk -F ':' '{print $1+1}'`
sed -i ${linenum}'i ac_config_files+=" extensions\/postgis_sqlcarto\/Makefile sqlcarto\/Makefile"' configure

linenum=`grep -rn "'postgis_topology' => 1" loader/postgis.pl | awk -F ':' '{print $1+1}'`
sed -i ${linenum}"i ,'postgis_sqlcarto' => 1" loader/postgis.pl
# #########################################################################################




