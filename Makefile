all:
	make -C skerl
	erlc erlmamater.erl
	gcc -std=c99 -fPIC -shared -o erlmamater.so erlmamater.c -I /usr/lib/erlang/usr/include
