all: parallel.c serial.c
	make parallel
	make serial
parallel: parallel.c
	mpicc parallel.c -o parallel
serial: serial.c
	gcc serial.c -o serial
runs: serial
	./serial
runp: parallel
	mpirun -np $(process) --oversubscribe ./parallel
clean: serial parallel
	rm serial parallel
