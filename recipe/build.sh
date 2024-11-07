#!/bin/bash
set -ex

# NOTE(tomjakubowski): don't understand why it's needed to set PKG_CONFIG_PATH.
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

echo "PKG_CONFIG_PATH: $PKG_CONFIG_PATH"
echo "PSP_ARCH: $PSP_ARCH"
$PYTHON -m pip install . -vv
