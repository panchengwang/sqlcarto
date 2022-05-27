-- 将多边形等转换成linestring
create or replace function st_polygon_to_linestring(geo geometry) returns setof geometry as 
$$
declare
  sqlstr text;
  i integer;
  j integer;
  mypg geometry;
  myrec record;
  geotype varchar;
begin
  geotype := st_geometrytype(geo);
  if st_isempty(geo) then 
    return;
  end if;

  if geotype = 'ST_LineString' then 
    return next geo;
  elsif geotype = 'ST_MultiLineString' then
    for i in 1..st_numgeometries(geo) loop 
      return next st_geometryn(geo,i);
    end loop; 
  elsif geotype = 'ST_Polygon' then 
    return next ST_ExteriorRing(geo);
    for i in 1..ST_NumInteriorRings(geo) loop 
      return next ST_InteriorRingN(geo,i);
    end loop;
  elsif geotype = 'ST_MultiPolygon' then 
    for j in 1..st_numgeometries(geo) loop
      mypg := st_geometryn(geo,j);
      return next ST_ExteriorRing(mypg);
      for i in 1..ST_NumInteriorRings(mypg) loop 
        return next ST_InteriorRingN(mypg,i);
      end loop;
    end loop;
  elsif geotype = 'ST_GeometryCollection' then 
    for j in 1..st_numgeometries(geo) loop
      sqlstr := 'select geo from st_polygon_to_linestring(' || st_geometryn(geo,j) || ') as geo';
      for myrec in execute sqlstr loop 
        return next myrec.geo;
      end loop;
    end loop;
  elsif geotype <> 'ST_Polygon' 
    and geotype <> 'ST_MultiPolygon'
    and geotype <> 'ST_LineString'
    and geotype <> 'ST_MultiLineString' then 
    raise notice 'type: %, %', geotype,' Only LineString, MultiLineString,Polygon,MultiPolygon can be convert to LineString ';
  end if;

  return;
end;
$$
language 'plpgsql';



create or replace function st_dump_linestrings(geo geometry) returns setof geometry as 
$$
  select st_polygon_to_linestring($1);
$$
language 'sql';



-- 获取multilinestring中每个线段的起点
create or replace function st_startpoints(geo geometry) returns setof geometry as 
$$
  select st_startpoint((st_dump(st_linemerge($1))).geom);
$$
language 'sql';

-- 获取multilinestring中每个线段的尾点
create or replace function st_endpoints(geo geometry) returns setof geometry as 
$$
  select st_endpoint((st_dump(st_linemerge($1))).geom);
$$
language 'sql';



-- 将linestring从parts打断
create or replace function st_split_linestring(
  geo geometry,
  parts float8[]
) returns setof geometry as 
$$
declare
  startpt float8;
  locpt float8;
  sqlstr text;
  i integer;
begin
  for i in 1..array_length(parts,1)-1 loop 
    return next st_linesubstring(geo,parts[i],parts[i+1]);
  end loop;
  return;
end;
$$
language 'plpgsql';


--  将几何实体有效化
--    min_ratio
--    有效化的几何实体如polygon会转换成multipolygon,小于一定比例的部分直接删除，此比例由min_ratio指定
--  返回
--    point --> point
--    linestring --> linestring 
--    polygon --> polygon 
--    multipoint --> multipoint
--    multilinestring --> multilinestring
--    multipolygon --> multipolygon
create or replace function st_make_geometry_valid(geo geometry, min_ratio float8) returns geometry as 
$$
declare
  sqlstr text;
  geosarr geometry[];
  mygeo geometry;
  total_area float8;
  max_area float8;
  max_geo geometry;
  gtype varchar;
  extracttype integer;
  i integer;
begin
  gtype := st_geometrytype(geo);
  if gtype = 'ST_Point' or gtype = 'ST_MultiPoint' then 
    extracttype := 1;
  elsif gtype = 'ST_LineString' or gtype = 'ST_MultiLineString' then 
    extracttype := 2;
  else 
    extracttype := 3;
  end if;
  total_area := st_area(geo);
  geosarr := null;
  
  mygeo := st_makevalid(geo);
  if not st_iscollection(mygeo) then 
    return mygeo;
  end if;

  total_area := st_area(mygeo);
  max_area := 0;
  max_geo := null;

  if extracttype = 3 then
    for i in 1..st_numgeometries(mygeo) loop
      if st_geometrytype(st_geometryn(mygeo,i)) = 'ST_Polygon' or 
        st_geometrytype(st_geometryn(mygeo,i)) = 'ST_MultiPolygon' then 
        if st_area(st_geometryn(mygeo,i))/total_area >= min_ratio then 
          geosarr := array_append(geosarr,st_geometryn(mygeo,i));
        end if;
        if st_area(st_geometryn(mygeo,i)) > max_area then
          max_geo := st_geometryn(mygeo,i);
          max_area := st_area(st_geometryn(mygeo,i));
        end if;
      end if;
    end loop;
  else 
    return mygeo;
  end if;

  -- 目前仅仅处理polygon和multipolygon
  -- 如果是polygon，进行makevalid之后会转换成多个polygon，
  --  我们仅仅保留其中面积最大的那一个
  if not st_iscollection(geo) and extracttype = 3 then 
    return max_geo;
  end if;
  
  return st_collectionextract(st_collect(geosarr),extracttype);
  
