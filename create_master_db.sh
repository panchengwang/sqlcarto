#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)
DB_DIR=~/pgsqldb
pg_ctl -D ${DB_DIR} stop
rm -rf ${DB_DIR}
mkdir ${DB_DIR}
initdb -D ${DB_DIR} -E utf8
pg_ctl -D ${DB_DIR} start

DBNAME=sc_template
dropdb ${DBNAME}
createdb ${DBNAME}
psql -d ${DBNAME} -c "create extension dblink;  create extension \"uuid-ossp\" ;  create extension postgis;  create extension postgis_sfcgal;  create extension postgis_sqlcarto;"


DBNAME=sc_user_db
dropdb ${DBNAME}
createdb ${DBNAME} -T sc_template

# http://127.0.0.1/sqlcarto/service.php?request={%22type%22:%22USER_GET_VERIFY_CODE%22,%22data%22:{%22username%22:%22wang_wang_lao@163.com%22}}
# http://127.0.0.1/sqlcarto/service.php?request={%22type%22:%22USER_CREATE%22,%22data%22:{%22username%22:%22wang_wang_lao@163.com%22}}