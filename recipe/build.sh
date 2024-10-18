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

echo "PSP_ARCH: $arch"

pnpm install --filter '@finos/perspective-python'

# Run perspective git-source build
export PACKAGE=perspective-python
export PSP_BUILD_WHEEL=1
export PROTOC
PROTOC=$(which protoc)

# FIXME: Need to be able to run generate-metadata _without_ compiling all the
# crates in the workspace. For right now, create blank supplemental rustdocs
touch rust/perspective-client/docs/expression_gen.md

pnpm run build

# Install wheel to site-packages ($SP_DIR), wherefrom Conda assembles the .conda package contents
$PYTHON -m pip install rust/target/wheels/perspective_python*.whl -vv
