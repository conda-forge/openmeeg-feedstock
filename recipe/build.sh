#!/bin/bash

BUILD_DIR=build
mkdir -p $BUILD_DIR && cd $BUILD_DIR

EXT_SUFFIX=$(python -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX'))")

echo "Running CMAKE"
cmake -GNinja                           \
      ${CMAKE_ARGS}                     \
      -DBLA_VENDOR:STRING=OpenBLAS      \
      -DENABLE_PYTHON:BOOL=ON           \
      -DPython3_EXECUTABLE="$PYTHON"    \
      -DPython3_EXT_SUFFIX=$EXT_SUFFIX  \
      -DPYTHON_FORCE_EXT_SUFFIX=ON      \
      -DPYTHON_INSTALL_RELATIVE=OFF     \
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      -DBUILD_DOCUMENTATION:BOOL=OFF    \
      -DCMAKE_INSTALL_PREFIX=$PREFIX    \
      -DCMAKE_INSTALL_LIBDIR=lib        \
      -DBUILD_SHARED_LIBS=ON            \
      -DBLA_STATIC=ON                   \
      -DUSE_OPENMP=ON                   \
      -DLAPACK_LIBRARIES=$PREFIX/lib/libopenblas.a \
      -DCMAKE_CXX_FLAGS="-lgfortran"    \
      $SRC_DIR

cmake --build . --target install --config RELEASE
