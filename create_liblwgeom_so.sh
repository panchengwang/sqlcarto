#!/bin/sh
cd /home/pcwang/software/sdb/postgis-3.5.3
gcc -shared liblwgeom/*.o libpgcommon/*.o deps/ryu/d2s.o  -o liblwgeom.so -lgeos_c -lproj -ljson-c -lm -lpthread -lSFCGAL
sudo cp liblwgeom.so /usr/local/pgsql/lib
