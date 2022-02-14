-- 网络地图服务, 目前仅仅支持高德
-- 需要安装http-pgsql扩展
--  从 https://github.com/pramsey/pgsql-http 下载源码，编译安装
--    create extension "pgsql-http";
-- 元数据表

-- drop table if exists sc_web_maps;
-- create table sc_web_maps(
--   id serial primary key,
--   name varchar(64),
--   provider varchar(32),
--   url varchar(1024),
--   key varchar(1024),
--   type varchar,
--   request_type varchar,
--   params json
-- );

-- -- 高德
-- insert into sc_web_maps(name,provider,url,type,request_type,params) values
--   ( 
--     '高德逆地理编码',
--     'GAODE',
--     'https://restapi.amap.com/v3/geocode/regeo',
--     'GET',
--     'R_GEOCODE',
--     '{
--       "radius":0,
--       "extensions":"all",
--       "batch":true,
--       "output":"json"
--     }'::json);

-- 逆地理编码
-- 得到高德的逆地理编码返回json，此json包含有aois、pois等信息
create or replace function sc_gaode_reverse_geocode(
  url varchar,
  params json,
  key varchar,
  location geometry(POINT,4326)
  ) returns json as 
$$
declare
  sqlstr text;
  myurl text;
  retjson json;
begin
  myurl := url || '?output=json&location=' || st_x(location) || ',' || st_y(location) || '&key=' || key || '&radius=0&extensions=all';
  select http_set_curlopt('CURLOPT_SSL_VERIFYPEER','0');
  select 
		content::json into retjson
	from 
		http_get(myurl);
  if retjson->>'status' <> '1' then
    return null;
  end if;
  return retjson->'regeocode';
end;
$$ language 'plpgsql';

create or replace function sc_gaode_reverse_geocode_aois(
  url varchar,
  params json,
  key varchar,
  location geometry(POINT,4326)
) returns json as $$
declare
  myjson json;
begin
  myjson := sc_gaode_reverse_geocode(url,params,key,location);
  if myjson is null then
    return null;
  end if;
  -- raise notice '%', myjson->'aois';
  return myjson->'aois';
end;
$$ language 'plpgsql';


create or replace function sc_gaode_reverse_geocode_pois(
  url varchar,
  params json,
  key varchar,
  location geometry(POINT,4326)
) returns json as $$
declare
  myjson json;
begin
  myjson := sc_gaode_reverse_geocode(url,params,key,location);
  if myjson is null then
    return null;
  end if;
  return myjson->'pois';
end;
$$ language 'plpgsql';

-- 测试
select sc_gaode_reverse_geocode_aois(
  'https://restapi.amap.com/v3/geocode/regeo',
  '{}'::json,
  'f599fa220f499f97005e2cc7ef0d4846',
  'SRID=4326;POINT(112.99110419681632 28.13963812157232)'::geometry
);

-- curl "https://restapi.amap.com/v3/geocode/regeo?output=json&location=112.99110419681632,28.13963812157232&key=f599fa220f499f97005e2cc7ef0d4846&radius=10&extensions=all"

-- 测试
-- select sc_gaode_reverse_geocode_pois(
--   'https://restapi.amap.com/v3/geocode/regeo',
--   '{}'::json,
--   'f599fa220f499f97005e2cc7ef0d4846',
--   'SRID=4326;POINT(112.99110419681632 28.13963812157232)'::geometry
-- );

-- create or replace function furongqu_aois() returns varchar as $$
-- declare
-- 	sqlstr text;
-- 	myrec record;
-- 	aois_arr json;
-- 	myaois json;
-- 	url text;
-- 	i integer;
-- begin
-- 	sqlstr := '
-- 		select _id, _center  from 
-- 		(select _id, sc_wgs84_to_gcj02(st_transform(_center,4326)) as _center from furongqu_grid) A order by A._id';
-- 	i := 0;
-- 	for myrec in execute sqlstr loop
-- -- 		if i>=20 then 
-- -- 			return 'ok';
-- -- 		end if;
-- 		myaois := sc_gaode_reverse_geocode_aois(
-- 			  'https://restapi.amap.com/v3/geocode/regeo',
-- 			  '{}'::json,
-- 			  'bdd9e64a28e29966524899e518e09a3c',
-- 			  myrec._center
-- 			) ;
-- -- 		raise notice '%',aois;
-- 		sqlstr := 'update furongqu_grid set aois = ' || quote_literal(myaois::text) || '::json where _id = ' || myrec._id;
-- 		-- raise notice '%',sqlstr;
-- 		execute sqlstr;
-- 		execute 'select pg_sleep(random()*0.01)';
-- 		raise notice '%', myrec._id;
-- 		i := i+1;
-- 	end loop;
-- 	return 'ok';
-- end;
-- $$ language 'plpgsql';

-- select furongqu_aois();