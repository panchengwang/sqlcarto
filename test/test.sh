#!/bin/bash
CUR_DIR=$(cd `dirname $0`; pwd)

DBNAME=sqlcarto
createdb $DBNAME

psql -d $DBNAME -f $CUR_DIR/test.sql
