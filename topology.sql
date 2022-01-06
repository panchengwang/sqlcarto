-- 从线表生成polygon表
create or replace function sc_linestring_to_polygon(
  schemaname varchar,
  linetablename varchar,
  linegeoname varchar,
  polygontablename varchar,
  polygongeoname varchar
) returns varchar as $$
declare
  sqlstr text;
  linefullname varchar;
  polygonfullname varchar;
  tableid varchar;
  ret varchar;
begin
  linefullname := quote_ident(schemaname) || '.' || quote_ident(linetablename);
  polygonfullname := quote_ident(schemaname) || '.' || quote_ident(polygontablename);
  tableid := sc_uuid();
  ret := sc_node_from_linestrings(schemaname,linetablename,linegeoname,'node_' || tableid);
  ret := sc_linestring_to_arc(schemaname,linetablename,linegeoname,'node_' || tableid, '_geo', 'arc_'||tableid);

  return '';
end;
$$ language 'plpgsql';



-- 从线表生成节点表
-- 参数：
--    schemaname
--    linetablename 线表名
--    geoname 线字段名
--    nodetablename 节点表名
create or replace function sc_node_from_linestrings(
  schemaname varchar,
  linetablename varchar,
  geoname varchar,
  nodetablename varchar
) returns varchar as 
$$
declare
  sqlstr text;
  myrec record;
  geotype varchar;
  i integer;
  mygeo geometry;
  srid integer;
  nodefullname varchar;
  linefullname varchar;
  ret varchar;
