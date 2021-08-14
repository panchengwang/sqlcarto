

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

