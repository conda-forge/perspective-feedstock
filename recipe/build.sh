#!/bin/bash
set -ex

# XXX(tom): don't understand why it's needed to set PKG_CONFIG_PATH.
# this directory is already present in pkg-config's config path as reported by
# `pkg-config --variable pc_path pkg-config` in a --debug build environment.
# and yet `pkg-config <some-dependency>` fails
export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig/:$PKG_CONFIG_PATH

case "${target_platform}" in
linux-aarch64 | osx-arm64)
  arch="aarch64"
  ;;
*)
  arch="x86_64"
  ;;
esac
export PSP_ARCH=$arch

echo "PSP_ARCH: $arch"

pnpm install --filter '@finos/perspective-python'

# Run perspective git-source build
export PACKAGE=perspective-python
export PSP_BUILD_WHEEL=1
export PROTOC

# protobuf-src is patched out of the build.  its build script fails to link in
# an osx cross-compiling environment; the wrong toolchain is used.
PROTOC=$(which protoc)
pnpm run build

# Install wheel to site-packages ($SP_DIR), wherefrom Conda assembles the .conda package contents
$PYTHON -m pip install rust/target/wheels/perspective_python*.whl -vv