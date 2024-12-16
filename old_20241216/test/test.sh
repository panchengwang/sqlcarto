#!/bin/bash
EXTENSION_DIR=`pg_config --sharedir`/extension
CONTROL_FILE=$EXTENSION_DIR/postgis_topology.control
POSTGIS_VER=`grep 'default_version' $CONTROL_FILE | sed "s/.*'\(.*\)'/\1/g"`
SQL_FILE=${EXTENSION_DIR}/postgis_topology--${POSTGIS_VER}.sql
if [ ! -f ${SQL_FILE}.bak ]; then
  sudo cp $SQL_FILE ${SQL_FILE}.bak
fi
sudo cp -f ${SQL_FILE}.bak ${SQL_FILE}
sudo sh -c "echo '\n\r' >> ${SQL_FILE}"
sudo sh -c "cat ../postgis_topology_patch.sql >> ${SQL_FILE}"

