#include "bytea2cstring.h"

char* bytea_to_cstring(bytea* byteastr){
    char *str = NULL;
    int32 len = VARSIZE_ANY_EXHDR(byteastr)+1;
    str = (char*)malloc(len);
    memcpy(str,VARDATA_ANY(byteastr),len-1);
    str[len-1] = '\0';
    return str;
} 