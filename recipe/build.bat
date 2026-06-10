setlocal EnableDelayedExpansion

echo on
set CMAKE_CONFIG=Release

SET SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG=%PKG_VERSION%
SET SETUPTOOLS_SCM_PRETEND_VERSION=%PKG_VERSION%
echo "%SETUPTOOLS_SCM_PRETEND_VERSION_FOR_OPENMEEG%"

mkdir build_%CMAKE_CONFIG%
pushd build_%CMAKE_CONFIG%

if not exist %PREFIX%\\libs\\python3.lib exit 1

:: FOR /F "tokens=* USEBACKQ" %%F IN (`%PYTHON% -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX'))"`) DO (
:: SET EXT_SUFFIX=%%F
:: )
SET EXT_SUFFIX=".pyd"
echo "EXT_SUFFIX=%EXT_SUFFIX%"

cmake -B . ^
      -DCMAKE_BUILD_TYPE:STRING=%CMAKE_CONFIG% ^
      -DCMAKE_CXX_FLAGS="-I%LIBRARY_INC%\openblas -DPy_LIMITED_API=0x030A0000" ^
      -DBLA_VENDOR:STRING=OpenBLAS ^
      -DENABLE_PYTHON:BOOL=ON ^
      -DPython3_EXECUTABLE=%PYTHON% ^
      -DPython3_EXT_SUFFIX=%EXT_SUFFIX% ^
      -DPython3_LIBRARIES:FILEPATH="%PREFIX%\libs\python3.lib"
      -DPYTHON_FORCE_EXT_SUFFIX:BOOL=ON ^
      -DPYTHON_INSTALL_RELATIVE:BOOL=OFF ^
      -DCMAKE_GENERATOR_TOOLSET=v142 ^
      -DCMAKE_SYSTEM_VERSION=7 ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_DOCUMENTATION:BOOL=OFF ^
      -DENABLE_PACKAGING:BOOL=OFF ^
      %CMAKE_ARGS% ^
      "%SRC_DIR%"
if errorlevel 1 exit rem 1

cmake --build . --target install --config %CMAKE_CONFIG%
if errorlevel 1 exit 1

popd
