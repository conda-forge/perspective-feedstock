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

if [[ "${target_platform}" == "osx-arm64" ]]; then
  # abseil's cmake (bundled in protobuf v27.x) uses an Apple+Clang multi-arch
  # code path that generates "-Xarch_x86_64 -msse4.1" compile flags for ALL
  # Apple+Clang builds, expecting a fat-binary build system to gate them by
  # arch.  conda's single-arch LLVM arm64 clang does not honour the
  # "-Xarch_x86_64" guard and applies "-msse4.1" to the arm64 compilation,
  # producing a hard (unsuppressible) compiler error.  Work around this by
  # wrapping the CXX compiler in a launcher that strips x86-specific SIMD
  # flags before they reach the compiler.
  ARM64_LAUNCHER="${SRC_DIR}/arm64_cxx_launcher.sh"
  cat > "${ARM64_LAUNCHER}" << 'LAUNCHER_EOF'
#!/bin/bash
# cmake compiler launcher: strip x86-specific SIMD flags for arm64 builds.
# cmake invokes this as: launcher <compiler> [flags...]
COMPILER="$1"; shift
args=()
for arg in "$@"; do
  case "$arg" in
    -msse*|-mavx*|-maes)
      ;;  # strip x86 SIMD flags that are hard errors on arm64
    *)
      args+=("$arg")
      ;;
  esac
done
exec "$COMPILER" "${args[@]}"
LAUNCHER_EOF
  chmod +x "${ARM64_LAUNCHER}"
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CXX_COMPILER_LAUNCHER=${ARM64_LAUNCHER} -DCMAKE_C_COMPILER_LAUNCHER=${ARM64_LAUNCHER}"
fi

$PYTHON -m pip install . -vv

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
