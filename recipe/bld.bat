set CMAKE_CONFIG=Release

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%


REM echo prefix = %PREFIX%
REM echo library_dirs = %LIBRARY_LIB%
REM echo include_dirs = %LIBRARY_INC%
REM echo library_prefix = %LIBRARY_PREFIX%

REM dir %LIBRARY_PREFIX%
REM dir %LIBRARY_PREFIX%\lib\


cmake -G "NMake Makefiles"                           ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"         ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG%       ^
      -DENABLE_PYTHON:BOOL=ON                        ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_DOCUMENTATION:BOOL=OFF                 ^
      -DVCOMP_WORKAROUND=OFF                         ^
      -DENABLE_PACKAGING:BOOL=OFF                    ^
      -DOpenBLAS_LIB="%LIBRARY_PREFIX%\lib\blas.lib;%LIBRARY_PREFIX%\lib\cblas.lib;%LIBRARY_PREFIX%\lib\lapack.lib;%LIBRARY_PREFIX%\lib\lapacke.lib" ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

popd
