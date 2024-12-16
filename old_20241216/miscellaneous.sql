-- 杂项函数

-- 重心计算
-- 参数:
--  points    点集坐标
--  weights   每个点的权重
--    注意points和weights是一一对应的
-- 返回:
--  重心的坐标
create or replace function sc_gravity_center(
  points geometry[],
  weights float8[]
) returns geometry as 
$$
declare
  sqlstr text;
  x float8; y float8;
  npoints integer; i integer;
  total float8; total_weight float8;

begin
  npoints := array_length(points,1);
  for i in 0 .. npoints-1 loop
  end loop;
  return NULL;
end;
$$ language 'plpgsql';


-- create table mypoints(
--   id serial,
--   geo geometry(POINT,4326),
--   w float8
-- );
-- insert into mypoints(geo,w) values
--   ('SRID=4326;POINT(112 20)'::geometry, 1),
--   ('SRID=4326;POINT(113 21)'::geometry, 1);

-- select array_agg(geo),array_agg(w) from mypoints;