-- sqlcarto administrate module

drop table if exists sc_server_nodes;
create table sc_server_nodes(
    id varchar(32) not null,
    max_user_count  integer not null default 200,          -- each node can afford service for no more than 200 users 
    server_url varchar(1024),                              -- node service url for sqlcarto server
    db_host varchar(16) not null,                          -- host or ip
    db_storage_size float8 not null default 20000,         -- available space for database , unit: mega bytes
    db_reserved_factor float8 not null default 0.2,        -- if db storage occupied than (db_storage_size * (1-db_reserved_factor)), no operation can be done in this node
    last_operate_time timestamp default now() not null
);


-- 
create or replace function sc_add_node( maxuser float8, serverurl varchar, 
    dbhost varchar, dbmaxsize float8, dbreservfact float8) 
returns varchar as 
$$
declare
    nodeid varchar;
begin
    nodeid := sc_uuid();
    insert into sc_server_nodes(id,max_user_count, server_url, db_host,db_storage_size,db_reserved_factor) 
        values (nodeid,maxuser,serverurl, dbhost,dbmaxsize,dbreservfact);
    return nodeid;
end;
$$ language 'plpgsql';


drop table if exists sc_user_types;
create table sc_user_types(
    id integer not null unique,
    type_name varchar(64)
);
insert into sc_user_types(id, type_name) values
    (0, 'Adminstrator'),
    (1, 'Normal user'),
    (2, 'Guest');

drop table if exists sc_users;
create table sc_users(
    id varchar(32) primary key default sc_uuid() not null,
    user_name varchar(128) unique not null,
    password varchar(128) not null,
    user_type integer not null default 1,
    salt varchar(6) not null,
    verify_code varchar(6) default '',
    verify_code_gen_time timestamp not null default '1970-01-01'::timestamp,
    verify_code_valid_time interval default '10 minutes',
    token varchar(256) not null default '',
    token_gen_time timestamp null default now(),
    token_valid_time interval default '5 minutes',
    activated boolean default false not null,
    db_size float not null default 20000,                           -- 
    create_time timestamp default now()
);


create or replace function sc_user_exist(username varchar) returns boolean as 
$$
    select count(1) = 1 from sc_users where user_name = $1;
$$ language 'sql';


create or replace function sc_user_create(username varchar, password varchar, usertype integer) returns varchar as 
$$
declare
    id varchar;
    sqlstr text;
    salt varchar;
begin
    id := sc_uuid();
    salt := sc_generate_code(6);
    sqlstr := 'insert into sc_users(id,user_name,password,user_type,salt) values(' 
        || quote_literal(id) || ','
        || quote_literal(username) || ','
        || quote_literal(md5(password || salt)) || ','
        || usertype || ','
        || quote_literal(salt)
    || ')';
    execute sqlstr;
    return id;
end;
$$ language 'plpgsql';


create or replace function sc_user_is_activated(username varchar) returns boolean as 
$$
    select activated from sc_users where user_name = $1;
$$ language 'sql';

create or replace function sc_user_set_activate_by_id(userid varchar, isactivated boolean) returns varchar as 
$$
    update sc_users set activated = $2 where id = $1;
    select $1;
$$ language 'sql';

create or replace function sc_user_create_admin(username varchar, password varchar) returns varchar as 
$$
    select sc_user_set_activate_by_id(sc_user_create($1,$2,0),true);
$$ language 'sql';


create or replace function sc_user_get_id_by_name(username varchar) returns varchar as 
$$
    select id from sc_users where user_name = $1;
$$ language 'sql';



select sc_user_create_admin('pcwang','123456');




create table sc_layer_types(
    id integer not null default 0,
    name varchar(256)
);

insert into sc_layer_types(id,name) values
    (0, 'UNKNONW'),
    (1, 'TABLE'),
    (2, 'GROUP'),
    (3, 'POINT'),
    (4, 'LINESTRING'),
    (5, 'POLYGON'),
    (6, 'MULTIPOINT'),
    (7, 'MULTILINESTRING'),
    (8, 'MULTIPOINT'),
    (9, 'GEOMETRYCOLLECTION'),
    (10, 'TRIANGLE'),
    (11, 'NET');


create table sc_catalog(
    id varchar(32) primary key,
    parent_id varchar(32) not null,
    name varchar(64) default 'unnamed',
    layer_type integer default 0,
    create_time timestamp default NOW(),
    last_time timestamp default now()
);
