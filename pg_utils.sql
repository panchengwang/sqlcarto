-- postgresql utilities
-- 获得某表的所有子表名
create or replace function sc_get_all_partitions(
  schemaname varchar,tablename varchar) 
returns setof varchar as 
$$
  select
    quote_ident(e.nspname) || '.' || quote_ident(c.relname)
  from
    pg_class c
    join pg_inherits i on i.inhrelid = c.oid
    join pg_class d on d.oid = i.inhparent
    join pg_namespace e on e.oid = d.relnamespace 
  where
    e.nspname = $1 and
    d.relname = $2;
$$
language 'sql';


create or replace function sc_has_column(
  schemaname varchar,
  tablename varchar,
  columnname varchar
) returns boolean as $$
  select 
    count(1) >=1 
  from 
    information_schema.columns
  where 
    table_schema=$1 and table_name=$2 and column_name=$3;
$$ language 'sql';


-- 给表增加一个_id字段
-- _id 字符串，长度32，uuid去掉中间的连接符
-- 如果表中已经包含_id字段，则什么也不做
create or replace function sc_add_id_column(
  schemaname varchar,
  tablename varchar
) returns varchar as $$
declare
  sqlstr text;
begin
  if sc_has_column(schemaname, tablename, '_id') then
    raise notice '%','column _id already exists!';
    return '_id';
  end if;
  sqlstr := 'alter table ' || quote_ident(schemaname) || '.' || quote_ident(tablename) || ' 
    add column _id varchar(32) default sc_uuid()';
  execute sqlstr;
  return '_id';
end;
$$ language 'plpgsql';


-- 判断某个表是否存在primary key
create or replace function sc_has_primary_key(schemaname varchar, tablename varchar) returns boolean 
as $$
  select count(1) = 1 from information_schema.key_column_usage where table_schema=$1 and table_name=$2;
$$ language 'sql';

-- 获取primary字段名
create or replace function sc_primary_key_column_name(schemaname varchar, tablename varchar) returns varchar
as $$
  select column_name from information_schema.key_column_usage where table_schema=$1 and table_name=$2 limit 1;
$$ language 'sql';

-- 判断某个字段是数字型还是非数字型
create or replace function sc_column_is_numeric(schemaname varchar, tablename varchar, columnname varchar) returns boolean 
as $$
  select 
    data_type in ('integer','smallint','bigint','double precision') 
  from 
    information_schema.columns 
  where 
    table_schema=$1
    and 
    table_name=$2
    and 
    column_name=$3;
$$ language 'sql';