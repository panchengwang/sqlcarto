-- 将多边形等转换成linestring
create or replace function st_polygon_to_linestring(geo geometry) returns setof geometry as 
$$
declare
  sqlstr text;
  i integer;
  j integer;
  mypg geometry;
  myrec record;
  geotype varchar;
begin
  geotype := st_geometrytype(geo);
  if st_isempty(geo) then 
    return;
  end if;

  if geotype = 'ST_LineString' then 
    return next geo;
  elsif geotype = 'ST_MultiLineString' then
    for i in 1..st_numgeometries(geo) loop 
      return next st_geometryn(geo,i);
    end loop; 
  elsif geotype = 'ST_Polygon' then 
    return next ST_ExteriorRing(geo);
    for i in 1..ST_NumInteriorRings(geo) loop 
      return next ST_InteriorRingN(geo,i);
    end loop;
  elsif geotype = 'ST_MultiPolygon' then 
    for j in 1..st_numgeometries(geo) loop
      mypg := st_geometryn(geo,j);
      return next ST_ExteriorRing(mypg);
      for i in 1..ST_NumInteriorRings(mypg) loop 
        return next ST_InteriorRingN(mypg,i);
      end loop;
    end loop;
  elsif geotype = 'ST_GeometryCollection' then 
    for j in 1..st_numgeometries(geo) loop
      sqlstr := 'select geo from st_polygon_to_linestring(' || st_geometryn(geo,j) || ') as geo';
      for myrec in execute sqlstr loop 
        return next myrec.geo;
      end loop;
    end loop;
  elsif geotype <> 'ST_Polygon' 
    and geotype <> 'ST_MultiPolygon'
    and geotype <> 'ST_LineString'
    and geotype <> 'ST_MultiLineString' then 
    raise notice 'type: %, %', geotype,' Only LineString, MultiLineString,Polygon,MultiPolygon can be convert to LineString ';
  end if;

  return;
end;
$$
language 'plpgsql';