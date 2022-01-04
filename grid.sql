
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
begin
  if startid < 0 then 
    raise EXCEPTION '%','startid < 0';
  end if;

  if endid >= nrows * ncols then 
    raise EXCEPTION '%','endid too large';
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
    insert into ' || fullname || '(_id) select _id from generate_series(' || startid || ',' || endid || ') as _id
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

drop table if exists grid_a;

\timing
select sc_create_grid(
  'grid_a', 3857,
  12556838,3274212,
  1000,1000,
  20,20,
  0,1000000-1
);

select _id, st_astext(_center) from grid_a limit 10;