/* contrib/sqlcarto/sqlcarto--1.0.sql */


\echo Use "create EXTENSION sqlcarto;" to add sqlcarto extension. \quit


create or replace function sqlcarto_info() returns json as 
$$
  select '{
      "extension" : "SQLCarto",
      "version" : "1.0",
      "author" : "pcwang",
      "qq" : "593723812"
    }'::json;
$$
language 'sql';


create or replace function sc_uuid() returns text as
$$
  select replace(gen_random_uuid()::text,'-','');
$$
language 'sql';



create or replace function sc_ensure_id(schemaname varchar, tablename varchar) returns varchar as 
$$
declare
  sqlstr text;
  myrec record;
begin
  sqlstr := '
    SELECT 
      COUNT(*) AS num 
    FROM 
      INFORMATION_SCHEMA.COLUMNS 
    WHERE 
      table_schema=' || quote_literal(schemaname) || ' 
      and 
      table_name = ' || quote_literal(tablename) || ' 
      AND 
      column_name = ' || quote_literal('__id') ;
  for myrec in execute sqlstr loop 
    if myrec.num = 0 then 
      sqlstr := 'alter table ' || quote_ident(schemaname) || '.' || quote_ident(tablename) || ' add column __id varchar(32) unique default sc_uuid()';
      execute sqlstr;
    end if;
  end loop;
  return '__id';
end;
$$
language 'plpgsql';