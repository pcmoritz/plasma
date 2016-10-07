CC = gcc
CFLAGS = -g -Wall --std=c99 -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200809L -I. -Icommon -Icommon/thirdparty
BUILD = build

all: $(BUILD)/plasma_store $(BUILD)/plasma_manager $(BUILD)/plasma_client.so $(BUILD)/example

debug: FORCE
debug: CFLAGS += -DDEBUG=1
debug: all

clean:
	cd common; make clean
	rm -r $(BUILD)/*

$(BUILD)/plasma_store: src/plasma_store.c src/plasma.h src/fling.h src/fling.c src/malloc.c src/malloc.h thirdparty/dlmalloc.c common
	$(CC) $(CFLAGS) src/plasma_store.c src/fling.c src/malloc.c common/build/libcommon.a -o $(BUILD)/plasma_store

$(BUILD)/plasma_manager: src/plasma_manager.c src/plasma.h src/plasma_client.c src/fling.h src/fling.c common
	$(CC) $(CFLAGS) src/plasma_manager.c src/plasma_client.c src/fling.c common/build/libcommon.a -o $(BUILD)/plasma_manager

$(BUILD)/plasma_client.so: src/plasma_client.c src/fling.h src/fling.c common
	$(CC) $(CFLAGS) src/plasma_client.c src/fling.c common/build/libcommon.a -fPIC -shared -o $(BUILD)/plasma_client.so

$(BUILD)/example: src/plasma_client.c src/plasma.h src/example.c src/fling.h src/fling.c common
	$(CC) $(CFLAGS) src/plasma_client.c src/example.c src/fling.c common/build/libcommon.a -o $(BUILD)/example

common: FORCE
		git submodule update --init --recursive
		cd common; make

FORCE:
