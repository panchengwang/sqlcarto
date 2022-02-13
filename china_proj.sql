

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





