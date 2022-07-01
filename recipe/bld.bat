setlocal EnableDelayedExpansion

set CMAKE_CONFIG=Release

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%

cmake -G Ninja                                       ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG%       ^
      -DBLA_VENDOR:STRING=OpenBLAS                   ^
      -DENABLE_PYTHON:BOOL=ON                        ^
      -DPython3_EXECUTABLE=%PYTHON%                  ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%"    ^
      -DBUILD_DOCUMENTATION:BOOL=OFF                 ^
      -DENABLE_PACKAGING:BOOL=OFF                    ^
      -DBUILD_SHARED_LIBS:BOOL=ON                    ^
      -DBLA_STATIC=ON                                ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

%PYTHON% -m pip install ./wrapping/python -vv
if errorlevel 1 exit 1

popd
