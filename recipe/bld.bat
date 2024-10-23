set "PROTOC="
for /f %%i in ('where protoc') do if not defined PROTOC set "PROTOC=%%i"
if not defined PROTOC echo "protoc not found" & exit /b 1

set PSP_BUILD_WHEEL=1
set PSP_ARCH=x86_64
set PACKAGE=perspective-python
set "PSP_ROOT_DIR=%SRC_DIR%"
@REM If your build is hosted on a non-D: drive, like at C:\bld, you may need to adjust the
@REM CARGO_TARGET_DIR value to use the same drive as the build, or else you may encounter an error like this:
@REM Error: Os { code: 17, kind: CrossesDevices, message: "The system cannot move the file to a different disk drive." }
set "CARGO_TARGET_DIR=D:\psp-rust"
call pnpm install --filter "@finos/perspective-python"

echo.> rust\perspective-client\docs\expression_gen.md

call pnpm run build
if errorlevel 1 exit /b 1

for %%w in (%CARGO_TARGET_DIR%\wheels\perspective_python*.whl) do "%PYTHON%" -m pip install "%%w" -vv
if errorlevel 1 exit /b 1

