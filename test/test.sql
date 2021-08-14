create extension postgis;
create extension postgis_sfcgal; 
create extension postgis_topology;
create extension sqlcarto;


begin;


select sqlcarto_info();


end;
