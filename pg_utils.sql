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

select sc_get_all_partitions('public','长沙');

