#!/bin/bash

set -exo pipefail

export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG=$(python -m setuptools_scm -c wrapping/python/pyproject.toml)

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
      -DCMAKE_CXX_FLAGS="-lgfortran"    \
      $SRC_DIR

cmake --build . --target install --config RELEASE
