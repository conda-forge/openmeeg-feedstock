#!/bin/bash
set -ex
ls -alR .
export OPENMEEG_BAD_PYPY=$(python -c "import sys; print(int('pypy' in sys.implementation.name))")
OPENMEEG_DATA_PATH=$PWD/data ./build_tools/cibuildwheel_test_command.sh
