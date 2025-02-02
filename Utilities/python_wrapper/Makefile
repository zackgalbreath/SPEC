SOURCES = ../../

# include the original Makefile
include ${SOURCES}/Makefile

#=======================================================================
#                   define the compiler names
#=======================================================================

# was CC in main SPEC Makefile
BUILD_ENV=gfortran_ubuntu

CC       = gcc
F90      = gfortran
#F90      = ifort
#F90      =  /opt/intel/composer_xe_2015.3.187/bin/intel64/ifort
PYTHON   = python3


#=======================================================================
#                     additional flags
#=======================================================================

ifeq ($(F90),gfortran)
	FPP      = $(FC) -E
	FPP_F90FLAGS = -x f95-cpp-input -fPIC
	F90FLAGS = $(RFLAGS)
	FCOMP    = $(FC) #gfortran
#	FLAGS    = -fPIC # moved to main Makefile to have to re-compile when build for python_wrapper
endif

ifeq ($(F90),ifort)
	FPP      = gfortran -E # gfortran f90wrap temp files only. not compilation
	FPP_F90FLAGS = -x f95-cpp-input -fPIC
	F90FLAGS = -fpscomp logicals -fPIC # use 1 and 0 for True and False
	FCOMP    = intelem # for f2py
endif

# CFLAGS := ${CFLAGS} -fPIC #     ==> universal for ifort, gfortran, pgi

#=======================================================================
#=======================================================================

UNAME = $(shell uname)

ifeq (${UNAME}, Darwin)
  LIBTOOL = libtool -static -o
else
  LIBTOOL = ar src
endif

# ======================================================================
# PROJECT CONFIG, do not put spaced behind the variables
# ======================================================================
# Python module name
PYTHON_MODN = spec
# mapping between Fortran and C types
KIND_MAP = kind_map
# static library name
LIB_NAME = lib$(PYTHON_MODN).a

#=======================================================================
#       List all source files that require a Python interface
#=======================================================================

# names (without suffix), f90 sources
TMP_FILES := ${ALLSPEC} xspech
LIBSRC_WRAP_SOURCES := $(TMP_FILES)

# file names
LIBSRC_WRAP_FILES = $(addsuffix .f90,${LIBSRC_WRAP_SOURCES})

# macro_explained files
LIBSRC_WRAP_MFILES = $(addsuffix _m.F90,${LIBSRC_WRAP_SOURCES})

# object files
LIBSRC_WRAP_OBJECTS = $(addsuffix _r.o,${LIBSRC_WRAP_SOURCES})

# fpp files
LIBSRC_WRAP_FPP_FILES = $(addsuffix .fpp,${LIBSRC_WRAP_SOURCES})

#=======================================================================
#                 Relevant suffixes
#=======================================================================

.SUFFIXES: .f90 .fpp

#=======================================================================
#
#=======================================================================

.PHONY: all all_clean

all: _${PYTHON_MODN}.so test

all_clean: f90wrap_clean
	make -C ${SOURCES} clean

f90wrap_clean:
	-rm -f ${LIBSRC_OBJECTS} ${LIBSRC_FPP_FILES} $(LIB_NAME) _${PYTHON_MODN}*.so \
	 *.mod *.fpp f90wrap*.f90 f90wrap*.o *.o ${PYTHON_MODN}.py
	-rm -rf ${PYTHON_MODN}_pkg
	-rm -rf src.*/ .f2py_f2cmap .libs/ __pycache__/
	-rm -rf $(LIB_NAME)

$(LIBSRC_WRAP_FPP_FILES): %.fpp: ${SOURCES}/%_m.F90
	${FPP} ${FPP_F90FLAGS} $<  -o $@

$(LIB_NAME):
	make -C ${SOURCES} BUILD_ENV=$(BUILD_ENV) FLAGS="${FLAGS}" xspec
	cd ${SOURCES}; ${LIBTOOL} Utilities/python_wrapper/$@ $(addsuffix _r.o,$(ALLFILES))
	ranlib $@

_${PYTHON_MODN}.so: $(LIB_NAME) ${LIBSRC_WRAP_FPP_FILES}
	f90wrap -m ${PYTHON_MODN} ${LIBSRC_WRAP_FPP_FILES} -k ${KIND_MAP} -v
	f2py-f90wrap --f90exec=${FC} --build-dir . -L. -l$(PYTHON_MODN) -I${SOURCES} ${LIBS} $(LINKS) -c f90wrap_*.f90 -m _${PYTHON_MODN}

compile_test:
	make -C ${SOURCES} BUILD_ENV=$(BUILD_ENV) FLAGS="${FLAGS}" show_makeflags
	@echo "SOURCES = ${SOURCES}"
	@echo "BUILD_ENV = ${BUILD_ENV}"
	@echo "CC = ${CC}"
	@echo "FC = ${FC}"
	@echo "LIBTOOL = ${LIBTOOL}"
	@echo "LIBSRC_WRAP_SOURCES = ${LIBSRC_WRAP_SOURCES}"
	@echo "CFLAGS = ${CFLAGS}"
	@echo "RFLAGS = ${RFLAGS}"
	@echo "FLAGS = ${FLAGS}"
	@echo "LINKS = ${LINKS}"

test:
	@${PYTHON} -c "import spec; print('SPEC version: {:}'.format(spec.constants.version))"
