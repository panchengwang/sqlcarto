create or replace function sc_captcha_is_expired(username varchar) returns boolean as 
$$
    select 
        (captcha_gen_time + captcha_valid_time < now()) 
    from 
        sc_users 
    where 
        user_name = $1
$$ language 'sql';



--      {
--          "type": "USER_IF_AVAILABLE",
--          "data": {
--              "username": "wang_wang_lao@163.com"
--          }
--      }
delete from sc_services where request_type = 'USER_IF_AVAILABLE';
insert into sc_services(request_type, function_name) values('USER_IF_AVAILABLE','sc_user_if_available');
create or replace function sc_user_if_available(request jsonb) returns jsonb as $$
declare
    available boolean;
    ret jsonb;
begin
    available := sc_user_available(request->'data'->>'username');
    ret := jsonb_build_object(
        'success',true,
        'message','username: ' || (request->'data'->>'username') || ' exist, choose another username  !',
        'data',jsonb_build_object(
            'exist',available
        )
    );
    if available then 
        ret := jsonb_build_object(
        'success',true,
        'message','username: ' || (request->'data'->>'username') || ' available!',
        'data',jsonb_build_object(
            'exist',available
        )
    );
    end if;
    return ret;
end;
$$ language 'plpgsql';


--      {
--          "type": "USER_GET_CAPTCHA",
--          "data": {
--              "username": "wang_wang_lao@163.com"
--          }
--      }
delete from sc_services where request_type = 'USER_GET_CAPTCHA';
insert into sc_services(request_type, function_name) values('USER_GET_CAPTCHA','sc_user_get_captcha');
create or replace function sc_user_get_captcha(request jsonb) returns jsonb as 
$$
declare
    code varchar;
    ok boolean;
begin
    code := sc_generate_code(6);
    if not sc_user_exist(request->'data'->>'username') then 
        perform sc_user_create(request->'data'->>'username', '',1);
    end if;

    if not sc_captcha_is_expired(request->'data'->>'username') then 
        -- select captcha into code from sc_users where user_name = (request->'data'->>'username');
        return jsonb_build_object(
            'success', true,
            'message', 'Captcha(verification code) has been sent to ' || (request->'data'->>'username'),
            'data',''
        );
    end if;

    update sc_users 
    set 
        captcha = code,
        captcha_gen_time = now()
    where 
        user_name = (request->'data'->>'username');

    ok := sc_send_mail( request->'data'->>'username', 'captcha(verification code)', code ) ;
    if ok then 
        return jsonb_build_object(
            'success', ok,
            'message', 'CaptCha(verification code) has been sent to ' || (request->'data'->>'username'),
            'data',''
        );  
    end if;

    return jsonb_build_object(
        'success', ok,
        'message', 'Failed to send captCha(verification code)',
        'data',''
    );
    
end;
$$ language 'plpgsql';





delete from sc_services where request_type = 'USER_REGISTER';
insert into sc_services(request_type, function_name) values('USER_REGISTER','sc_user_register');
create or replace function sc_user_register(request jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    userid varchar;
    username varchar;
    dbname varchar;
    nodeid varchar;
    nodeconnstr varchar;
    dblinkid varchar;
    dblinksqlstr text;
    myrec record;
begin
    username := (request->'data'->>'username');
    if sc_user_exist(username) and sc_user_is_activated(username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'User exist! Please select another username.',
            'data',''
        );
    end if;
    nodeid := sc_get_available_node();
    if nodeid = '' then 
        return jsonb_build_object(
            'success', false,
            'message', 'Can not create user (no available node)! Please contact the administrator',
            'data',''
        );
    end if;

    userid := sc_user_get_id_by_name(username);
    perform sc_user_set_activate_by_id(userid, true);
    update sc_users set node_id = nodeid where id = userid;
    update sc_server_nodes set user_count = user_count + 1 where id = nodeid;
    select db_connect_string into nodeconnstr from sc_server_nodes where id = nodeid;
    dblinkid := sc_uuid();
    perform dblink_connect(dblinkid, nodeconnstr);
    
    select 
        'insert into sc_users(id,node_id,user_name, password,user_type,salt,activated,db_size,create_time) values(' || 
            quote_literal(id) || ',' ||
            quote_literal(node_id) || ',' ||
            quote_literal(user_name) || ',' ||
            quote_literal("password") || ',' ||
            user_type || ',' ||
            quote_literal(salt) || ',' ||
            activated || ',' ||
            db_size || ',' ||                         
            quote_literal(create_time) || '::timestamp' 
        || ')'
        into dblinksqlstr
    from 
        sc_users 
    where 
        id = userid;
    perform dblink_exec(dblinkid,dblinksqlstr);

    dblinksqlstr := '
        create table sc_catalog_' || userid || '(
            id varchar(32) primary key,
            parent_id varchar(32) not null,
            name varchar(64) default ' || quote_literal('unnamed') || ',
            layer_type integer default 0,
            srid integer default 0,
            create_time timestamp default NOW(),
            last_time timestamp default now()
        )
    ';
    perform dblink_exec(dblinkid,dblinksqlstr);


    perform dblink_disconnect(dblinkid);
    return jsonb_build_object(
        'success', true,
        'message', 'User has been created!',
        'data',''
    );
end;
$$
language 'plpgsql';


delete from sc_services where request_type = 'USER_RESET_PASSWORD';
insert into sc_services(request_type, function_name) values('USER_RESET_PASSWORD','sc_user_reset_password');
create or replace function sc_user_reset_password(request jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    userid varchar;
    username varchar;
    password varchar;
    dbname varchar;
begin
    username := (request->'data'->>'username');
    if sc_user_exist(username) and sc_user_is_activated(username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'User exist! Please select another username.',
            'data',''
        );
    end if;
    
    userid := sc_user_get_id_by_name(username);
    perform sc_user_set_activate_by_id(userid, true);
    -- dbname := 'sc_db_' || userid;
    -- execute 'select password from sc_users where id = ' || quote_literal(userid) into password;
    -- execute 'create user  sc_user_' || userid || ' password ' || quote_literal(password) ;
    -- execute 'create database ' || dbname;
    -- execute 'alter database ' || dbname || ' owner to sc_user_' || userid;
    -- execute 'grand all on database ' || dbname || ' to sc_user_' || userid;
    -- execute 'select password from sc_users where id = ' || quote_literal(userid) into password;
    -- execute 'create user  sc_user_' || userid || ' password ' || quote_literal(password) ;
    -- execute 'create schema sc_schema_' || userid;
    -- execute 'alter schema sc_schema_' || userid || ' owner to sc_user_' || userid; 
    -- execute 'grant select on sc_users to sc_user_' || userid;
    -- execute 'grant select on sc_server_nodes to sc_user_' || userid;
    return jsonb_build_object(
        'success', true,
        'message', 'User has been created!',
        'data',''
    );
end;
$$
language 'plpgsql';