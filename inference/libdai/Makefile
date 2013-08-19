# This file is part of libDAI - http://www.libdai.org/
#
# Copyright (c) 2006-2011, The libDAI authors. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.


# Load the local configuration from Makefile.conf
include Makefile.conf

# Directories of libDAI sources
# Location of libDAI headers
INC=include/dai
# Location of libDAI source files
SRC=src
# Destination directory of libDAI library
LIB=lib

# Define build targets
TARGETS:=directories matlab

# Define conditional build targets
NAMES:=graph dag bipgraph varset daialg clustergraph factor factorgraph properties regiongraph util weightedgraph exceptions jtree

# Define standard libDAI header dependencies, source file names and object file names
HEADERS=$(foreach name, graph dag bipgraph index var factor varset smallset prob daialg properties enum exceptions util jtree,$(INC)/$(name).h)


SOURCES:=$(foreach name,$(NAMES),$(SRC)/$(name).cpp)

# Setup final command for MEX
ifdef NEW_MATLAB
  MEXFLAGS:=$(MEXFLAGS) -largeArrayDims
else
  MEXFLAGS:=$(MEXFLAGS) -DSMALLMEM
endif
MEX:=$(MEX) $(MEXINC) $(MEXFLAGS) $(WITHFLAGS) $(MEXLIBS) $(MEXLIB)


# META TARGETS
###############

all : $(TARGETS)
	@echo
	@echo libDAI built successfully!

matlab : build/doinference$(ME)

directories:
	mkdir -p build

# MATLAB INTERFACE
###################

build/doinference$(ME) : $(SRC)/matlab/doinference.cpp $(HEADERS) $(SOURCES) $(SRC)/matlab/matlab.cpp
	$(MEX) -output $@ $< $(SRC)/matlab/matlab.cpp $(SOURCES)

# CLEAN
########
clean :
	rm -rfv build
