---------------------------------------------------------------------------
--
-- SQLCarto - 
-- Authors:
--      Pancheng Wang           sqlcarto@163.com
---------------------------------------------------------------------------

--
-- 
--

-- #include "../postgis/sqldefines.h"

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



CREATE OR REPLACE FUNCTION sc_symbol_in(cstring)
	RETURNS symbol
	AS 'MODULE_PATHNAME','SYMBOL_in'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION sc_symbol_out(symbol)
	RETURNS cstring
	AS 'MODULE_PATHNAME','SYMBOL_out'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE TYPE symbol (
	internallength = variable,
	input = sc_symbol_in,
	output = sc_symbol_out,
	alignment = double,
	storage = main
);


-- CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,text,float8)
-- 	RETURNS bytea
-- 	AS 'MODULE_PATHNAME','sc_symbol_as_image'
-- 	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,float8)
	RETURNS bytea
	AS 'MODULE_PATHNAME','sc_symbol_as_image'
	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;


-- CREATE OR REPLACE FUNCTION sc_symbol_as_image(symbol,text,float8,float8)
-- 	RETURNS bytea
-- 	AS 'MODULE_PATHNAME','sc_symbol_as_image_with_size'
-- 	LANGUAGE 'c' IMMUTABLE STRICT PARALLEL SAFE;

  
-- Availability: 3.4.2 
-- 预定义好的地图符号postgres 
-- 地图符号中的线宽、点划线中的dash单位均为毫米 
-- 地图符号的定位坐标则为归一化的数值， 如圆心坐标、圆半径等 
-- 地图符号中的角度坐标为度，如弧的开始、结束角度，旋转角度 
create table symbol_sys( 
    id varchar(32) default sc_uuid(),       -- 
    english varchar(32),                    -- 英文名 
    chinese varchar(32),                    -- 中文名 
    sym symbol not null                     -- 地图符号 
); 

insert into symbol_sys(english, chinese, sym) values('arc','arc','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "arc",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0]
      },
      "center": [0, 0],
      "radiusx": 0.5,
      "radiusy": 0.5,
      "rotation": 0,
      "startangle": 0,
      "endangle": 180
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('chord','chord','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "chord",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [128, 128, 0, 255]
      },
      "center": [0.0, 0.0],
      "radiusx": 0.8,
      "radiusy": 0.8,
      "rotation": 0,
      "startangle": 45,
      "endangle": 135
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('circle','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [255, 0, 255, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 255, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('ellipse','ellipse','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "ellipse",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 100]
      },
      "center": [0, 0],
      "radiusx": 0.8,
      "radiusy": 0.4,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 2, 2, 2]
      }
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 2, 0.25, 2]
      }
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('line','dash','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 2, 0.25, 2, 0.25, 2]
      }
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('line','solid','
{
  "width": 100.0,
  "height": 2,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "systemline",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      }
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('linestring','linestring','
{
    "width": 100.0,
    "height": 100.0,
    "dotspermm": 3.7795275590551185,
    "shapes": [
        {
            "type": "linestring",
            "stroke": {
                "color": [
                    0,
                    0,
                    0,
                    255
                ],
                "width": 3,
                "cap": "round",
                "join": "round",
                "dashes": [
                    1,
                    0
                ]
            },
            "points": [
                [
                    -0.25,
                    -0.25
                ],
                [
                    0.25,
                    -0.25
                ],
                [
                    0.25,
                    0.25
                ],
                [
                    -0.25,
                    0.25
                ]
            ]
        }
    ]
}');

insert into symbol_sys(english, chinese, sym) values('pie','pie','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "pie",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.5,
        "cap": "butt",
        "join": "miter",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [128, 128, 0, 100]
      },
      "center": [0.0, 0.0],
      "radiusx": 0.8,
      "radiusy": 0.8,
      "rotation": 0,
      "startangle": 60,
      "endangle": 120
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('polygon','polygon','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "polygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "points": [
        [-0.8, -0.8],
        [0.8, -0.8],
        [0.8, 0.8],
        [-0.2, 0.8],
        [-0.8, 0.2],
        [-0.8, -0.8]
      ]
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('rectangle','rectangle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "rectangle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.1,
        "cap": "round",
        "join": "miter",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [127, 127, 0, 255]
      },
      "minx": -0.8,
      "maxx": 0.8,
      "miny": -0.4,
      "maxy": 0.4
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 3,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 4,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 5,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 6,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 7,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('regularpolygon','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "regularpolygon",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 255, 127]
      },
      "center": [0.0, 0.0],
      "radius": 0.8,
      "sides": 8,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.2,
      "sides": 3,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 4,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 5,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 6,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 7,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 8,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('star','9','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "star",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 1,
        "cap": "round",
        "join": "round",
        "dashes": [1, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "center": [0.0, 0.0],
      "radius": 0.9,
      "radius2": 0.35,
      "sides": 9,
      "rotation": 0
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','0','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "0",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','1','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "1",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','2','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "2",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','3','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "3",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','4','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "4",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','5','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "5",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','6','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "6",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','7','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "7",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','8','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "8",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','9','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "9",
      "center": [0.0, 0.0],
      "fontsize": 0.8,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "1",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "1",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "2",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "3",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "4",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "5",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "6",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "7",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "8",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

insert into symbol_sys(english, chinese, sym) values('text','circle','
{
  "width": 100.0,
  "height": 100.0,
  "dotspermm": 3.7795275590551185,
  "shapes": [
    {
      "type": "circle",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 255, 0, 0]
      },
      "center": [0.0, 0.0],
      "radius": 0.8
    },
    {
      "type": "text",
      "stroke": {
        "color": [0, 0, 0, 255],
        "width": 0.2,
        "cap": "butt",
        "join": "miter",
        "dashes": [2, 0]
      },
      "fill": {
        "type": "solid",
        "color": [255, 0, 0, 255]
      },
      "text": "9",
      "center": [0.0, 0.0],
      "fontsize": 0.7,
      "rotation": 0,
      "fontname": "Noto Sans CJK SC",
      "outlined": true,
      "outlinedwidth": 0.2,
      "slant": "normal",
      "weight": "normal"
    }
  ]
}
');

