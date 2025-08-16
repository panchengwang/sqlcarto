\x

\timing

-- select english,sym from symbol_sys ;

select 
    english,
    chinese,
    sc_symbol_as_image(sym,  96/25.4) 
from 
    symbol_sys 
;

select count(1) from symbol_sys;