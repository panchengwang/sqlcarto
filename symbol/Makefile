LIBS = $(shell pkg-config cairo --libs) $(shell pkg-config json-c --libs)
INCLUDES = $(shell pkg-config cairo --cflags) $(shell pkg-config json-c --cflags)

test_symbol: *.c *.h
	gcc -o $@ *.c ${INCLUDES} ${LIBS}


clean:
	rm -rf *.o
	rm -rf test_symbol