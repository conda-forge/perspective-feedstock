set PSP_ARCH=x86_64
@REM If your build is hosted on a non-D: drive, like at C:\bld, you may need to adjust the
@REM CARGO_TARGET_DIR value to use the same drive as the build, or else you may encounter an error like this:
@REM Error: Os { code: 17, kind: CrossesDevices, message: "The system cannot move the file to a different disk drive." }
@REM Alternately, set CONDA_BLD_PATH to somewhere on D:\
set "CARGO_TARGET_DIR=D:\psp-rust"

%PYTHON% -m pip install . -vv
