ARCH := $(shell erl -eval 'io:format("~s~n", [lists:concat([erlang:system_info(system_architecture)])])' -s init stop -noshell)

C = gcc
CPP = g++
CFLAGS = -o3 -Wall -fPIC -maes -Isrc
CPPFLAGS = $(CFLAGS) -std=c++11

BUILD_FOLDER = priv/native/$(ARCH)
SOURCE_FILES = \
		src/main.cpp \
		src/crypto/c_blake256.c \
		src/crypto/c_groestl.c \
		src/crypto/c_jh.c \
		src/crypto/c_keccak.c \
		src/crypto/c_skein.c
OBJECTS = $(patsubst %.c, $(BUILD_FOLDER)/%.o, $(patsubst %.cpp, %.c, $(SOURCE_FILES)))
TARGET ?= _build/dev/lib/cryptonightex/priv/$(ARCH)/cryptonight_port

$(TARGET): $(OBJECTS)
	mkdir -p `dirname $@`
	$(CPP) $(OBJECTS) -o $@

$(BUILD_FOLDER)/%.o: %.c
	mkdir -p `dirname $@`
	$(C) $(CFLAGS) -c $< -o $@

$(BUILD_FOLDER)/%.o: %.cpp
	mkdir -p `dirname $@`
	$(CPP) $(CPPFLAGS) -c $< -o $@

default: $(TARGET)

clean:
	rm -rf $(BUILD_FOLDER) $(TARGET)

.PHONY: clean default
