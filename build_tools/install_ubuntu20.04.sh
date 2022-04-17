#!/bin/sh
set -e
OS=`uname`
CUR_DIR=$(cd `dirname $0`; pwd)

SCRIPT_NAME=${CUR_DIR}/install_scripts_for_ubuntu20.04.sh
echo "#!/bin/sh" > ${SCRIPT_NAME}
cat $CUR_DIR/src_code_config.sh >> ${SCRIPT_NAME}
cat $CUR_DIR/ubuntu20.04.sh >> ${SCRIPT_NAME}
echo "已经生成ubuntu20.04下的 proj4 + geos + sfcgal + gdal + postgis + postgresql + http + sqlcarto安装脚本："
echo "安装脚本为：install_scripts_for_ubuntu20.04.sh"
echo "请在您的源码目录下运行这个脚本，即可进入安装过程"

