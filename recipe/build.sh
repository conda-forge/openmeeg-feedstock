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
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      -DBUILD_DOCUMENTATION:BOOL=OFF    \
      -DCMAKE_INSTALL_PREFIX=$PREFIX    \
      -DCMAKE_INSTALL_LIBDIR=lib        \
      -DBUILD_SHARED_LIBS=ON            \
      -DBLA_STATIC=ON                   \
      -DPython3_EXT_SUFFIX=$EXT_SUFFIX  \
      -DLAPACK_LIBRARIES=$PREFIX/lib/libopenblas.a \
      -DCMAKE_CXX_FLAGS="-lgfortran"    \
      $SRC_DIR

cmake --build . --config RELEASE

cd wrapping/python
$PYTHON setup.py bdist_wheel
cd dist
if [[ "${OS}" == "osx" ]]; then
    $PYTHON -c "import sys; from delocate.cmd.delocate_wheel import delocate_wheel; delocate_wheel(sys.argv[-1], lib_filt_func=lambda name: 'OpenMEEG' in name)" $PWD/*.whl
else
    $PYTHON -m auditwheel -v show $PWD/*.whl
    $PYTHON -m auditwheel -v repair $PWD/*.whl
fi
$PYTHON -m pip install $PWD/*.whl
