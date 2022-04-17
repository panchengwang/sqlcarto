-- 从线表生成polygon表
-- create or replace function sc_linestring_to_polygon(
--   schemaname varchar,
--   linetablename varchar,
--   linegeoname varchar,
--   polygontablename varchar,
--   polygongeoname varchar
-- ) returns varchar as $$
-- declare
--   sqlstr text;
--   linefullname varchar;
--   polygonfullname varchar;
--   toponame varchar;
--   tableid varchar;
--   ret varchar;
--   srid integer;
-- begin
--   linefullname := quote_ident(schemaname) || '.' || quote_ident(linetablename);
--   polygonfullname := quote_ident(schemaname) || '.' || quote_ident(polygontablename);
--   tableid := sc_uuid();
--   ret := sc_node_from_linestrings(schemaname,linetablename,linegeoname,'node_' || tableid);
--   raise notice 'node from linestrings: node_%',tableid;
--   sqlstr := 'update ' || quote_ident(schemaname) || '.' || quote_ident('node_' || tableid) || ' set _geo = st_snaptogrid(_geo,0.000001)';
--   execute sqlstr;

--   ret := sc_linestring_to_arc(schemaname,linetablename,linegeoname,'node_' || tableid, '_geo', 'arc_'||tableid);
--   raise notice 'linestring to arc: arc_%',tableid;
--   execute 'drop table ' || quote_ident(schemaname) || '.' || quote_ident('node_' || tableid);
  
--   srid := find_srid(schemaname,linetablename,linegeoname);

--   -- 下面这一句非常重要。由于浮点数运算的问题，会导致节点和弧段之间的运算产生：节点不在弧段、弧段穿越了节点等异常情况。
--   -- 采用st_snaptogrid将节点对齐到格网上，可以解决这些异常问题。
--   sqlstr := 'update ' || quote_ident(schemaname) || '.' || quote_ident('arc_' || tableid) || ' set _geo = st_snaptogrid(_geo,0.000001)';
--   execute sqlstr;
--   execute 'delete from ' || quote_ident(schemaname) || '.' || quote_ident('arc_' || tableid ) || ' where _geo is null or st_isempty(_geo)';

--   toponame := 'topo_' || tableid;
--   execute 'select topology.CreateTopology(' || quote_literal(toponame) || ',' || srid || ',0.000001)';
--   execute 'select topogeo_addlinestring(' || quote_literal(toponame) || ',_geo,0.000001) from ' ||  quote_ident(schemaname) || '.' || quote_ident('arc_' || tableid);
--   -- 注意：千万不要用下面这一句，害苦我了
--   -- execute 'select topology.addedge(' || quote_literal(toponame) || ',_geo) from ' ||  quote_ident(schemaname) || '.' || quote_ident('arc_' || tableid);
--   sqlstr := '
--     select topology.Polygonize(' || quote_literal(toponame) || ')
--   ';
--   execute sqlstr;

--   sqlstr := 'create table ' || polygonfullname || '(
--       _id varchar(32) primary key default sc_uuid(),
--       _geo geometry(POLYGON,' || srid || ')
--     )';
--   execute sqlstr;
--   -- raise notice 'sqlstr: %', sqlstr;
--   -- raise notice 'srid: %', srid;

--   sqlstr := '
--     insert into ' || polygonfullname || '(_geo)
--       select topology.st_getfacegeometry(' || quote_literal(toponame) || ',face_id) as _geo from ' || quote_ident(toponame) || '.face where face_id <> 0
--   ';
--   execute sqlstr;

--   execute 'drop table ' || quote_ident(schemaname) || '.' || quote_ident('arc_' || tableid);
--   execute 'select topology.droptopology(' || quote_literal(toponame) || ')';
--   return toponame;
-- end;
-- $$ language 'plpgsql';

-- 从线表生成多边形表
--  线表中的线不要求是弧段
--  此函数会自行求交点、打断线、生成弧段，最后进行拓扑构建，从拓扑生成最终的多边形表
--    schema_name 
--    line_table_name 
--    line_geo_name 
--    polygon_table_name 
--    polygon_geo_name 
create or replace function sc_linestring_to_polygon(
  schema_name varchar,
  line_table_name varchar,
  line_geo_name varchar,
  polygon_table_name varchar,
  polygon_geo_name varchar
) returns varchar as 
$$
declare
  topo_name varchar;
  node_table_name varchar;
  arc_table_name varchar;
  srid integer;
  sqlstr text;
