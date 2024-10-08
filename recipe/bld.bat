set CARGO_FEATURE_EXTERNAL_CPP=1
set "PSP_ROOT_DIR=%SRC_DIR%\\perspective-cpp"
set "CARGO_TARGET_DIR=D:\psp-rust"
cd perspective_python-%PKG_VERSION%
mkdir perspective_python-%PKG_VERSION%.data
xcopy /s /y %SRC_DIR%\perspective_python-%PKG_VERSION%.data perspective_python-%PKG_VERSION%.data\
if errorlevel 1 exit 1

cd rust\\perspective-client
set CARGO_FEATURE_EXTERNAL_PROTO=1
cargo build
if errorlevel 1 exit 1

cd ..\\..\\
set CARGO_FEATURE_EXTERNAL_PROTO=
%PYTHON% -m pip install . -vv
if errorlevel 1 exit 1

%PYTHON% %RECIPE_DIR%\\copy.py
if errorlevel 1 exit 1
