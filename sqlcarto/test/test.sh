#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

dbname=testdb
psql -d $dbname  -c " SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$dbname' AND pid <> pg_backend_pid();"

dropdb  $dbname
createdb  $dbname
psql  -d $dbname -f ${CUR_DIR}/test.sql
psql  -d $dbname -f ${CUR_DIR}/test_sym.sql
