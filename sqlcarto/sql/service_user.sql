create or replace function sc_captcha_is_expired(username varchar) returns boolean as 
$$
    select 
        (captcha_gen_time + captcha_valid_time < now()) 
    from 
        sc_users 
    where 
        user_name = $1
$$ language 'sql';

create or replace function sc_token_is_expired(token varchar) returns boolean as 
$$
    select 
        (token_gen_time + token_valid_time < now()) 
    from 
        sc_users 
    where 
        token = $1
$$ language 'sql';

--      {
--          "type": "USER_IF_AVAILABLE",
--          "data": {
--              "username": "email/mobile"
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
--              "username": "email/mobile"
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
            'success', true,
            'message', 'CaptCha(verification code) has been sent to ' || (request->'data'->>'username'),
            'data',''
        );  
    end if;

    return jsonb_build_object(
        'success', false,
        'message', 'Failed to send captCha(verification code)',
        'data',''
    );
    
end;
$$ language 'plpgsql';




--      {
--          "type": "USER_REGISTER",
--          "data": {
--              "username": "email/mobile",
--              "password": "",
--              "captcha": ""
--          }
--      }
delete from sc_services where request_type = 'USER_REGISTER';
insert into sc_services(request_type, function_name) values('USER_REGISTER','sc_user_register');
create or replace function sc_user_register(request jsonb) returns jsonb as 
$$
declare
    sqlstr text;
    userid varchar;
    username varchar;
    nodeid varchar;
    nodeconnstr varchar;
    dblinkid varchar;
    dblinksqlstr text;
    myrec record;
    v_result boolean;
begin
    username := (request->'data'->>'username');
    if sc_user_exist(username) and sc_user_is_activated(username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'User exist! Please select another username.',
            'data',''
        );
    end if;
    
    select ( (request->'data'->>'captcha') = captcha ) into v_result from sc_users where user_name = username;
    if (v_result is null) or (not v_result) then 
        return jsonb_build_object(
            'success', false,
            'message', 'Captcha is invalid!',
            'data',''
        );
    end if;
    if sc_captcha_is_expired(username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'Captcha expired!',
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
    update sc_users set node_id = nodeid, password=md5((request->'data'->>'password') || salt) where id = userid;
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

    dblinksqlstr := '
        create table sc_configuration_' || userid || '(
            key_name varchar(256) unique not null,
            key_value varchar(2048) default ' || quote_literal('') || '
        );
        insert into sc_configuration_' || userid || '(key_name, key_value)
            select key_name, key_value from sc_user_configuration
    ';
    perform dblink_exec(dblinkid, dblinksqlstr);


    perform dblink_disconnect(dblinkid);
    return jsonb_build_object(
        'success', true,
        'message', 'User has been created!',
        'data',''
    );
end;
$$
language 'plpgsql';


--      {
--          "type": "USER_RESET_PASSWORD",
--          "data": {
--              "username": "email/mobile",
--              "password": "",
--              "captcha": ""
--          }
--      }
delete from sc_services where request_type = 'USER_RESET_PASSWORD';
insert into sc_services(request_type, function_name) values('USER_RESET_PASSWORD','sc_user_reset_password');
create or replace function sc_user_reset_password(request jsonb) returns jsonb as 
$$
declare
    v_sqlstr text;
    v_userid varchar;
    v_username varchar;
    v_password varchar;
    v_dblinkid varchar;
    v_nodeconnstr varchar;
	v_result boolean;
begin
    v_username := (request->'data'->>'username');
    if not sc_user_exist(v_username)  then 
        return jsonb_build_object(
            'success', false,
            'message', 'User does not exist!',
            'data',''
        );
    end if;
    select ( (request->'data'->>'captcha') = captcha ) into v_result from sc_users where user_name = v_username;
    if (v_result is null) or (not v_result) then 
        return jsonb_build_object(
            'success', false,
            'message', 'Captcha is invalid!',
            'data',''
        );
    end if;
    if sc_captcha_is_expired(v_username) then 
        return jsonb_build_object(
            'success', false,
            'message', 'Captcha expired!',
            'data',''
        );
    end if;
    
    v_userid := sc_user_get_id_by_name(v_username);
    select md5( (request->'data'->>'password') || salt) into v_password from sc_users where id = v_userid;
    v_sqlstr := 'update sc_users set password = ' || quote_literal(v_password) || ' where id=' || quote_literal(v_userid);
    execute v_sqlstr;
    select ssn.db_connect_string into v_nodeconnstr from sc_server_nodes ssn, sc_users su where ssn.id = su.node_id and su.id = v_userid;
    v_dblinkid := sc_uuid();
    perform dblink_connect(v_dblinkid, v_nodeconnstr);
    perform dblink_exec(v_dblinkid, v_sqlstr );
    perform dblink_disconnect(v_dblinkid);
    return jsonb_build_object(
        'success', true,
        'message', 'Password has been reseted!',
        'data',''
    );
end;
$$
language 'plpgsql';



--      {
--          "type": "USER_SIGN_IN",
--          "data": {
--              "username": "email/mobile",
--              "password": ""
--          }
--      }
delete from sc_services where request_type = 'USER_SIGN_IN';
insert into sc_services(request_type, function_name) values('USER_SIGN_IN','sc_user_sign_in');
create or replace function sc_user_sign_in(request jsonb) returns jsonb as 
$$
declare
    v_sqlstr text;
    v_userid varchar;
    v_username varchar;
    v_password varchar;
    v_token varchar;
    v_nodeconnstr varchar;
	v_result boolean;
    v_nodeurl varchar;
	v_dblinkid varchar;
begin
    v_username := (request->'data'->>'username');
    v_userid := sc_user_get_id_by_name(v_username);
    v_password := (request->'data'->>'password');
    
	select (count(1)=1) into v_result from sc_users where user_name = v_username and password = md5(v_password || salt) ;
	if not v_result then 
		return jsonb_build_object(
            'success', false,
            'message', 'Invalid username or password!',
            'data',''
        );
	end if;
    v_token := sc_generate_code(128) || sc_uuid();
    select ssn.db_connect_string , ssn.server_url into  v_nodeconnstr, v_nodeurl from sc_server_nodes ssn, sc_users su where ssn.id = su.node_id and su.id = v_userid;
    v_dblinkid := sc_uuid();
    v_sqlstr := 'update sc_users set token=' || quote_literal(v_token) || ', token_gen_time = now() where id=' || quote_literal(v_userid); 
    perform dblink_connect(v_dblinkid, v_nodeconnstr);
    perform dblink_exec(v_dblinkid, v_sqlstr );
    perform dblink_disconnect(v_dblinkid);
    
    return jsonb_build_object(
        'success',true,
        'message','ok',
        'data',jsonb_build_object(
            'token', v_token,
            'node_url', v_nodeurl
        )
    );
end;
$$ language 'plpgsql';



--      {
--          "type": "USER_LOAD_WEB_MAP_KEYS",
--          "data": {
--              "username": "email/mobile",
--              "token": ""
--          }
--      }
delete from sc_services where request_type = 'USER_LOAD_WEB_MAP_KEYS';
insert into sc_services(request_type, function_name) values('USER_LOAD_WEB_MAP_KEYS','sc_user_load_web_map_keys');
create or replace function sc_user_load_web_map_keys(request jsonb) returns jsonb as 
$$
declare
    v_sqlstr text;
    v_userid varchar;
    v_username varchar;
    v_password varchar;
    v_token varchar;
    v_nodeconnstr varchar;
	v_result boolean;
    v_result_obj jsonb;
    v_nodeurl varchar;
	v_dblinkid varchar;
    v_myrec record;
begin
    v_username := request->'data'->>'username';
    v_token := request->'data'->>'token';
    v_userid := sc_user_get_id_by_name(v_username);
    select count(1) = 1 into v_result from sc_users where user_name = v_username and token = v_token;

    if not v_result then 
        return jsonb_build_object(
            'success', false,
            'message', 'Invalid token!',
            'data',''
        );
    end if;

    if sc_token_is_expired(v_token) then 
        return  jsonb_build_object(
            'success', false,
            'message', 'Token is expired!',
            'data',''
        );
    end if;

    update sc_users set token_gen_time = now() where id = v_userid;
    v_sqlstr := '
        select 
            jsonb_build_object(key_name, key_value) as kv
        from 
			sc_configuration_' || v_userid || ' 
		where 
			key_name in (
	            ' || quote_literal('google_key') || ',
	            ' || quote_literal('bing_key') || ',
	            ' || quote_literal('tianditu_key') || ',
	            ' || quote_literal('gaode_key') || ',
	            ' || quote_literal('gaode_password') || '
        	)
        ';
    v_result_obj := jsonb_build_object();
    for v_myrec in execute v_sqlstr loop
        v_result_obj := v_result_obj || v_myrec.kv;
    end loop;

    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data',jsonb_build_object(
            'webmapkeys', v_result_obj
        )
    );

end;
$$ language 'plpgsql';






