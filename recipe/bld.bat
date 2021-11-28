
set 
%PYTHON%   setup.py ^
           build_ext ^
           install --single-version-externally-managed ^
                   --record=record.txt
if errorlevel 1 exit 1

dir perspective/
dir perspective/table/

dumpbin /dependents perspective/table/libbinding.pyd
dumpbin /dependents perspective/table/libpsp.dll

