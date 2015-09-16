#
# Makefile for idlpvapi.so
#
# Shared object library to provide IDL support for the PvAPI
# interface to Prosilica and AVT GigE video cameras.
#
# Modification History
# 12/07/2010 Written by David G. Grier, New York University
#
# Copyright (c) 2010 David G. Grier
#
TARGET = idlpvapi

SYS =  $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH = $(shell uname -m)
#LIBRARY = $(TARGET).$(SYS).$(ARCH).so
LIBRARY = $(TARGET).so

IDLDIR = /usr/local/exelis/idl

CC = gcc
LD = ld
INSTALL = install

CFLAGS = -Wall -O -fPIC -D_LINUX -D_x64 -m64 -D_REENTRANT
INCLUDES = -I$(IDLDIR)/external/include \
	-I/usr/local/include/pvapi
LD_FLAGS = -shared
LIBS = -L/usr/local/lib -lPvAPI

SRC = $(TARGET).c
OBJS = $(TARGET).o
HEADERS = $(TARGET).h

all: $(LIBRARY)

$(LIBRARY): $(OBJS)
	$(LD) $(LD_FLAGS) -o $(LIBRARY) $(OBJS) $(LIBS)

install: $(LIBRARY)
	sudo $(INSTALL) -d $(DESTINATION)
	sudo $(INSTALL) $(LIBRARY) $(DESTINATION)

uninstall:
	sudo rm -rf $(DESTINATION)

clean:
	-rm $(TARGET).so $(TARGET).o

.SUFFIXES: .c .o

.c.o :
	$(CC) $(CFLAGS) $(INCLUDES) -c $*.c
