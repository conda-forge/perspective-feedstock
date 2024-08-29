set CARGO_FEATURE_EXTERNAL_CPP=1
set "PSP_ROOT_DIR=%SRC_DIR%\\perspective-cpp"
cd perspective_python-%PKG_VERSION%
mkdir perspective_python-%PKG_VERSION%.data
xcopy /s /y %SRC_DIR%\perspective_python-%PKG_VERSION%.data perspective_python-%PKG_VERSION%.data\
cd rust\\perspective-client
set CARGO_FEATURE_EXTERNAL_PROTO=1
cargo build
cd ..\\..\\
set CARGO_FEATURE_EXTERNAL_PROTO=
%PYTHON% -m pip install . -vv
%PYTHON% %RECIPE_DIR%\\copy.py

