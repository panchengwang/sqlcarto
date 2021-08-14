create extension "uuid-ossp" ;
create extension postgis;
create extension postgis_sfcgal; 
create extension postgis_topology;
create extension sqlcarto;

begin;

\echo Test sqlcarto .............................................. 

select sqlcarto_info();

select st_asewkt(sc_wgs84_to_gcj02('SRID=4326;POINT(112.9 28.2)'::geometry));

select sc_lonlat_to_tile('SRID=4326;POINT(112.9 28.2)'::geometry,15);


create table tile_test(
  id serial,
  t tile
);
insert into tile_test(t) values
  (sc_lonlat_to_tile('SRID=4326;POINT(112.9 28.2)'::geometry,15)),
  ('TILE(26600,13705,15)'::tile);
select 
  sc_x(t) as x,
  sc_y(t) as y, 
  sc_z(t) as z
from 
  tile_test;

update tile_test set t = sc_set_y(t,13000) where id = 2;
select 
  sc_x(t) as x,
  sc_y(t) as y, 
  sc_z(t) as z
from 
  tile_test;

end;