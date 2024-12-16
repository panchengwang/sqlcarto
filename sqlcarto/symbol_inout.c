#include <sqlcarto.h>
#include "symbol_inout.h"
#include <symbol.h>

Datum SYMBOL_in(PG_FUNCTION_ARGS);
Datum SYMBOL_out(PG_FUNCTION_ARGS);




PG_FUNCTION_INFO_V1(SYMBOL_in);
Datum SYMBOL_in(PG_FUNCTION_ARGS)
{
	char* input = PG_GETARG_CSTRING(0);
	char* str = input;

	SYMSERIALIZED* sym = NULL;
	HSYMBOL hSym = NULL;
	char* buf;
	size_t len;


	if (PG_NARGS() <= 2) {
		elog(ERROR, "parse symbol error - no input ");
		PG_RETURN_NULL();
	}

	while (*str == ' ' || *str == '\n' || *str == '\r')
		str++;

	if (str[0] == '{') {
		uint8_t ok;
		hSym = symbol_from_json_string(str, &ok);
		if (!ok) {
			elog(ERROR, "Invalid symbol json string:%s", symbol_get_error_message(hSym));
			PG_RETURN_NULL();
		}
		buf = symbol_serialize(hSym, &len);
		sym = (SYMSERIALIZED*)palloc(VARHDRSZ + len);
		SET_VARSIZE(sym, len + VARHDRSZ);
		memcpy((void*)VARDATA(sym), buf, len);
		free(buf);
		symbol_destroy(hSym);
		PG_RETURN_POINTER(sym);
	}
	else {
		elog(ERROR, "Invalid symbol string");
	}

	PG_RETURN_POINTER(NULL);
}


PG_FUNCTION_INFO_V1(SYMBOL_out);
Datum SYMBOL_out(PG_FUNCTION_ARGS)
{
	SYMSERIALIZED* sym = PG_GETARG_SYMSERIALIZED_P(0);
	HSYMBOL hSym = NULL;
	char* json_string = NULL;
	char* buf;
	size_t len;

	if (PG_ARGISNULL(0)) {
		PG_RETURN_NULL();
	}

	if (!(hSym = symbol_deserialize(VARDATA(sym)))) {
		elog(ERROR, "deserialize symbol error");
		PG_RETURN_NULL();
	}

	buf = symbol_to_json_string(hSym, &len, false);
	json_string = (char*)palloc(len + 1);
	memcpy(json_string, buf, len);
	json_string[len] = '\0';
	free(buf);

	PG_RETURN_CSTRING(json_string);
}


PG_FUNCTION_INFO_V1(sc_symbol_as_image);
Datum sc_symbol_as_image(PG_FUNCTION_ARGS)
{
	SYMSERIALIZED* sym = PG_GETARG_SYMSERIALIZED_P(0);
	char* format = text_to_cstring(PG_GETARG_TEXT_P(1));
	double dotsPerMM = PG_GETARG_FLOAT8(2);
	HSYMBOL hSym = NULL;
	unsigned char* buf;
	bytea* ret = NULL;

	size_t len;

	if (!(hSym = symbol_deserialize(VARDATA(sym)))) {
		elog(ERROR, "deserialize symbol error");
		PG_RETURN_NULL();
	}

	buf = symbol_to_image(hSym, format, dotsPerMM, &len);

	ret = (bytea*)palloc(VARHDRSZ + len);
	SET_VARSIZE(ret, len + VARHDRSZ);
	memcpy((void*)VARDATA(ret), buf, len);
	free(buf);

	PG_RETURN_BYTEA_P(ret);
}


PG_FUNCTION_INFO_V1(sc_symbol_as_image_with_size);
Datum sc_symbol_as_image_with_size(PG_FUNCTION_ARGS)
{
	SYMSERIALIZED* sym = PG_GETARG_SYMSERIALIZED_P(0);
	char* format = text_to_cstring(PG_GETARG_TEXT_P(1));
	double size = PG_GETARG_FLOAT8(2);
	double dotsPerMM = PG_GETARG_FLOAT8(3);
	HSYMBOL hSym = NULL;
	unsigned char* buf;
	bytea* ret = NULL;

	size_t len;

	if (!(hSym = symbol_deserialize(VARDATA(sym)))) {
		elog(ERROR, "deserialize symbol error");
		PG_RETURN_NULL();
	}

	buf = symbol_to_image_with_size(hSym, format, size, dotsPerMM, &len);

	ret = (bytea*)palloc(VARHDRSZ + len);
	SET_VARSIZE(ret, len + VARHDRSZ);
	memcpy((void*)VARDATA(ret), buf, len);
	free(buf);

	PG_RETURN_BYTEA_P(ret);
}


