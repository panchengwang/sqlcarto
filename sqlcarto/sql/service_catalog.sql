
create or replace function sc_catalog_get_children(v_userid varchar, v_parent_id varchar) returns jsonb as 
$$
declare
    v_sqlstr text;
    v_myrec record;
    v_children jsonb;
    v_child jsonb;
begin
    v_children := jsonb_build_array();
    v_sqlstr := '
        select 
            A.id, A.parent_id, A.name, A.type as type_id,  B.name as type 
        from 
            ' || quote_ident('sc_catalog_' || v_userid) || ' A , 
            sc_layer_types B 
        where 
            A.type = B.id
			and
			A.parent_id = ' || quote_literal(v_parent_id) || '
        order by
            A.name
    '; 
	for v_myrec in execute v_sqlstr loop 
        if v_myrec.type_id = 0 or v_myrec.type_id = 1 or v_myrec.type_id = 2 then 
            v_child := jsonb_build_object(
                'id', v_myrec.id,
                'parent_id',v_myrec.parent_id,
                'name', v_myrec.name,
                'type', v_myrec.type,
                'children',sc_catalog_get_children(v_userid, v_myrec.id)
            );
        else 
            v_child := jsonb_build_object(
                'id', v_myrec.id,
                'parent_id',v_myrec.parent_id,
                'name', v_myrec.name,
                'type', v_myrec.type
            );
        end if;
        v_children := v_children || v_child;
    end loop;
    return v_children;
end;
$$ language 'plpgsql';



-- Request:
-- {
--     "type":"CATALOG_GET_CHILDREN",
--     "data":{
--         "username":"email/mobile",
--         "token":"SpRWEn52DL4uigC6VLD..."
--         "parent_id":"0",
--     }
-- }
-- Response:
-- {
--     "success":true,
--     "message":"ok",
--     "data":{
--         "children":[{
--             "id":"6f4f5cf4734c412ebb0d444da9b07207",
--             "name":"SQLCarto DB",
--             "type":"ROOT",
--             "children":[],
--             "parent_id":"0"
--         }]
--     }
-- }
delete from sc_services where request_type = 'CATALOG_GET_CHILDREN';
insert into sc_services(request_type, function_name) values('CATALOG_GET_CHILDREN','sc_catalog_get_children');
create or replace function sc_catalog_get_children(request jsonb) returns jsonb as 
$$
declare
    v_result_obj jsonb;
    v_username varchar;
    v_token varchar;
    v_parent_id varchar;
    v_children jsonb;
begin
    v_username := request->'data'->>'username';
    v_token := request->'data'->>'token';
    v_result_obj := sc_user_check_token(v_username, v_token);
    if not (v_result_obj->>'success')::boolean then 
        return v_result_obj;
    end if;
    v_parent_id := request->'data'->>'parent_id';
    if v_parent_id is null then 
        v_parent_id := '0';
    end if;
    v_children := sc_catalog_get_children(sc_user_get_id_by_name(v_username), v_parent_id);
    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data', jsonb_build_object(
            'children', v_children
        )
    );
end;
$$ language 'plpgsql';






create or replace function sc_catalog_exists(v_user_id varchar, v_parent_id varchar, v_name varchar) returns boolean as 
$$
declare
    v_sqlstr text;
    v_catalog_table_name varchar;
    v_result_bool boolean;
begin
    v_catalog_table_name := quote_ident('sc_catalog_' || v_user_id);
    v_sqlstr := 'select count(1) <> 0 from ' || v_catalog_table_name || ' where parent_id =' || quote_literal(v_parent_id) || ' and  name=' || quote_literal(v_name);
    execute v_sqlstr into v_result_bool;
    return v_result_bool;
end;
$$ language 'plpgsql';


-- Request:
-- {
--     "type":"CATALOG_CREATE_FOLDER",
--     "data":{
--         "username":"email/mobile",
--         "token":"SpRWEn52DL4uigC6VLD..."
--         "parent_id":"0",
--         "folder": "folder name"
--     }
-- }
-- Response:
-- {
--     "success":true,
--     "message":"ok",
--     "data":{
--         "children":[{
--             "id":"id",
--             "name":"folder name",
--             "type":"FOLDER",
--             "children":[],
--             "parent_id":"0"
--         }]
--     }
-- }
delete from sc_services where request_type = 'CATALOG_CREATE_FOLDER';
insert into sc_services(request_type, function_name) values('CATALOG_CREATE_FOLDER','sc_catalog_create_folder');
create or replace function sc_catalog_create_folder(request jsonb) returns jsonb as 
$$
declare
    v_result_obj jsonb;
    v_user_name varchar;
    v_token varchar;
    v_parent_id varchar;
    v_children jsonb;
    v_user_id varchar;
    v_folder_id varchar;
    v_sqlstr text;
