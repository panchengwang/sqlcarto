#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)
DB_DIR=~/pgsqldb

DBNAME=sc_master_db

psql -d ${DBNAME}  -c " SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid();"
pg_ctl -D ${DB_DIR} stop
rm -rf ${DB_DIR}
mkdir ${DB_DIR}
initdb -D ${DB_DIR} -E utf8
pg_ctl -D ${DB_DIR} start

TEMPLATE_DBNAME=sc_template
dropdb ${TEMPLATE_DBNAME}
createdb ${TEMPLATE_DBNAME}
psql -d ${TEMPLATE_DBNAME} -c "create extension dblink;  create extension \"uuid-ossp\" ;  create extension postgis;  create extension postgis_sfcgal;  create extension postgis_sqlcarto;"
    


dropdb ${DBNAME}
createdb ${DBNAME} -T sc_template

# http://127.0.0.1/sqlcarto/service.php?request={%22type%22:%22USER_GET_VERIFY_CODE%22,%22data%22:{%22username%22:%22wang_wang_lao@163.com%22}}
# http://127.0.0.1/sqlcarto/service.php?request={%22type%22:%22USER_CREATE%22,%22data%22:{%22username%22:%22wang_wang_lao@163.com%22}}