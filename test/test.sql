
create extension "uuid-ossp";
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
--     'XXXXXXXXXXXXX'
-- );

-- update sc_configuration set key_value = 'sqlcartotest@126.com' where key_name = 'EMAIL_USER';
-- update sc_configuration set key_value = 'smtps://smtp.126.com:465' where key_name = 'EMAIL_SMTP';
-- update sc_configuration set key_value = 'XXXXXXXXXXX' where key_name = 'EMAIL_PASSWORD';
-- select sc_send_mail(
--     'sqlcartotest@126.com',
--     '测试一下',
--     '这是另外一个从postgresql sqlcarto扩展发送过来的测试邮件'    
-- );

-- select sc_generate_code(8); 
-- select sc_generate_token(128);
-- select sc_generate_token(256);






