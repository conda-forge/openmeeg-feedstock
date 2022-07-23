#!/bin/bash
set -ex
ls -alR .
OPENMEEG_DATA_PATH=$PWD/data ./build_tools/cibuildwheel_test_command.sh
