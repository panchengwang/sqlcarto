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



create or replace function st_dump_linestrings(geo geometry) returns setof geometry as 
$$
  select st_polygon_to_linestring($1);
$$
language 'sql';



-- 获取multilinestring中每个线段的起点
create or replace function st_startpoints(geo geometry) returns setof geometry as 
$$
  select st_startpoint((st_dump(st_linemerge($1))).geom);
$$
language 'sql';

-- 获取multilinestring中每个线段的尾点
create or replace function st_endpoints(geo geometry) returns setof geometry as 
$$
  select st_endpoint((st_dump(st_linemerge($1))).geom);
$$
language 'sql';



-- 将linestring从parts打断
create or replace function st_split_linestring(
  geo geometry,
  parts float8[]
) returns setof geometry as 
$$
declare
  startpt float8;
  locpt float8;
  sqlstr text;
  i integer;
begin
  for i in 1..array_length(parts,1)-1 loop 
    return next st_linesubstring(geo,parts[i],parts[i+1]);
  end loop;
  return;
end;
$$
language 'plpgsql';



-- 下面的这段代码是postgis提供的
-- sqlcarto作者对此做了修改
-- drop function topology.createtopology(
-- 	atopology character varying,
-- 	srid integer,
-- 	prec double precision,
-- 	hasz boolean);
CREATE OR REPLACE FUNCTION topology.createtopology(
	atopology character varying,
	srid integer,
	prec double precision,
	hasz boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$
DECLARE
  rec RECORD;
  topology_id integer;
  ndims integer;
BEGIN

--  FOR rec IN SELECT * FROM pg_namespace WHERE text(nspname) = atopology
--  LOOP
--    RAISE EXCEPTION 'SQL/MM Spatial exception - schema already exists';
--  END LOOP;

  ndims = 2;
  IF hasZ THEN ndims = 3; END IF;

  IF srid < 0 THEN
    RAISE NOTICE 'SRID value % converted to the officially unknown SRID value 0', srid;
    srid = 0;
  END IF;

  ------ Fetch next id for the new topology
  FOR rec IN SELECT nextval('topology.topology_id_seq')
  LOOP
    topology_id = rec.nextval;
  END LOOP;

  EXECUTE 'CREATE SCHEMA ' || quote_ident(atopology);

  -------------{ face CREATION
  EXECUTE
  'CREATE TABLE ' || quote_ident(atopology) || '.face ('
     'face_id SERIAL,'
     ' CONSTRAINT face_primary_key PRIMARY KEY(face_id)'
     ');';

  -- Add mbr column to the face table
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''face'',''mbr'','||quote_literal(srid)
  ||',''POLYGON'',2)'; -- 2d only mbr is good enough

  -- Face standard view description
  EXECUTE 'COMMENT ON TABLE ' || quote_ident(atopology)
    || '.face IS '
       '''Contains face topology primitives''';

  -------------} END OF face CREATION

  --------------{ node CREATION

  EXECUTE
  'CREATE TABLE ' || quote_ident(atopology) || '.node ('
     'node_id SERIAL,'
  --|| 'geom GEOMETRY,'
     'containing_face INTEGER,'

     'CONSTRAINT node_primary_key PRIMARY KEY(node_id),'

  --|| 'CONSTRAINT node_geometry_type CHECK '
  --|| '( GeometryType(geom) = ''POINT'' ),'

     'CONSTRAINT face_exists FOREIGN KEY(containing_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id)'

     ');';

  -- Add geometry column to the node table
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''node'',''geom'','||quote_literal(srid)
  ||',''POINT'',' || ndims || ')';

  -- Node standard view description
  EXECUTE 'COMMENT ON TABLE ' || quote_ident(atopology)
    || '.node IS '
       '''Contains node topology primitives''';

  --------------} END OF node CREATION

  --------------{ edge CREATION

  -- edge_data table
  EXECUTE
  'CREATE TABLE ' || quote_ident(atopology) || '.edge_data ('
     'edge_id SERIAL NOT NULL PRIMARY KEY,'
     'start_node INTEGER NOT NULL,'
     'end_node INTEGER NOT NULL,'
     'next_left_edge INTEGER NOT NULL,'
     'abs_next_left_edge INTEGER NOT NULL,'
     'next_right_edge INTEGER NOT NULL,'
     'abs_next_right_edge INTEGER NOT NULL,'
     'left_face INTEGER NOT NULL,'
     'right_face INTEGER NOT NULL,'
  --   'geom GEOMETRY NOT NULL,'

  --   'CONSTRAINT edge_geometry_type CHECK '
  --   '( GeometryType(geom) = ''LINESTRING'' ),'

     'CONSTRAINT start_node_exists FOREIGN KEY(start_node)'
     ' REFERENCES ' || quote_ident(atopology) || '.node(node_id),'

     'CONSTRAINT end_node_exists FOREIGN KEY(end_node) '
     ' REFERENCES ' || quote_ident(atopology) || '.node(node_id),'

     'CONSTRAINT left_face_exists FOREIGN KEY(left_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id),'

     'CONSTRAINT right_face_exists FOREIGN KEY(right_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id),'

     'CONSTRAINT next_left_edge_exists FOREIGN KEY(abs_next_left_edge)'
     ' REFERENCES ' || quote_ident(atopology)
  || '.edge_data(edge_id),'
    --  ' DEFERRABLE INITIALLY DEFERRED,'    -- postgis的源代码包含此行，会导致createtopology和droptopology不能运行在同一个事务中，因此删除

     'CONSTRAINT next_right_edge_exists '
     'FOREIGN KEY(abs_next_right_edge)'
     ' REFERENCES ' || quote_ident(atopology)
  || '.edge_data(edge_id) '
    --  ' DEFERRABLE INITIALLY DEFERRED'    -- postgis的源代码包含此行，会导致createtopology和droptopology不能运行在同一个事务中，因此删除
     ');';

  -- Add geometry column to the edge_data table
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''edge_data'',''geom'','||quote_literal(srid)
  ||',''LINESTRING'',' || ndims || ')';

  -- edge standard view (select rule)
  EXECUTE 'CREATE VIEW ' || quote_ident(atopology)
    || '.edge AS SELECT '
       ' edge_id, start_node, end_node, next_left_edge, '
       ' next_right_edge, '
       ' left_face, right_face, geom FROM '
    || quote_ident(atopology) || '.edge_data';

  -- Edge standard view description
  EXECUTE 'COMMENT ON VIEW ' || quote_ident(atopology)
    || '.edge IS '
       '''Contains edge topology primitives''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.edge_id IS '
       '''Unique identifier of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.start_node IS '
       '''Unique identifier of the node at the start of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.end_node IS '
       '''Unique identifier of the node at the end of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.next_left_edge IS '
       '''Unique identifier of the next edge of the face on the left (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.next_right_edge IS '
       '''Unique identifier of the next edge of the face on the right (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.left_face IS '
       '''Unique identifier of the face on the left side of the edge when looking in the direction from START_NODE to END_NODE''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.right_face IS '
       '''Unique identifier of the face on the right side of the edge when looking in the direction from START_NODE to END_NODE''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.geom IS '
       '''The geometry of the edge''';

  -- edge standard view (insert rule)
  EXECUTE 'CREATE RULE edge_insert_rule AS ON INSERT '
             'TO ' || quote_ident(atopology)
    || '.edge DO INSTEAD '
                   ' INSERT into ' || quote_ident(atopology)
    || '.edge_data '
                   ' VALUES (NEW.edge_id, NEW.start_node, NEW.end_node, '
       ' NEW.next_left_edge, abs(NEW.next_left_edge), '
       ' NEW.next_right_edge, abs(NEW.next_right_edge), '
       ' NEW.left_face, NEW.right_face, NEW.geom);';

  --------------} END OF edge CREATION

  --------------{ layer sequence
  EXECUTE 'CREATE SEQUENCE '
    || quote_ident(atopology) || '.layer_id_seq;';
  --------------} layer sequence

  --------------{ relation CREATION
  --
  EXECUTE
  'CREATE TABLE ' || quote_ident(atopology) || '.relation ('
     ' topogeo_id integer NOT NULL, '
     ' layer_id integer NOT NULL, '
     ' element_id integer NOT NULL, '
     ' element_type integer NOT NULL, '
     ' UNIQUE(layer_id,topogeo_id,element_id,element_type));';

  EXECUTE
  'CREATE TRIGGER relation_integrity_checks '
     'BEFORE UPDATE OR INSERT ON '
  || quote_ident(atopology) || '.relation FOR EACH ROW '
     ' EXECUTE PROCEDURE topology.RelationTrigger('
  ||topology_id||','||quote_literal(atopology)||')';
  --------------} END OF relation CREATION

  ------- Default (world) face
  EXECUTE 'INSERT INTO ' || quote_ident(atopology) || '.face(face_id) VALUES(0);';

  ------- GiST index on face
  EXECUTE 'CREATE INDEX face_gist ON '
    || quote_ident(atopology)
    || '.face using gist (mbr);';

  ------- GiST index on node
  EXECUTE 'CREATE INDEX node_gist ON '
    || quote_ident(atopology)
    || '.node using gist (geom);';

  ------- GiST index on edge
  EXECUTE 'CREATE INDEX edge_gist ON '
    || quote_ident(atopology)
    || '.edge_data using gist (geom);';

  ------- Indexes on left_face and right_face of edge_data
  ------- NOTE: these indexes speed up GetFaceGeometry (and thus
  -------       TopoGeometry::Geometry) by a factor of 10 !
  -------       See http://trac.osgeo.org/postgis/ticket/806
  EXECUTE 'CREATE INDEX edge_left_face_idx ON '
    || quote_ident(atopology)
    || '.edge_data (left_face);';
  EXECUTE 'CREATE INDEX edge_right_face_idx ON '
    || quote_ident(atopology)
    || '.edge_data (right_face);';

  ------- Indexes on start_node and end_node of edge_data
  ------- NOTE: this indexes speed up node deletion
  -------       by a factor of 1000 !
  -------       See http://trac.osgeo.org/postgis/ticket/2082
  EXECUTE 'CREATE INDEX edge_start_node_idx ON '
    || quote_ident(atopology)
    || '.edge_data (start_node);';
  EXECUTE 'CREATE INDEX edge_end_node_idx ON '
    || quote_ident(atopology)
    || '.edge_data (end_node);';

  -- TODO: consider also adding an index on node.containing_face

  ------- Add record to the "topology" metadata table
  EXECUTE 'INSERT INTO topology.topology '
    || '(id, name, srid, precision, hasZ) VALUES ('
    || quote_literal(topology_id) || ','
    || quote_literal(atopology) || ','
    || quote_literal(srid) || ',' || quote_literal(prec)
    || ',' || hasZ
    || ')';

  RETURN topology_id;
END
$BODY$;