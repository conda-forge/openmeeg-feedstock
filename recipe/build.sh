#!/bin/bash

set -exo pipefail

export SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG=$PKG_VERSION
export SETUPTOOLS_SCM_PRETEND_VERSION=$PKG_VERSION

BUILD_DIR=build
mkdir -p $BUILD_DIR && cd $BUILD_DIR

# EXT_SUFFIX=$(python -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX'))")
EXT_SUFFIX=".abi3.so"
# Linux: _openmeeg.abi3.so
# macOS: _openmeeg.abi3.so
# Windows: _openmeeg.pyd

# https://conda-forge.org/docs/how-to/advanced/cross-compilation/#finding-numpy-in-cross-compiled-python-packages-using-cmake
Python_INCLUDE_DIR="$(python -c 'import sysconfig; print(sysconfig.get_path("include"))')"
Python_NumPy_INCLUDE_DIR="$(python -c 'import numpy; print(numpy.get_include())')"
echo "Running CMAKE"
cmake -GNinja \
      ${CMAKE_ARGS} \
      -DBLA_VENDOR:STRING=OpenBLAS \
      -DENABLE_PYTHON:BOOL=ON \
      -DPython3_EXECUTABLE="$PYTHON" \
      -DPython3_INCLUDE_DIR:PATH=${Python_INCLUDE_DIR} \
      -DPython3_NumPy_INCLUDE_DIR=${Python_NumPy_INCLUDE_DIR} \
      -DPython3_EXT_SUFFIX=$EXT_SUFFIX \
      -DPYTHON_FORCE_EXT_SUFFIX=ON \
      -DPYTHON_INSTALL_RELATIVE=OFF \
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      -DBUILD_DOCUMENTATION:BOOL=OFF \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      $SRC_DIR

cmake --build . --target install --config RELEASE