begin

  srid := find_srid(schemaname,linetablename,geoname);

  linefullname := quote_ident(schemaname) || '.' || quote_ident(linetablename);
  nodefullname := quote_ident(schemaname) || '.'  || quote_ident(nodetablename);

  if geoname <> '_geo' then 
    sqlstr := 'alter table ' || linefullname || ' rename ' || quote_ident(geoname) || ' to _geo';
    execute sqlstr;
  end if;

  ret := sc_add_id_column(schemaname,linetablename);

  -- 建节点表
  sqlstr :='
    create table ' || nodefullname || '(
      _id varchar(32) default sc_uuid(),
      _geo geometry(POINT,' || srid || ')
    )
  ';
  execute sqlstr;

  -- 线收尾点作为节点插入表
  sqlstr := '
    insert into ' || nodefullname || '(
      _geo  
    ) 
    select st_startpoint(_geo) from ' || linetablename || '
  ';
  execute sqlstr;
  sqlstr := '
    insert into ' || nodefullname || '(
      _geo  
    ) 
    select st_endpoint(_geo) from ' || linetablename || '
  ';
  execute sqlstr;


  -- 两两求交并将交点插入节点表
  sqlstr :='
    select 
      st_intersection(A._geo,B._geo) as _geo
    from 
      ' || quote_ident(schemaname) || '.' || quote_ident(linetablename) || ' A,
      ' || quote_ident(schemaname) || '.' || quote_ident(linetablename) || ' B
    where
      st_intersects(A._geo,B._geo)
      and
      A._id <> B._id
  ';
  for myrec in execute sqlstr loop
    geotype = st_geometrytype(myrec._geo);
    if geotype = 'ST_Point' then 
      sqlstr := 'insert into ' || nodefullname || '(_geo) values(' || quote_literal(myrec._geo::text) || '::geometry)';
      execute sqlstr;
    elsif geotype = 'ST_MultiPoint' then 
      sqlstr := 'insert into ' || nodefullname || '(_geo) select (st_dump(' || quote_literal(myrec._geo::text) || '::geometry)).geom';
      execute sqlstr;
    elsif geotype = 'ST_LineString'  then
      sqlstr := 'insert into ' || nodefullname || '(_geo) select st_startpoint(' || quote_literal(myrec._geo::text) || '::geometry) ';
      execute sqlstr;
      sqlstr := 'insert into ' || nodefullname || '(_geo) select st_endpoint(' || quote_literal(myrec._geo::text) || '::geometry) ';
      execute sqlstr;
    elsif geotype = 'ST_MultiLineString' then 
      sqlstr := 'insert into ' || nodefullname || '(_geo) select st_startpoints(' || quote_literal(myrec._geo::text) || '::geometry) ';
      execute sqlstr;
      sqlstr := 'insert into ' || nodefullname || '(_geo) select st_endpoints(' || quote_literal(myrec._geo::text) || '::geometry) ';
      execute sqlstr;
    else 
      for i in 1..st_numgeometries(myrec._geo) loop
        mygeo := st_geometryn(myrec._geo,i);
        geotype = st_geometrytype(mygeo);
        if geotype = 'ST_Point' then 
          sqlstr := 'insert into ' || nodefullname || '(_geo) values(' || quote_literal(mygeo::text) || '::geometry)';
          execute sqlstr;
        elsif geotype = 'ST_MultiPoint' then 
          sqlstr := 'insert into ' || nodefullname || '(_geo) select (st_dump(' || quote_literal(mygeo::text) || '::geometry)).geom';
          execute sqlstr;
        elsif geotype = 'ST_LineString'  then
          sqlstr := 'insert into ' || nodefullname || '(_geo) select st_startpoint(' || quote_literal(mygeo::text) || '::geometry) ';
          execute sqlstr;
          sqlstr := 'insert into ' || nodefullname || '(_geo) select st_endpoint(' || quote_literal(mygeo::text) || '::geometry) ';
          execute sqlstr;
        elsif geotype = 'ST_MultiLineString' then 
          sqlstr := 'insert into ' || nodefullname || '(_geo) select st_startpoints(' || quote_literal(mygeo::text) || '::geometry) ';
          execute sqlstr;
          sqlstr := 'insert into ' || nodefullname || '(_geo) select st_endpoints(' || quote_literal(mygeo::text) || '::geometry) ';
          execute sqlstr;
        end if;
      end loop;
    end if;
  end loop;


  -- 去除重复点
  sqlstr := 'create table ' || quote_ident(schemaname) || '.'  || quote_ident(nodetablename || '_temp') || '(
    _id varchar(32) default sc_uuid(),
    _geo geometry(POINT,' || srid || ')
    )';
  execute sqlstr ;
  sqlstr := '
    insert into ' || quote_ident(schemaname) || '.'  || quote_ident(nodetablename || '_temp')  || '(_geo)
    select distinct _geo from ' || nodefullname || '
  ';
  execute sqlstr;

  execute ' drop table ' || nodefullname;
  execute ' alter table ' || quote_ident(schemaname) || '.'  || quote_ident(nodetablename || '_temp')  || ' rename to ' || nodetablename;

  if geoname <> '_geo' then 
    sqlstr := 'alter table ' || linefullname || ' rename _geo to ' || quote_ident(geoname) ;
    execute sqlstr;
  end if;

  return nodetablename;
end;
$$
language 'plpgsql';



-- 将linestring 转换成 arc

create or replace function sc_linestring_to_arc(
  schemaname varchar,
  linetablename varchar,
  linegeoname varchar,
  nodetablename varchar,
  nodegeoname varchar,
  arctablename varchar
) returns varchar as 
$$
declare
  sqlstr text;
  myrec1 record;
  parts float[];
  i integer;  
  srid integer;
  linefullname varchar;
  arcfullname varchar;
  nodefullname varchar;
  ret varchar;
