\x

select 
    english,
    chinese,
    sc_symbol_as_image(sym, 'png', 72/25.4) 
from 
    sc_symbols
where 
    english = '4';