begin
    v_user_name := request->'data'->>'username';
    v_token := request->'data'->>'token';
    v_result_obj := sc_user_check_token(v_user_name, v_token);
    if not (v_result_obj->>'success')::boolean then 
        return v_result_obj;
    end if;
    v_parent_id := request->'data'->>'parent_id';
    
    if v_parent_id is null then 
        v_parent_id := '0';
    end if;

    v_user_id := sc_user_get_id_by_name(v_user_name);
    if sc_catalog_exists(v_user_id, v_parent_id, request->'data'->>'folder') then 
        return jsonb_build_object(
            'success', false,
            'message', 'folder: ' || quote_literal(request->'data'->>'folder') || ' exists!',
            'data', jsonb_build_object()
        );
    end if;
    v_folder_id := sc_uuid();


    v_sqlstr := 'insert into ' || quote_ident('sc_catalog_' || v_user_id ) || '(id, parent_id, name, type) values(
        ' || quote_literal(v_folder_id) || ',
        ' || quote_literal(v_parent_id) || ',
        ' || quote_literal(request->'data'->>'folder') || ',
        1
    )';
    execute v_sqlstr;

    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data',jsonb_build_object(
                    'id', v_folder_id,
                    'parent_id', v_parent_id,
                    'name', (request->'data'->>'folder'),
                    'type', 'FOLDER',
                    'children',jsonb_build_array()
                )
    );
end;
$$ language 'plpgsql';





create or replace function sc_catalog_delete(v_user_id varchar, v_id varchar) returns boolean as 
$$
declare
    v_user_name varchar;
    v_type integer;
    v_sqlstr text;
	v_catalog_table_name varchar;
	v_record record;
	v_result_bool boolean;
begin
	
    select A.user_name into v_user_name from sc_users as A where A.id = v_user_id; 
    v_catalog_table_name := quote_ident('sc_catalog_' || v_user_id );
	v_sqlstr := 'select type from ' || v_catalog_table_name || ' where id=' || quote_literal(v_id);
	execute v_sqlstr into v_type;

	if v_type = 0 then 	-- do not delete root node
		return false;
	end if;

	-- if has child , delete recurse
	if v_type = 1 or v_type = 2 then 
		v_sqlstr := 'select id from ' || v_catalog_table_name || ' where parent_id=' || quote_literal(v_id);
		for v_record in execute v_sqlstr loop
			v_result_bool := sc_catalog_delete(v_user_id, v_record.id);
			if not v_result_bool then 
				return false;
			end if;
		end loop;	
	end if;

	v_sqlstr := 'delete from ' || v_catalog_table_name || ' where id=' || quote_literal(v_id);
	execute v_sqlstr;

    return true;
end;
$$ language 'plpgsql';




-- Request:
-- {
--     "type":"CATALOG_DELETE_FOLDER",
--     "data":{
--         "token":"SpRWEn52DL4uigC6VLD..."
--         "id":"0"
--     }
-- }
-- Response:
-- {
--     "success":true,
--     "message":"ok",
--     "data":{
--     }
-- }
delete from sc_services where request_type = 'CATALOG_DELETE_FOLDER';
insert into sc_services(request_type, function_name) values('CATALOG_DELETE_FOLDER','sc_catalog_delete_folder');
create or replace function sc_catalog_delete_folder(request jsonb) returns jsonb as 
$$
declare
    v_result_obj jsonb;
    v_user_name varchar;
    v_token varchar;
    v_user_id varchar;
    v_folder_id varchar;
    v_sqlstr text;
begin
    v_token := request->'data'->>'token';
    select id,user_name into v_user_id,v_user_name from sc_users where token=v_token;
    v_result_obj := sc_user_check_token(v_user_name, v_token);
    if not (v_result_obj->>'success')::boolean then 
        return v_result_obj;
    end if;
    v_folder_id := request->'data'->>'id';
    

    
    perform sc_catalog_delete(v_user_id, v_folder_id);

    return jsonb_build_object(
        'success', true,
        'message', 'ok',
        'data',jsonb_build_object(      
        )
    );
end;
$$ language 'plpgsql';