begin
  linefullname := quote_ident(schemaname) || '.' || quote_ident(linetablename);
  arcfullname := quote_ident(schemaname) || '.' || quote_ident(arctablename);
  nodefullname := quote_ident(schemaname) || '.' || quote_ident(nodetablename);
  srid := find_srid(schemaname,linetablename, linegeoname);
  
  if linegeoname <> '_geo' then 
    sqlstr := 'alter table ' || linefullname || ' rename ' || quote_ident(linegeoname) || ' to _geo';
    execute sqlstr;
  end if;
  if nodegeoname <> '_geo' then
    sqlstr := 'alter table ' || nodefullname || ' rename ' || quote_ident(nodegeoname) || ' to _geo';
    execute sqlstr;
  end if;
  ret := sc_add_id_column(schemaname,linetablename);
  ret := sc_add_id_column(schemaname,nodetablename);

  sqlstr := '
    create table ' || arcfullname || '(
      _id varchar(32) default sc_uuid(),
      _geo geometry(LINESTRING,' || srid || ')
    )';
  execute sqlstr;

  sqlstr := '
    select 
      C._id as _id,
      array_agg(part) as parts
    from 
      (
      select 
        A._id as _id,
        ST_LineLocatePoint(A._geo,B._geo) as part
      from 
        ' || linefullname || ' A,
        ' || nodefullname || ' B
      where 
        st_intersects(A._geo,B._geo) or st_distance(A._geo, B._geo) < 0.000001
      order by 
        A._id, part
      ) C
    group by 
        C._id 
  ';
  for myrec1 in execute sqlstr loop 
    parts := myrec1.parts;
    raise notice 'parts: %',parts;
    if parts[array_length(parts,1)] < 1.0 then 
      parts := array_append(parts,1.0::float8);
    end if;
    sqlstr := '
      insert into ' || arcfullname || '(_geo) 
        select 
          st_split_linestring(_geo,' || quote_literal(parts::text) || '::float8[]) 
        from ' || linefullname || '
        where 
          _id = ' || quote_literal(myrec1._id) || '
    ';
    execute sqlstr;
  end loop;

  if linegeoname <> '_geo' then 
    sqlstr := 'alter table ' || linefullname || ' rename _geo to ' || quote_ident(linegeoname) ;
    execute sqlstr;
  end if;
  if nodegeoname <> '_geo' then 
    sqlstr := 'alter table ' || nodefullname || ' rename _geo to ' || quote_ident(nodegeoname) ;
    execute sqlstr;
  end if;

  ret := sc_remove_repeated_arcs(schemaname,arctablename,'_geo');

  return arctablename;
end;
$$
language 'plpgsql';


-- 两条线是否相等（方向相反也相等)
create or replace function sc_is_same_linestring(
  line1 geometry,
  line2 geometry
) returns boolean as 
$$
  select line1=line2 or st_reverse(line1) = line2;
$$
language 'sql';



-- 删除重复的弧段
create or replace function sc_remove_repeated_arcs(
  schemaname varchar,
  arctablename varchar,
  geoname varchar
) returns varchar as 
$$
declare
  sqlstr text;
  myrec1 record;
  myrec2 record;
  i integer;
  arcfullname varchar;
  ret varchar;
begin
  arcfullname := quote_ident(schemaname) || '.' || quote_ident(arctablename);
  sqlstr := 'alter table ' || arcfullname || ' add column haschecked boolean default false';
  execute sqlstr;

  if geoname <> '_geo' then 
    sqlstr := 'alter table ' || arcfullname || ' rename ' || quote_ident(geoname) || ' to _geo';
    execute sqlstr;
  end if;

  ret := sc_add_id_column(schemaname,arctablename);

  loop
    sqlstr := 'select _id, _geo from ' || arcfullname || ' where not haschecked limit 1';
    i :=0;
    for myrec1 in execute sqlstr loop 
      i := i+1;
      sqlstr := '
        select 
          B._id as _id
        from 
          ' || arcfullname || ' A,
          ' || arcfullname || ' B
        where 
          sc_is_same_linestring(A._geo,B._geo) 
          and 
          A._id <> B._id
          and 
          A._id = ' || quote_literal(myrec1._id);
      for myrec2 in execute sqlstr loop 
        sqlstr := 'delete from ' || arcfullname || ' where _id = ' || quote_literal(myrec2._id);
        execute sqlstr;
      end loop;

      sqlstr := 'update ' || arcfullname || ' set haschecked = true where _id=' || quote_literal(myrec1._id);
      execute sqlstr;
    end loop;
    if i = 0 then 
      exit;
    end if;
  end loop;


    if geoname <> '_geo' then 
    sqlstr := 'alter table ' || arcfullname || ' rename _geo to ' || quote_ident(geoname) ;
    execute sqlstr;
  end if;

  return 'ok';
end;
$$
language 'plpgsql';