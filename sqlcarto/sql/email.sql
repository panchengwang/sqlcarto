-- Send mail module


-- Sqlcarto email configuration  
create table sc_email_configuration(
    key_name varchar primary key,
    key_value varchar default '',
    description varchar default '' not null
);
insert into sc_email_configuration(key_name,key_value, description)
values
    ('EMAIL_USER','sqlcartotest@126.com','email of sender'),
    ('EMAIL_PASSWORD','SCUGOXHGWAEZUEQH','email password'),
    ('EMAIL_SMTP','smtps://smtp.126.com:465','smtp server');
-- values
--     ('EMAIL_USER','','email of sender'),
--     ('EMAIL_PASSWORD','','email password'),
--     ('EMAIL_SMTP','','smtp server');
--     'sqlcartotest@126.com',
--     'sqlcartotest@126.com',
--     '测试一下',
--     '这是一个从postgresql sqlcarto扩展发送过来的测试邮件',
--     'smtps://smtp.126.com:465',
--     'SCUGOXHGWAEZUEQH'




--  Function    :   sc_get_email_configuration
--                  Get configuration of a key.
--  Parameter   :  
--                  keyname     
--  Result      :   Configuration of a key. 
create or replace function sc_get_email_configuration(kename varchar) returns varchar as
$$
    select key_value from sc_email_configuration where key_name = $1;
$$ language 'sql';



-- Function     :  sc_send_mail
-- Parameters   :   
--      sender      email address of sender
--      reciever    email address of reciver
--      title       email title
--      content     email content
--      smtp        smtp server
--      password    password of sender email
--                  Notes: Sometimes the password is not the password to login the email.
--                      For example, to send a email, 126,163 smtp server request a special password which is notified when the smtp email sending service was configured.
create or replace function sc_send_mail(
    sender varchar, 
    reciever varchar, 
    subject varchar, 
    content text,
    smtp varchar,
    password varchar
) 
returns boolean 
AS 'MODULE_PATHNAME','sc_send_mail'
LANGUAGE C IMMUTABLE STRICT;


-- 函数：sc_send_mail
-- 参数:    reciever 接收者信箱
--          title 邮件标题
--          content 邮件内容
create or replace function sc_send_mail(
    reciever varchar, 
    subject varchar, 
    content text
) 
returns boolean AS 
$$
    select sc_send_mail(
        sc_get_email_configuration('EMAIL_USER'),
        $1,
        $2,
        $3,
        sc_get_email_configuration('EMAIL_SMTP'),
        sc_get_email_configuration('EMAIL_PASSWORD')
    );
$$ language 'sql';



create or replace function sc_send_email(
    sender varchar, 
    reciever varchar, 
    subject varchar, 
    content text,
    smtp varchar,
    password varchar
) 
returns boolean AS
$$
    select sc_send_mail($1,$2,$3,$4,$5,$6);
$$ LANGUAGE 'sql';


create or replace function sc_send_email(
    reciever varchar, 
    subject varchar, 
    content text
) 
returns boolean AS
$$
    select sc_send_mail($1,$2,$3);
$$ LANGUAGE 'sql';

