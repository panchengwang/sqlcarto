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


create or replace function sc_verify_code_is_expired(username varchar) returns boolean as 
$$
    select 
        (verify_code_gen_time + verify_code_valid_time < now()) 
    from 
        sc_users 
    where 
        user_name = $1
$$ language 'sql';



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
    code := sc_generate_code(6);
    if not sc_user_exist(request->'data'->>'username') then 
        perform sc_user_create(request->'data'->>'username', '',1);
    end if;

    if not sc_verify_code_is_expired(request->'data'->>'username') then 
        select verify_code into code from sc_users where user_name = (request->'data'->>'username');
        return jsonb_build_object(
            'success', true,
            'message', 'Verify code has been sent to ' || (request->'data'->>'username')
        );
    end if;

    update sc_users 
    set 
        verify_code = code,
        verify_code_gen_time = now()
    where 
        user_name = (request->'data'->>'username');

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
--              "username": ""
--          }
--      }'::jsonb
-- );


--      {
--          "type": "USER_CREATE",
--          "data": {
--              "username": "",
--              "password": "",
--              "verify_code": ""
--          }
--      }
delete from sc_services where request_type = 'USER_CREATE';
insert into sc_services(request_type, function_name) values('USER_CREATE','sc_user_create');
create or replace function sc_user_create(request jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    userid varchar;
    username varchar;
    password varchar;
begin
    username := (request->'data'->>'username');
    if sc_user_exist(username) and sc_user_is_activated(username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'User exist! Please select another username.'
        );
    end if;
    
    userid := sc_user_get_id_by_name(username);
    perform sc_user_set_activate_by_id(userid, true);
    execute 'select password from sc_users where id = ' || quote_literal(userid) into password;
    execute 'create user  sc_user_' || userid || ' password ' || quote_literal(password) ;
    execute 'create schema sc_schema_' || userid;
    execute 'alter schema sc_schema_' || userid || ' owner to sc_user_' || userid; 
    return jsonb_build_object(
        'success', true,
        'message', 'User has been created!'
    );
end;
$$
language 'plpgsql';


create or replace function sc_user_drop(username varchar) returns varchar as 
$$
declare
    userid varchar;
begin
    userid := sc_user_get_id_by_name(username);
    execute 'drop schema sc_schema_' || userid;
    execute 'drop user sc_user_' || userid;
    execute 'update sc_users set activated = false where username=' || quote_literal(username) ;
    return 'ok';
end;
$$ language 'plpgsql';