begin
  srid := find_srid(schema_name,line_table_name, line_geo_name);

  --  线求交，生成节点
  perform sc_node_from_linestrings(schema_name,line_table_name,line_geo_name,node_table_name,'geom');
  --  从线表和节点表生成弧段
  perform sc_linestring_to_arc(schema_name,line_table_name,line_geo_nam,node_table_name,'geom',arc_table_name,'geom');
  

  topo_name := 't_' || sc_uuid() || '_topo';
  perform topology.CreateTopology(topo_name,srid,0.000001);
  sqlstr := '
    select topogeo_addlinestring(' || quote_literal(topo_name) || ',geom,0.000001) from ' || quote_ident(arc_table_name) || ' where geom is not null
  ';
  execute sqlstr;
  perform topology.Polygonize(topo_name);


  sqlstr := 'create table ' || quote_ident(schema_name) || '.' || quote_ident(polygon_table_name) || '(
      id varchar(32) primary key default sc_uuid(),
      ' || quote_ident(polygon_geo_name) || ' geometry(POLYGON,' || srid || ')
    )';
  execute sqlstr;
  sqlstr := 'insert into ' || quote_ident(schema_name) || '.' || quote_ident(polygon_table_name) || '(' || quote_ident(polygon_geo_name) || ')
      select topology.st_getfacegeometry(' || quote_literal(topo_name) || ',face_id) as _geo 
      from ' || quote_ident(topo_name) || '.face where face_id <> 0';
  execute sqlstr;
  perform topology.dropTopology(toponame);
  return polygon_table_name;
end;
$$ language 'plpgsql';




-- 从线表生成节点表
-- 参数：
--    schemaname
--    linetablename 线表名
--    geoname 线字段名
--    nodetablename 节点表名
--    nodegeoname 节点几何字段名
create or replace function sc_node_from_linestrings(
  schemaname varchar,
  linetablename varchar,
  geoname varchar,
  nodetablename varchar,
  nodegeoname varchar
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
    _id varchar(32) primary key default sc_uuid(),
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

  if nodegeoname <> '_geo' then
    sqlstr := 'alter table ' || nodetablename || ' rename column _geo to ' || quote_ident(nodegeoname);
    execute sqlstr;
  end if;

  execute 'create index ' || quote_ident(nodetablename || '_geo_idx') || '
     on ' || quote_ident(schemaname) || '.'  || quote_ident(nodetablename) || ' using gist(' || quote_ident(nodegeoname) || ')';

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
  arctablename varchar,
  arcgeoname varchar
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
  arc_id1 varchar; arc_id2 varchar;
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
      _id varchar(32) primary key default sc_uuid(),
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
        st_intersects(A._geo,B._geo) ' || 
        ' or st_distance(A._geo, B._geo) < 0.000001 ' || 
      'order by 
        A._id, part
      ) C
    group by 
        C._id 
  ';
  for myrec1 in execute sqlstr loop 
    parts := myrec1.parts;
    -- raise notice 'parts: %',parts;
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

  ret := sc_remove_repeated_arcs(schemaname,arctablename,'_geo');

-- 将假弧段（如1结点对应2弧段，则应该删除这个几点，并将2弧段连接起来）
  sqlstr := '
    with node_arc as
    (
      select
        B._id as node_id,
        A._id as arc_id
      from 
        ' || arcfullname || ' A,
        ' || nodefullname || ' B
      where
        st_startpoint(A._geo) = B._geo 
        or 
        st_endpoint(A._geo) = B._geo
    ), node_arc_num as (
      select
        node_id,
        count(1) as num
      from 
        node_arc
      group by node_id
    )
    select 
      A.node_id,
      array_agg(A.arc_id) as arc_ids
    from 
      node_arc A,
      node_arc_num B
    where 
      B.num = 2
      and 
      A.node_id = B.node_id
    group by A.node_id;
  ';

  for myrec1 in execute sqlstr loop 
    sqlstr := 'insert into ' || arcfullname || '(_geo) 
      select st_linemerge(st_union(_geo)) from ' || arcfullname || ' 
      where _id = any(' || quote_literal(myrec1.arc_ids) || '::varchar[])';
    execute sqlstr;
    sqlstr := 'delete from ' || arcfullname || '
      where _id = any(' || quote_literal(myrec1.arc_ids) || '::varchar[]) 
    ';
    execute sqlstr;
  end loop;


  if linegeoname <> '_geo' then 
    sqlstr := 'alter table ' || linefullname || ' rename column _geo to ' || quote_ident(linegeoname) ;
    execute sqlstr;
  end if;
  if nodegeoname <> '_geo' then 
    sqlstr := 'alter table ' || nodefullname || ' rename column _geo to ' || quote_ident(nodegeoname) ;
    execute sqlstr;
  end if;
  if arcgeoname <> '_geo' then 
    sqlstr := 'alter table ' || arcfullname || ' rename column _geo to ' || quote_ident(arcgeoname);
    execute sqlstr;
  end if;

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