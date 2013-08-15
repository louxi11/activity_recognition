# This file is part of libDAI - http://www.libdai.org/
#
# Copyright (c) 2006-2011, The libDAI authors. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.


# make options
DEBUG=False

# Load the local configuration from Makefile.conf
include Makefile.conf

# Directories of libDAI sources
# Location of libDAI headers
INC=include/dai
# Location of libDAI source files
SRC=src
# Destination directory of libDAI library
LIB=lib

# Set final compiler flags
ifdef true
  CCFLAGS:=$(CCFLAGS) $(CCDEBUGFLAGS)
else
  CCFLAGS:=$(CCFLAGS) $(CCNODEBUGFLAGS)
endif

# Define build targets
TARGETS:=lib build

# Define conditional build targets
NAMES:=graph dag bipgraph varset daialg alldai clustergraph factor factorgraph properties regiongraph util weightedgraph exceptions exactinf

# JTREE
WITHFLAGS:=$(WITHFLAGS) -DDAI_WITH_JTREE
NAMES:=$(NAMES) jtree

# Define standard libDAI header dependencies, source file names and object file names
HEADERS=$(foreach name,graph dag bipgraph index var factor varset smallset prob daialg properties alldai enum exceptions util,$(INC)/$(name).h)
SOURCES:=$(foreach name,$(NAMES),$(SRC)/$(name).cpp)
OBJECTS:=$(foreach name,$(NAMES),$(name)$(OE))

# Setup final command for C++ compiler
ifneq ($(OS),WINDOWS)
  CC:=$(CC) $(CCINC) $(CCFLAGS) $(WITHFLAGS) $(CCLIB)
else
  CC:=$(CC) $(CCINC) $(CCFLAGS) $(WITHFLAGS)
  LIBS:=$(LIBS) $(CCLIB)
endif

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

BUILD=build/doinference$(EE)
build : $(BUILD)

utils : utils/createfg$(EE) utils/fg2dot$(EE) utils/fginfo$(EE) utils/uai2fg$(EE)

lib: $(LIB)/libdai$(LE)

doinference: build/doinference$(EE)

# OBJECTS
##########

%$(OE) : $(SRC)/%.cpp $(INC)/%.h $(HEADERS)
	$(CC) -c $<


jtree$(OE) : $(SRC)/jtree.cpp $(INC)/jtree.h $(HEADERS) $(INC)/weightedgraph.h $(INC)/clustergraph.h $(INC)/regiongraph.h
	$(CC) -c $<


# EXAMPLES
###########

build/%$(EE) : %.cpp $(HEADERS) $(LIB)/libdai$(LE)
	$(CC) $(CCO)$@ $< $(LIBS)

# LIBRARY
##########

ifneq ($(OS),WINDOWS)
$(LIB)/libdai$(LE) : $(OBJECTS)
	-mkdir -p lib
	ar rcus $(LIB)/libdai$(LE) $(OBJECTS)
else
$(LIB)/libdai$(LE) : $(OBJECTS)
	-mkdir lib
	lib /out:$(LIB)/libdai$(LE) $(OBJECTS)
endif

# CLEAN
########

.PHONY : clean
ifneq ($(OS),WINDOWS)
clean :
	-rm $(OBJECTS)
	-rm -R lib

else
clean :
	-del *.obj
	-del *.ilk
	-del *.pdb
	-del utils\*$(EE)
	-del utils\*$(EE).manifest
	-del utils\*.pdb
	-del utils\*.ilk
	-del factorgraph_test.fg
	-del alldai_test.aliases
	-del $(LIB)\libdai$(LE)
	-rmdir lib
endif
