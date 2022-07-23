#!/bin/bash
set -ex
ls -alR .
mv -v openmeeg/data .
rmdir openmeeg
export OPENMEEG_DATA_PATH=$PWD/data
./build_tools/cibuildwheel_test_command.sh
