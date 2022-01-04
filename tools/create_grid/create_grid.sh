#/bin/bash

usage(){
  echo "current command：$0"
  echo "This command can generate a grid table include many partition tables in parallel."
  echo "usage: $0 <host> <port> <dbname> <user> <schemaname> <gridname> <srid> <minx> <miny> <nrows> <ncols> <xstep> <ystep> <num of records per sub table> <Number of concurrent>"
}

if [ $# != 15 ]; then 
  usage
  exit 1
fi

CMD_DIR=$(cd `dirname $0`; pwd)
${CMD_DIR}/create_grid $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} > /tmp/temp.sh
bash /tmp/temp.sh
rm -f /tmp/temp.sh
