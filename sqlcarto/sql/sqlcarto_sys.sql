---------------------------------------------------------------------------
--
-- SQLCarto - 
-- Authors:
--      Pancheng Wang           sqlcarto@163.com
---------------------------------------------------------------------------

--
-- 
--

#include "../postgis/sqldefines.h"

-- INSTALL VERSION: POSTGIS_LIB_VERSION


--  Function    :   sqlcarto_info
--  Parameter   :  
--  Result      :   The basic infomartion of sqlcarto: version, authors and contact ways.  
create or replace function sqlcarto_info() returns json as 
$$
  select '{
      "extension" : "SQLCarto",
      "version" : "1.0",
      "authors" : ["pcwang","Pancheng Wang","wang_wang_lao","麓山老将"],
      "email": "sqlcarto@163.com"
    }'::json;
$$
language 'sql';




--  Function    :   sqlcarto_version
--  Parameter   :  
--  Result      :   Same as sqlcarto_info.  
create or replace function sqlcarto_version() returns json as 
$$
  select sqlcarto_info();
$$
language 'sql';




--  Function    :   sqlcarto_version
--                  Get rid of character "-" of a uuid.
--  Parameter   :  
--  Result      :   A uuid like string which is remove character "-" of the uuid.  
create or replace function sc_uuid() returns text as
$$
  select replace(gen_random_uuid()::text,'-','');
$$
language 'sql';





-- Sqlcarto configuration table 
create table sc_configuration(
    key_name varchar primary key,
    key_value varchar default '',
    description varchar default '' not null
);
insert into sc_configuration(key_name,key_value, description)
values
    ('EMAIL_USER','','email of sender'),
    ('EMAIL_PASSWORD','','email password'),
    ('EMAIL_SMTP','','smtp server');





--  Function    :   sc_get_configuration
--                  Get configuration of a key.
--  Parameter   :  
--                  keyname     
--  Result      :   Configuration of a key. 
create or replace function sc_get_configuration(kename varchar) returns varchar as
$$
    select key_value from sc_configuration where key_name = $1;
$$ language 'sql';




--  Function    :   sc_generate_random_string
--                  Create a random string which character must be contained in some special character set.
--                  The len of the random string is specified by len.
--  Parameter   :  
--                  seedstr     The character set used to generate a random string.
--                  len         Length of random string.      
--  Result      :   A random string 
create or replace function sc_generate_random_string(seedstr varchar, len integer)
returns varchar as
$$
    select array_to_string(
        array(
            select 
                substring(
                    $1 
                    FROM 
                    (ceil(random()*length($1)))::int 
                    FOR 1
                ) 
            FROM 
             generate_series(1, $2)
        ), ''
    );
$$
language 'sql';



--  Function    :   sc_generate_code
--                  Create a random string which character must be contained in alphabetical set (ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789).
--                  The length of the random string is specified by len.
--  Parameter   :  
--                  len         Length of random string.      
--  Result      :   A random string 
create or replace function sc_generate_code(len integer) returns varchar as 
$$
    select sc_generate_random_string(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
        $1
    );
$$ language sql;



--  Function    :   sc_generate_token
--                  Create a random string to be used as a token.
--  Parameter   :  
--                  len         Length of code, which must be greater than 32.      
--  Result      :   The conbination of a random string and an uuid. 
create or replace function sc_generate_token(len integer) returns varchar as
$$
    select sc_generate_random_string(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',$1-32) || 
        sc_uuid();
$$ language 'sql';

