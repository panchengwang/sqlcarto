#!/bin/sh

CUR_DIR=$(cd `dirname $0`; pwd)
PG_SRC_DIR=~/software/sdb/postgresql-17.0
POSTGIS_SRC_DIR=~/software/sdb/postgis-3.5.3

sh combine_sql.sh

echo "POSTGIS_SRC_DIR=${POSTGIS_SRC_DIR}" > ${CUR_DIR}/Makefile
cat ${CUR_DIR}/Makefile.in >> ${CUR_DIR}/Makefile

cat  > postgis.h <<EOF
#ifndef __POSTGIS_H
#define __POSTGIS_H
#include "$POSTGIS_SRC_DIR/liblwgeom/liblwgeom.h"
#include "$POSTGIS_SRC_DIR/postgis/lwgeom_geos.h"
#endif
EOF

cat > create_liblwgeom_so.sh <<EOF
#!/bin/sh
cd ${POSTGIS_SRC_DIR}
gcc -shared liblwgeom/*.o libpgcommon/*.o deps/ryu/d2s.o  -o liblwgeom.so -lgeos_c -lproj -ljson-c -lm -lpthread -lSFCGAL
sudo cp liblwgeom.so `pg_config --libdir`
EOF


rm -rf ${PG_SRC_DIR}/contrib/sqlcarto
rsync -av --exclude='.*' ${CUR_DIR} ${PG_SRC_DIR}/contrib

# cp ${CUR_DIR} ${PG_SRC_DIR}/contrib -r
cd ${PG_SRC_DIR}/contrib/sqlcarto
sh create_liblwgeom_so.sh
make 
sudo make install



