#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

sh ${CUR_DIR}/create_master_db.sh

TEMPLATE_DBNAME=sc_template
MASTER_DBNAME=sc_master_db
NODE_DBNAME=sc_node_db

dropdb ${NODE_DBNAME}
createdb -T sc_template ${NODE_DBNAME}

sh ${CUR_DIR}/add_node.sh 200 "http://127.0.0.1/sqlcarto/node/service.php" "host=127.0.0.1 port=5432 dbname=sc_node_db" 200000 0.2