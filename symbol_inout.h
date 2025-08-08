#ifndef __PG_SYMBOL_H
#define __PG_SYMBOL_H


#include "sqlcarto.h"

#include <inttypes.h>


typedef struct
{
    uint32_t size; /* For PgSQL use only, use VAR* macros to manipulate. */
    uint8_t data[1]; /* See gserialized.txt */
} SYMSERIALIZED;


#define PG_GETARG_SYMSERIALIZED_P(varno) ((SYMSERIALIZED *)PG_DETOAST_DATUM(PG_GETARG_DATUM(varno)))


Datum SYMBOL_in(PG_FUNCTION_ARGS);
Datum SYMBOL_out(PG_FUNCTION_ARGS);
Datum sc_symbol_as_image(PG_FUNCTION_ARGS);


#endif
