SUBDIRS = create_grid

all: 
	mkdir -p bin
	make -C create_grid
	mv -f create_grid/create_grid bin/
	cp -f create_grid/create_grid.sh bin/

clean:
	make -C create_grid clean
	rm -rf bin

test:
	make -C create_grid test