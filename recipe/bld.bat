set CMAKE_CONFIG=Release

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%


echo library_dirs = %LIBRARY_LIB%
echo include_dirs = %LIBRARY_INC%

cmake -G "NMake Makefiles"                           ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"         ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG%       ^
      -DBLA_VENDOR:STRING=OpenBLAS                   ^
      -DENABLE_PYTHON:BOOL=ON                        ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_DOCUMENTATION:BOOL=OFF                 ^
      -DVCOMP_WORKAROUND=OFF                         ^
      -DENABLE_PACKAGING:BOOL=OFF                    ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

popd
