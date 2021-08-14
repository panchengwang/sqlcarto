-----------------------------------------------
-- 一些增加的空间分析函数

-- 去除geometry中的尖刺
--  geometry必须为线、多边形
--  尖刺的标准为角度小于tolerance
create or replace function sc_remove_spines(geo geometry, tolerance float8) returns geometry
AS '$libdir/pangis','remove_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;

-- 缺省尖刺为5度
create or replace function sc_remove_spines(geo geometry) returns geometry
AS '$libdir/pangis','remove_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;


-- 判断是否包含尖刺
-- 如果角度小于给定值 tolerance，则判断为尖刺
create or replace function sc_has_spines(geo geometry, tolerance float8) returns BOOLEAN
AS '$libdir/pangis','has_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;

-- 判断是否包含尖刺, 缺省角度为5度
create or replace function sc_has_spines(geo geometry) returns BOOLEAN
AS '$libdir/pangis','has_spines'
	LANGUAGE 'c' IMMUTABLE STRICT;





