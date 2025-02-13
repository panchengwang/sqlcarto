#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

if [ $# -ne 5 ]; then
    echo "Usage: $0 <max user> <node url> <db host> <db max size> <db reserved fact>"
    exit
fi

DBNAME=sc_master_db
psql -d sc_master_db -c "select sc_add_node( $1, '$2', '$3', $4, $5)"