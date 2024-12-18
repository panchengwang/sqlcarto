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
    ok boolean;
begin
    code := sc_generate_code(8);
    if not sc_user_exist(request->'data'->>'username') then 
        perform sc_user_create(request->'data'->>'username', '',1);
    end if;
    update sc_users set verify_code = code where username = (request->'data'->>'username');
    ok := sc_send_mail( request->'data'->>'username', 'verify code', code ) ;
    if ok then 
        return jsonb_build_object(
            'success', ok,
            'message', 'Verify code has been sent to ' || (request->'data'->>'username')
        );  
    end if;

    return jsonb_build_object(
        'success', ok,
        'message', 'Failed to send verify code'
    );
    
end;
$$ language 'plpgsql';

-- select sc_service_run(
--     '{
--          "type": "USER_GET_VERIFY_CODE",
--          "data": {
--              "username": "wang_wang_lao@163.com"
--          }
--      }'::jsonb
-- );

