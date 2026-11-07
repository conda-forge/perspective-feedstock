# Perspective sets this to the truthy list "OFF;FORCE" in its parent scope.
# Reset it inside Protobuf's project() before its option() declarations run.
set(protobuf_BUILD_TESTS OFF)

# The Rust linker collects local static archives, so build Protobuf's dependencies
# locally instead of finding shared Abseil libraries in the CI tooling environment.
set(protobuf_FORCE_FETCH_DEPENDENCIES ON)
