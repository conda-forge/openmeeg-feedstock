#!/bin/bash
set -ex
export OPENMEEG_BAD_PYPY=$(python -c "import sys; print(int('pypy' in sys.implementation.name))")
./build_tools/cibuildwheel_test_command.sh
