\timing


create or replace function test_map() returns bytea as $$
declare
    v_canvas text := '0';
    v_image bytea;
begin
    
    v_canvas := sc_canvas_create();
    perform sc_canvas_set_size(v_canvas,3840/144.0*25.4,2160/144.0*25.4);
    perform sc_canvas_set_dotspermm(v_canvas,144/25.4);
    perform sc_canvas_set_envelope(v_canvas,108.5,24.5,114.5,30.5);
    perform sc_canvas_begin(v_canvas);
    perform sc_canvas_draw_geometry(v_canvas, geom) from city   where "ADCODE93" >= 430000 and "ADCODE93" < 440000;
    perform sc_canvas_draw_geometry(v_canvas, geom) from county  where substring("ADCODE99",1,2)='43';
    perform sc_canvas_end(v_canvas);
    v_image := sc_canvas_as_png(v_canvas);
    perform sc_canvas_destroy(v_canvas);
    return v_image;
EXCEPTION WHEN OTHERS THEN
    if v_canvas <> '0' then 
        perform sc_canvas_destroy(v_canvas);
    end if;
    raise;
end;
$$ language plpgsql;


select test_map();


