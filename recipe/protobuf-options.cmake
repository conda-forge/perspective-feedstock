# Perspective sets this to the truthy list "OFF;FORCE" in its parent scope.
# Reset it inside Protobuf's project() before its option() declarations run.
set(protobuf_BUILD_TESTS OFF)
