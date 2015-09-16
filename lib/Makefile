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
BINDIR = /usr/local/lib
IDLDIR = /usr/local/exelis/idl/bin/bin.linux.x86_64
PRODIR = $(HOME)/idl/idlpvapi

CC = gcc
LD = ld
INSTALL = install

CFLAGS = -Wall -O -fPIC -D_LINUX -D_x64 -m64 -D_REENTRANT
INCLUDES = -I/usr/local/itt/idl/idl/external/include \
	-I/usr/local/include/pvapi
LD_FLAGS = -shared
LIBS = -L/usr/local/lib -lPvAPI

OBJS = $(TARGET).o
HEADERS = $(TARGET).h
SOURCES = $(TARGET).c $(HEADERS)

all: $(TARGET).so

$(TARGET).so: $(OBJS)
	$(LD) $(LD_FLAGS) -o $(TARGET).so $(OBJS) $(LIBS)

clean:
	-rm $(TARGET).so $(TARGET).o

.SUFFIXES: .c .o

.c.o :
	$(CC) $(CFLAGS) $(INCLUDES) -c $*.c
