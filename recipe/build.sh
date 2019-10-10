#!/bin/bash

BUILD_DIR=build
mkdir -p $BUILD_DIR && cd $BUILD_DIR

cmake $SRC_DIR                          \
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON  \
      -DENABLE_PYTHON:BOOL=ON           \
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      -DBUILD_DOCUMENTATION:BOOL=OFF    \
      -DCMAKE_INSTALL_PREFIX=$PREFIX    \
      -DCMAKE_PREFIX_PATH=$PREFIX       \
      -DOpenBLAS_LIB=$PREFIX/lib/libcblas${SHLIB_EXT} \
      -DCMAKE_INSTALL_LIBDIR=lib

cmake --build . --target install --config RELEASE
