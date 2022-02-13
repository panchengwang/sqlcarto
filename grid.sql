-- 11 参数
create or replace function sc_create_grid(
  schemaname varchar, gridname varchar, srid integer,
  minx float8, miny float8,
  nrows integer, ncols integer,
  xstep float8, ystep float8,
  startid bigint, endid bigint
) returns varchar as $$
declare
  sqlstr text;
  fullname varchar;
  firstid bigint;
  lastid bigint;
begin
  firstid := startid;
  if startid < 0 then 
    firstid := 0;
  end if;

  lastid := endid;
  if endid >= nrows * ncols then 
    lastid := nrows * ncols - 1;
  end if;

  fullname := quote_ident(schemaname) || '.' || quote_ident(gridname);
  sqlstr := '
    create table ' || fullname || '(
      _id bigint,
      _center geometry(POINT,' || srid || '),
      _geo  geometry(POLYGON,' || srid || ') 
    )';
  execute sqlstr;

  sqlstr := '
    insert into ' || fullname || '(_id) select _id from generate_series(' || firstid || ',' || lastid || ') as _id
  ';
  execute sqlstr;

  sqlstr := '
    update ' || fullname || '
    set _center=st_setsrid(st_makepoint(
      ' || minx || '+(_id - _id/ ' || ncols || '*' ||  ncols ||' +0.5)*'  || xstep || ',
      ' || miny ||  '+(_id / ' || ncols || ' + 0.5)*'|| ystep || '
    ),' || srid || ')
  ';
  execute sqlstr;

  sqlstr := '
    update ' || fullname || '
    set _geo = st_expand(_center,' || (xstep*0.5) || ',' || (ystep*0.5) || ')
  ';
  execute sqlstr;

  return gridname;
end;
$$ language 'plpgsql';


-- 10参数
create or replace function sc_create_grid(
  gridname varchar, srid integer,
  minx float8, miny float8,
  nrows integer, ncols integer,
  xstep float8, ystep float8,
  startid bigint, endid bigint
) returns varchar as
$$
  select sc_create_grid('public',$1,$2,$3,$4,$5,$6,$7,$8,$9,$10);
$$ language 'sql';



-- 6参数
create or replace function sc_create_grid(
  schemaname varchar, gridname varchar, srid integer,
  ext box2d,
  xstep float8, ystep float8
) returns varchar as 
$$
declare
  sqlstr text;
  x1 float8; x2 float8; y1 float8; y2 float8;
  myext box2d;
  nrows integer; ncols integer;
begin
  myext := st_snaptogrid(
    st_expand(
      ext,xstep*0.5, ystep*0.5
    ),
    xstep,
    ystep
  );
  x1 := st_xmin(myext); y1 := st_ymin(myext); x2 := st_xmax(myext); y2 := st_ymax(myext);
  nrows := (y2-y1)/ystep;
  ncols := (x2-x1)/xstep;
  return sc_create_grid(schemaname,gridname,srid,x1,y1,nrows,ncols,xstep,ystep,0,nrows*ncols-1);
end;
$$ language 'plpgsql';


-- 9参数
create or replace function sc_create_grid(
  schemaname varchar, gridname varchar, srid integer,
  minx float8, miny float8, 
  maxx float8, maxy float8,
  xstep float8, ystep float8
) returns varchar as $$
declare
  sqlstr text;
  x1 float8; x2 float8; y1 float8; y2 float8;
  ext geometry;
  nrows integer; ncols integer;
begin
  ext := st_snaptogrid(
    st_expand(
      st_makebox2d(st_point(minx,miny),st_point(maxx, maxy)),xstep*0.5, ystep*0.5
    ),
    xstep,
    ystep
  );
  x1 := st_xmin(ext); y1 := st_ymin(ext); x2 := st_xmax(ext); y2 := st_ymax(ext);
  nrows := (y2-y1)/ystep;
  ncols := (x2-x1)/xstep;
  return sc_create_grid(schemaname,gridname,srid,x1,y1,nrows,ncols,xstep,ystep,0,nrows*ncols-1);
end;
$$ language 'plpgsql';

select sc_create_grid('public','abc',3857,95.0,95.0,200.0,200.0,20.0,20.0);
-- drop table if exists grid_a;

-- \timing
-- select sc_create_grid(
--   'grid_a', 3857,
--   12556838,3274212,
--   1000,1000,
--   20,20,
--   0,10000-1
-- );

-- select _id, st_astext(_center) from grid_a limit 10;