/* contrib/sqlcarto/sqlcarto--1.0.sql */


\echo Use "create EXTENSION sqlcarto;" to add sqlcarto extension. \quit


create or replace function sqlcarto_info() returns json as 
$$
  select '{
      "extension" : "SQLCarto",
      "version" : "1.0",
      "author" : "pcwang",
      "qq" : "593723812"
    }'::json;
$$
language 'sql';


create or replace function sc_uuid() returns text as
$$
  select replace(gen_random_uuid()::text,'-','');
$$
language 'sql';



create or replace function sc_ensure_id(schemaname varchar, tablename varchar) returns varchar as 
$$
declare
  sqlstr text;
  myrec record;
begin
  sqlstr := '
    SELECT 
      COUNT(*) AS num 
    FROM 
      INFORMATION_SCHEMA.COLUMNS 
    WHERE 
      table_schema=' || quote_literal(schemaname) || ' 
      and 
      table_name = ' || quote_literal(tablename) || ' 
      AND 
      column_name = ' || quote_literal('__id') ;
  for myrec in execute sqlstr loop 
    if myrec.num = 0 then 
      sqlstr := 'alter table ' || quote_ident(schemaname) || '.' || quote_ident(tablename) || ' add column __id varchar(32) unique default sc_uuid()';
      execute sqlstr;
    end if;
  end loop;
  return '__id';
end;
$$
language 'plpgsql';

-- ---------------------------------------------------------------
-- 中国国内特殊坐标系转换工具
-- ---------------------------------------------------------------


-- 将gcj02（火星坐标系）转换到百度坐标系
CREATE OR REPLACE FUNCTION sc_gcj02_to_bd09(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','gcj02_to_bd09'
LANGUAGE C IMMUTABLE STRICT;


-- 将百度坐标系转换到gcj02（火星坐标系）
CREATE OR REPLACE FUNCTION sc_bd09_to_gcj02(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','bd09_to_gcj02'
LANGUAGE C IMMUTABLE STRICT;


-- 将WGS84坐标转换到gcj02（火星坐标系）
CREATE OR REPLACE FUNCTION sc_wgs84_to_gcj02(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','wgs84_to_gcj02'
LANGUAGE C IMMUTABLE STRICT;

-- 将gcj02（火星坐标系）转换到WGS84坐标
CREATE OR REPLACE FUNCTION sc_gcj02_to_wgs84(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','gcj02_to_wgs84'
LANGUAGE C IMMUTABLE STRICT;


-- 将百度坐标系转换到WGS84
CREATE OR REPLACE FUNCTION sc_bd09_to_wgs84(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','bd09_to_wgs84'
LANGUAGE C IMMUTABLE STRICT;


-- 将WGS84转换到百度坐标系
CREATE OR REPLACE FUNCTION sc_wgs84_to_bd09(geometry)
RETURNS geometry
AS '$libdir/sqlcarto','wgs84_to_bd09'
LANGUAGE C IMMUTABLE STRICT;








-- ---------------------------------------------------------------
-- 地图瓦片工具
-- ---------------------------------------------------------------


CREATE OR REPLACE FUNCTION tile_in(cstring)
	RETURNS tile
	AS '$libdir/sqlcarto','tile_in'
	LANGUAGE 'c' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION tile_out(tile)
	RETURNS cstring
	AS '$libdir/sqlcarto','tile_out'
	LANGUAGE 'c' IMMUTABLE STRICT;

CREATE TYPE tile (
   internallength = 12,
   input = tile_in,
   output = tile_out,
   alignment = int4
);

-- 瓦片转换成经纬度，左上角坐标
CREATE OR REPLACE FUNCTION sc_tile_to_lonlat(tile)
RETURNS geometry
AS '$libdir/sqlcarto','tile_to_lonlat'
LANGUAGE C IMMUTABLE STRICT;

-- 经纬度转换成瓦片
CREATE OR REPLACE FUNCTION sc_lonlat_to_tile(geometry,integer)
RETURNS tile
AS '$libdir/sqlcarto','lonlat_to_tile'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_x(tile)
RETURNS integer
AS '$libdir/sqlcarto','tile_x'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_set_x(tile,integer)
RETURNS tile
AS '$libdir/sqlcarto','tile_set_x'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_y(tile)
RETURNS integer
AS '$libdir/sqlcarto','tile_y'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_set_y(tile,integer)
RETURNS tile
AS '$libdir/sqlcarto','tile_set_y'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_z(tile)
RETURNS integer
AS '$libdir/sqlcarto','tile_z'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION sc_set_z(tile,integer)
RETURNS tile
AS '$libdir/sqlcarto','tile_set_z'
LANGUAGE C IMMUTABLE STRICT;

-- 根据缩放级别计算分辨率
-- tilesize为瓦片的图像宽/高，一般为256像素
-- 为适应高清屏幕，现在的地图瓦片已经由512像素大小的了
-- 注意此分辨率为一个像素代表Web墨卡托坐标系（不是WGS84！）下的长度
create or replace function sc_get_resolution_of_zoom_level(z integer, tilesize integer) returns float8
as
$$
select
    (st_x(st_transform(tile_to_lonlat(('TILE(1,0,' || $1 || ')')::tile),3857))
    - st_x(st_transform(tile_to_lonlat(('TILE(0,0,' || $1 || ')')::tile),3857)))/$2
  ;
$$
language 'sql';


-- 根据缩放级别计算分辨率
-- 缺省采用256像素的瓦片大小
-- 注意此分辨率为一个像素代表Web墨卡托坐标系（不是WGS84！）下的长度
CREATE OR REPLACE FUNCTION sc_get_resolution_of_zoom_level(z integer) returns float8 AS
$$
  select sc_get_resolution_of_zoom_level($1,256);
$$
LANGUAGE 'sql';


-- 得到所有的分辨率
-- 瓦片大小为256
CREATE OR REPLACE FUNCTION sc_get_resolutions_of_all_zoom_levels(maxlevel integer)
RETURNS setof float8 as
$$
  select
    sc_get_resolution_of_zoom_level(A.z) as resolution
  from
    (select generate_series(0,$1) as z) as A;
$$
LANGUAGE 'sql';

-- 得到所有的分辨率
-- 瓦片大小为256
-- 最多23级
CREATE OR REPLACE FUNCTION sc_get_resolutions_of_all_zoom_levels()
RETURNS setof float8 as
$$
  select sc_get_resolutions_of_all_zoom_levels(23);
$$
LANGUAGE 'sql';

-----------------------------------------------
-- 几何形态学

-- 判断是否包含尖刺
-- 如果角度小于给定值 tolerance，则判断为尖刺
create or replace function sc_has_spines(geo geometry, tolerance float8) returns BOOLEAN
AS '$libdir/sqlcarto','has_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;

-- 判断是否包含尖刺, 缺省角度为5度
create or replace function sc_has_spines(geo geometry) returns BOOLEAN
AS '$libdir/sqlcarto','has_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;


-- 去除geometry中的尖刺
--  geometry必须为线、多边形
--  尖刺的标准为角度小于tolerance
create or replace function sc_remove_spines(geo geometry, tolerance float8) returns geometry
AS '$libdir/sqlcarto','remove_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;

-- 缺省尖刺为5度
create or replace function sc_remove_spines(geo geometry) returns geometry
AS '$libdir/sqlcarto','remove_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;








