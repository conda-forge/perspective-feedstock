#!/bin/bash
set -ex

export PYO3_PYTHON="$PYTHON"

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
export MATURIN_PEP517_ARGS="--features abi3"

# When cross-compiling osx-arm64 from osx-64, cmake (used by the protobuf-src
# Rust crate) uses the arm64 cross-linker for x86_64 BUILD tools such as
# protoc-gen-upb_minitable. This causes a linker error:
#   ld: symbol(s) not found for architecture x86_64
# Fix: provide a cmake toolchain file that uses the system compiler (which
# handles x86_64 natively on the Rosetta runner) for BUILD tools only.
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
    export CMAKE_TOOLCHAIN_FILE="${SRC_DIR}/cmake_cross_toolchain.cmake"
    cat > "${CMAKE_TOOLCHAIN_FILE}" << 'TOOLCHAIN'
set(CMAKE_C_COMPILER_FOR_BUILD "/usr/bin/clang")
set(CMAKE_CXX_COMPILER_FOR_BUILD "/usr/bin/clang++")
set(CMAKE_EXE_LINKER_FLAGS_FOR_BUILD "" CACHE STRING "")
set(CMAKE_SHARED_LINKER_FLAGS_FOR_BUILD "" CACHE STRING "")
TOOLCHAIN
fi

$PYTHON -m pip install . -vv

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
