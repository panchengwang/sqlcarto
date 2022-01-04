create_grid: create_grid.cpp
	g++ -o create_grid create_grid.cpp

test: create_grid
	./create_grid www.pcgis.cn 5432 gisdb pcwang public grida 3857 12556838 3274212 100 100 20 20 3000 4 > a.sh
	bash a.sh 
	rm a.sh

clean:
	rm -f create_grid
	rm -f *.o
	