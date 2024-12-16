
create extension postgis;
create extension postgis_sfcgal;
create extension postgis_sqlcarto;

-- SET client_encoding to 'utf8';
-- select sqlcarto_info();
-- select sqlcarto_version();
-- select sc_uuid();


-- select '测试邮件发送模块';
-- select sc_send_mail(
--     'sqlcartotest@126.com',
--     'sqlcartotest@126.com',
--     '测试一下',
--     '这是一个从postgresql sqlcarto扩展发送过来的测试邮件',
--     'smtps://smtp.126.com:465',
--     'SCUGOXHGWAEZUEQH'
-- );

-- update sc_configuration set key_value = 'sqlcartotest@126.com' where key_name = 'EMAIL_USER';
-- update sc_configuration set key_value = 'smtps://smtp.126.com:465' where key_name = 'EMAIL_SMTP';
-- update sc_configuration set key_value = 'SCUGOXHGWAEZUEQH' where key_name = 'EMAIL_PASSWORD';
-- select sc_send_mail(
--     'sqlcartotest@126.com',
--     '测试一下',
--     '这是另外一个从postgresql sqlcarto扩展发送过来的测试邮件'    
-- );

-- select sc_generate_code(8); 
-- select sc_generate_token(128);
-- select sc_generate_token(256);


-- create or replace function test_sqlcarto() returns text as 
-- $$
-- declare
--     maphandler text;
-- begin
--     maphandler := sc_canvas_create();
--     raise notice '%',maphandler;
--     maphandler := sc_canvas_draw_geometry(maphandler,'POINT(0 0)'::geometry);
--     maphandler := sc_canvas_save_to_file(maphandler, 'e:/abc.png','png');
--     maphandler := sc_canvas_destroy(maphandler);
--     return 'Has been destroyed';
-- end;
-- $$ LANGUAGE 'plpgsql';


-- \timing
-- select test_sqlcarto();
-- \timing
