setlocal EnableDelayedExpansion

set CMAKE_CONFIG=Release

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%

FOR /F "tokens=* USEBACKQ" %%F IN (`%PYTHON% -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX'))"`) DO (
SET EXT_SUFFIX=%%F
)

cmake -G Ninja                                             ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG%             ^
      -DCMAKE_CXX_FLAGS="-I%CONDA_PREFIX%/Library/include" ^
      -DBLA_VENDOR:STRING=OpenBLAS                         ^
      -DENABLE_PYTHON:BOOL=ON                              ^
      -DPython3_EXECUTABLE=%PYTHON%                        ^
      -DPython3_EXT_SUFFIX=%EXT_SUFFIX%                    ^
      -DPYTHON_FORCE_EXT_SUFFIX:BOOL=ON                    ^
      -DPYTHON_INSTALL_RELATIVE:BOOL=OFF                   ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%"       ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%"          ^
      -DBUILD_DOCUMENTATION:BOOL=OFF                       ^
      -DENABLE_PACKAGING:BOOL=OFF                          ^
      -DBUILD_SHARED_LIBS:BOOL=ON                          ^
      -DBLA_STATIC=ON                                      ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

popd
