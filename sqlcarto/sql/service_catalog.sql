


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
    '; 
	for v_myrec in execute v_sqlstr loop 
        if v_myrec.type_id = 0 or v_myrec.type_id = 1 or v_myrec.type_id = 2 then 
            v_child := jsonb_build_object(
                'id', v_myrec.id,
                'parent_id',v_myrec.parent_id,
                'name', v_myrec.name,
                'layer_type', v_myrec.type,
                'children',sc_catalog_get_children(v_userid, v_myrec.id)
            );
        else 
            v_child := jsonb_build_object(
                'id', v_myrec.id,
                'parent_id',v_myrec.parent_id,
                'name', v_myrec.name,
                'layer_type', v_myrec.type
            );
        end if;
        v_children := v_children || v_child;
    end loop;
    return v_children;
end;
$$ language 'plpgsql';




--      {
--          "type": "CATALOG_GET_CHILDREN",
--          "data": {
--              "username": "email/mobile",
--              "token": "",
--              "parent_id": "0"
--          }
--      }

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

