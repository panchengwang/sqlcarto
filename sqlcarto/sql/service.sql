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



--      {
--          "type": "USER_GET_VERIFY_CODE",
--          "data": {
--              "username": "wang_wang_lao@163.com"
--          }
--      }
insert into sc_services(request_type, function_name) values('USER_GET_VERIFY_CODE','sc_user_get_verify_code');
create or replace function sc_user_get_verify_code(request jsonb) returns jsonb as 
$$
declare
    code varchar;
begin
    
    return '{"a":1}'::jsonb;
end;
$$ language 'plpgsql';

select sc_service_run(
    '{
         "type": "USER_GET_VERIFY_CODE",
         "data": {
             "username": "wang_wang_lao@163.com"
         }
     }'::jsonb
);

-- create or replace function sc_user_create(request jsonb) returns jsonb as 
-- $$
-- declare
-- begin
-- end;
-- $$ language 'plpgsql';
