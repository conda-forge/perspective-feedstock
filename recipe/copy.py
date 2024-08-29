import glob
import os
import shutil
import platform

d = os.path.join(os.environ["SP_DIR"], "perspective")
os.makedirs(d, exist_ok=True)

os_name = platform.system().lower()
machine = platform.machine()
machine = machine if machine != "aarch64" else "arm64"
ext = "dll" if os == "windows" else "so"

ext = "so"
if platform.system().lower() == "windows":
    ext = "dll"
arch = platform.machine().lower()
if arch == "amd64":
    arch = "x86_64"
dylib_name = f"{platform.system().lower()}-{arch}-libpsp.{ext}"

for ext_to_copy in ["so", "dylib", "dll", "pyd"]:
    for f in glob.glob(f"target/**/libpsp.{ext_to_copy}", recursive=True):
        shutil.copy(f, os.path.join(d, dylib_name))