end;
$$
language 'plpgsql'; 



create or replace function sc_get_geometry_column_srid(
  schemaname varchar,
  tablename varchar,
  geoname varchar
) returns integer as 
$$
  select 
    srid 
  from 
    geometry_columns 
  where 
    f_table_schema =$1 
    and 
    f_table_name=$2 
    and 
    f_geometry_column=$3;
$$ language 'sql';





-- 将多边形等转换成linestring
-- 包括外环，内环信息
create type PolygonDumpLineString as(
  isOutRing boolean,
  geom geometry
);

create or replace function sc_polygon_to_linestring(geo geometry) returns setof PolygonDumpLineString as 
$$
declare
  sqlstr text;
  i integer;
  j integer;
  mypg geometry;
  myrec record;
  geotype varchar;
  dumpline PolygonDumpLineString;
begin
  geotype := st_geometrytype(geo);
  if st_isempty(geo) then 
    return;
  end if;

  if geotype = 'ST_LineString' then 
    dumpline.isOutRing := false;
    dumpline.geom := geo;
    return next dumpline;
  elsif geotype = 'ST_MultiLineString' then
    for i in 1..st_numgeometries(geo) loop 
      dumpline.isOutRing := false;
      dumpline.geom := st_geometryn(geo,i);
      return next dumpline;
    end loop; 
  elsif geotype = 'ST_Polygon' then 
    dumpline.isOutRing := true;
    dumpline.geom := ST_ExteriorRing(geo);
    return next dumpline;
    for i in 1..ST_NumInteriorRings(geo) loop 
      dumpline.isOutRing := false;
      dumpline.geom := ST_InteriorRingN(geo,i);
      return next dumpline;
    end loop;
  elsif geotype = 'ST_MultiPolygon' then 
    for j in 1..st_numgeometries(geo) loop
      sqlstr := 'select dumpline from sc_polygon_to_linestring(' || quote_literal(st_geometryn(geo,j)::text) || ') as dumpline';
      for myrec in execute sqlstr loop 
        return next myrec.dumpline;
      end loop;
    end loop;
  elsif geotype = 'ST_GeometryCollection' then 
    for j in 1..st_numgeometries(geo) loop
      sqlstr := 'select dumpline from sc_polygon_to_linestring(' || quote_literal(st_geometryn(geo,j)::text) || ') as dumpline';
      for myrec in execute sqlstr loop 
        return next myrec.dumpline;
      end loop;
    end loop;
  elsif geotype <> 'ST_Polygon' 
    and geotype <> 'ST_MultiPolygon'
    and geotype <> 'ST_LineString'
    and geotype <> 'ST_MultiLineString' then 
    raise notice 'type: %, %', geotype,' Only LineString, MultiLineString,Polygon,MultiPolygon can be convert to LineString ';
  end if;

  return;
end;
$$
language 'plpgsql';



-- 将linestring导出成点，顺序不变，序号
create type LineStringDumpPoint as(
  id integer,
  geom geometry
);

create or replace function sc_linestring_to_points(ls geometry) returns setof LineStringDumpPoint as 
$$
declare 
  sqlstr text;
  myrec record;
  dumppoint LineStringDumpPoint;
begin 
  sqlstr := '
    select 
      B.idx as id,
      st_pointn(' || quote_literal(ls::text) || '::geometry , B.idx) as geom
    from 
      (select * from generate_series(1,' || st_npoints(ls) || ')  as idx) B
    order by B.idx;
  ';
  raise notice '%', sqlstr;
  for myrec in execute sqlstr loop 
    dumppoint.id = myrec.id;
    dumppoint.geom = myrec.geom;
    return next dumppoint;
  end loop;
  return ;
end;
$$ language 'plpgsql';


-- 将polygon和multipolygon中的洞填上

create or replace function sc_fill_hole(geo geometry) returns geometry as 
$$
declare
  sqlstr text;
  geotype varchar;
  myrec record;
  mygeo geometry;
begin
  geotype := st_geometrytype(geo);
  if st_isempty(geo) then 
    return geo;
  end if;

  if geotype = 'ST_Polygon' then 
    return st_makepolygon(ST_ExteriorRing(geo));
  end if;

  if geotype = 'ST_MultiPolygon' then 
    select st_union(sc_fill_hole(geom)) into mygeo from st_dump(geo);
    return mygeo;
  end if;
  return geo;
end;
$$
language 'plpgsql';


-- st_makevalid在计算无效多边形的时候有bug，下面的函数提供一个更好的无效多边形有效化函数
create or replace function sc_makevalid