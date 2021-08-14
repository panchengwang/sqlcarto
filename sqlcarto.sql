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

