setlocal EnableDelayedExpansion

echo on
set CMAKE_CONFIG=Release

set SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG=%PKG_VERSION%
set SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%
echo "%SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG%"

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%

:: FOR /F "tokens=* USEBACKQ" %%F IN (`%PYTHON% -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX'))"`) DO (
:: set EXT_SUFFIX=%%F
:: )
set EXT_SUFFIX=.pyd
echo EXT_SUFFIX=%EXT_SUFFIX%

set PYTHON_SABI_LIBRARY_DIR=%PREFIX%\libs
echo PYTHON_SABI_LIBRARY_DIR=%PYTHON_SABI_LIBRARY_DIR%
set PYTHON_SABI_LIBRARY=%PYTHON_SABI_LIBRARY_DIR%\python3.lib
echo Checking for ABI3 import lib: %PYTHON_SABI_LIBRARY%
if not exist "%PYTHON_SABI_LIBRARY%" (
    echo ABI3 import library not found at %PYTHON_SABI_LIBRARY%
    echo Contents of %PYTHON_SABI_LIBRARY_DIR%:
    dir "%PYTHON_SABI_LIBRARY_DIR%"
    exit /b 1
)
else (
    echo Found ABI3 import library: %PYTHON_SABI_LIBRARY%
)

:: Pass LIBPATH to make sure CL finds the ABI3 import library during linking
SET CXXFLAGS=-I%LIBRARY_INC%\openblas -DPy_LIMITED_API=0x030A0000
SET LDFLAGS=/LIBPATH:%PYTHON_SABI_LIBRARY_DIR%
cmake -B . ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG% ^
      -DBLA_VENDOR:STRING=OpenBLAS ^
      -DENABLE_PYTHON:BOOL=ON ^
      -DPython3_EXECUTABLE=%PYTHON% ^
      -DPython3_EXT_SUFFIX=%EXT_SUFFIX% ^
      -DPython3_LIBRARY_DIRS=%PYTHON_SABI_LIBRARY_DIR% ^
      -DPYTHON_FORCE_EXT_SUFFIX:BOOL=ON ^
      -DPYTHON_INSTALL_RELATIVE:BOOL=OFF ^
      -DCMAKE_GENERATOR_TOOLSET=v143 ^
      -DCMAKE_SYSTEM_VERSION=7 ^
      -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH:PATH=%LIBRARY_PREFIX% ^
      -DBUILD_DOCUMENTATION:BOOL=OFF ^
      -DENABLE_PACKAGING:BOOL=OFF ^
      %CMAKE_ARGS% ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

popd
