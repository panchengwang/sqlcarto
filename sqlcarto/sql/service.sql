--

create table sc_services(
    id varchar(32) default sc_uuid() not null,
    request_type varchar unique not null,
    function_name varchar unique not null
    --,need_privilege_check boolean not null default true
);

--
--  request:
--      {
--          "type": "<request_type>",
--          "data": {
--              
--          }
--      }
create or replace function sc_service_run(request jsonb) returns jsonb as 
$$
declare
    typestr varchar;
    funcname varchar;
    sqlstr text;
    myrec record;
    response jsonb;
begin
    typestr := request->>'type';
    select function_name into funcname from sc_services where request_type = request->>'type';
    sqlstr := 'select ' || funcname || '(' || quote_literal(request::text) || '::jsonb)';
    execute sqlstr into response; 
    return response;
end;
$$ language 'plpgsql';






-- create or replace function sc_catalog_create_for_user(username varchar) returns varchar as 
-- $$
-- declare
--     userid varchar;
--     sqlstr text;
-- begin
--     userid := sc_user_get_id_by_name(username);
    
--     sqlstr := 'create table sc_schema_' || userid || '.sc_catalog_' || userid || '(
--         id varchar(32) primary key,
--         parent_id varchar(32) not null default ' || quote_literal('0') || ',
--         name varchar(256) not null default ' || quote_literal('unnamed') || ',
--         type integer default 0
--     )';
--     return 'ok';
-- end;
-- $$ language 'plpgsql';


-- create or replace function sc_user_drop(username varchar) returns varchar as 
-- $$
-- declare
--     userid varchar;
-- begin
--     userid := sc_user_get_id_by_name(username);
--     execute 'drop schema sc_schema_' || userid || ' cascade';
--     execute 'update sc_users set activated = false where user_name=' || quote_literal(username) ;
--     execute 'revoke select on sc_users from sc_user_' || userid;
--     execute 'revoke select on sc_server_nodes from sc_user_' || userid;
--     execute 'drop user sc_user_' || userid;
--     return 'ok';
-- end;
-- $$ language 'plpgsql';
