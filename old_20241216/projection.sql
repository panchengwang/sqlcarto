
-- 将某表中的某一几何列进行坐标转换
create or replace function sc_transform(
  schemaname varchar, tablename varchar,
  geoname varchar, destsrid integer
) returns varchar as $$
declare
  sqlstr text;
  fullname varchar;
  geotype varchar;
  tempgeoname varchar;
begin
  fullname := quote_ident(schemaname) || '.' || quote_ident(tablename);
  geotype := '';
  select type into geotype from geometry_columns where f_table_schema = schemaname and f_table_name = tablename and f_geometry_column=geoname limit 1;
  if geotype = '' then 
    raise EXCEPTION '%','Invalid geometry type';
  end if;
  tempgeoname := quote_ident('__' || geoname);
  sqlstr := 'alter table ' || fullname || ' add ' || tempgeoname || ' geometry(' || geotype || ',' || destsrid || ')';
  execute sqlstr;
  sqlstr := 'update ' || fullname || ' set ' || tempgeoname || ' = st_transform(' || quote_ident(geoname) || ',' || destsrid || ')';
  execute sqlstr;
  sqlstr := 'alter table ' || fullname || ' drop column ' || quote_ident(geoname);
  execute sqlstr;
  sqlstr := 'alter table ' || fullname || ' rename column ' || tempgeoname || ' to ' || quote_ident(geoname);
  execute sqlstr ;
  return 'ok';
end;
$$ language 'plpgsql';



create or replace function sc_transform(
  tablename varchar,
  geoname varchar, destsrid integer
) returns varchar as $$
  select sc_transform('public',$1,$2,$3);
$$ language 'sql';



create or replace function sc_setsrid(
  schemaname varchar, tablename varchar,
  geoname varchar, srid integer
) returns varchar as $$
declare
  sqlstr text;
  fullname varchar;
  geotype varchar;
  tempgeoname varchar;
begin
  fullname := quote_ident(schemaname) || '.' || quote_ident(tablename);
  geotype := '';
  select type into geotype from geometry_columns where f_table_schema = schemaname and f_table_name = tablename and f_geometry_column=geoname limit 1;
  if geotype = '' then 
    raise EXCEPTION '%','Invalid geometry type';
  end if;
  tempgeoname := quote_ident('__' || geoname);
  sqlstr := 'alter table ' || fullname || ' add ' || tempgeoname || ' geometry(' || geotype || ',' || srid || ')';
  execute sqlstr;
  sqlstr := 'update ' || fullname || ' set ' || tempgeoname || ' = st_setsrid(' || quote_ident(geoname) || ',' || srid || ')';
  execute sqlstr;
  sqlstr := 'alter table ' || fullname || ' drop column ' || quote_ident(geoname);
  execute sqlstr;
  sqlstr := 'alter table ' || fullname || ' rename column ' || tempgeoname || ' to ' || quote_ident(geoname);
  execute sqlstr ;
  return 'ok';
end;
$$ language 'plpgsql';



create or replace function sc_setsrid(
  tablename varchar,
  geoname varchar, srid integer
) returns varchar as $$
  select sc_setsrid('public',$1,$2,$3);
$$ language 'sql';