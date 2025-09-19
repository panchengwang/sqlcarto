#include <stdio.h>
#include <stdlib.h>
#include "symbol_parser.h"

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Usage: %s <symbol json file name>\n", argv[0]);
        return EXIT_FAILURE;
    }

    symbol_t* symbol = sym_parse_file(argv[1]);
    if (!sym_parse_ok()) {
        printf("Error parsing symbol file: \"%s\"\n", sym_parse_error());
        return EXIT_FAILURE;
    }

    char* str = sym_to_string(symbol);
    printf("Parsed symbol: \"%s\"\n", str);

    symbol_t* sym2 = sym_parse_string(str);
    if (!sym_parse_ok()) {
        printf("Error parsing symbol string: \"%s\"\n", sym_parse_error());
        return EXIT_FAILURE;
    }
    printf("Parsed symbol from string: \"%s\"\n", sym_to_string(sym2));
    free(str);
    sym_free(symbol);
    sym_free(sym2);
    return EXIT_SUCCESS;
}