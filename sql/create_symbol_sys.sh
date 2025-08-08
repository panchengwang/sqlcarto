#!/bin/sh
CUR_DIR=$(cd `dirname $0`; pwd)

echo '  
-- Availability: 3.4.2 
-- 预定义好的地图符号postgres 
-- 地图符号中的线宽、点划线中的dash单位均为毫米 
-- 地图符号的定位坐标则为归一化的数值， 如圆心坐标、圆半径等 
-- 地图符号中的角度坐标为度，如弧的开始、结束角度，旋转角度 
create table symbol_sys( 
    id varchar(32) default sc_uuid(),       -- 
    english varchar(32),                    -- 英文名 
    chinese varchar(32),                    -- 中文名 
    sym symbol not null                     -- 地图符号 
); 
'
SYMBOLS_DIR=$(pg_config --sharedir)

for jsonfile in ${SYMBOLS_DIR}/mapengine/*.json 
do 
    filename=`basename "$jsonfile" | cut -d'.' -f1 `
    english=`echo $filename | cut -d'_' -f1`
    chinese=`echo $filename | cut -d'_' -f2`
    echo "insert into symbol_sys(english, chinese, sym) values('$english','$chinese','"
    cat "$jsonfile"
    echo "');\n"
done