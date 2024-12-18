#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

DBNAME=sc_master_db
dropdb ${DBNAME}
createdb ${DBNAME}
psql -d ${DBNAME} -c "create extension postgis;create extension postgis_sfcgal;create extension postgis_sqlcarto;"