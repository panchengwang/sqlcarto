#!/bin/bash
CUR_DIR=$(cd `dirname $0`; pwd)

DBNAME=sqlcarto
dropdb $DBNAME
createdb $DBNAME

psql -d $DBNAME -c "create extension \"uuid-ossp\";"
psql -d $DBNAME -c "create extension postgis;"
psql -d $DBNAME -c "create extension postgis_sfcgal;"
psql -d $DBNAME -c "create extension postgis_topology;"
psql -d $DBNAME -c "create extension sqlcarto;"
psql -d $DBNAME -f $CUR_DIR/data/testdata.sql
psql -d $DBNAME -f $CUR_DIR/test.sql
