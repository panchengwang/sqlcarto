-- Send mail module

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
        sc_get_configuration('EMAIL_USER'),
        $1,
        $2,
        $3,
        sc_get_configuration('EMAIL_SMTP'),
        sc_get_configuration('EMAIL_PASSWORD')
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


