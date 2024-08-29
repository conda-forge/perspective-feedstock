export CARGO_FEATURE_EXTERNAL_CPP=1
export PSP_ROOT_DIR=$SRC_DIR/perspective-cpp
cd perspective_python-${PKG_VERSION}
cp -r ../perspective_python-${PKG_VERSION}.data .
cd rust/perspective-client
export CARGO_FEATURE_EXTERNAL_PROTO=1
cargo build
cd ../../
unset CARGO_FEATURE_EXTERNAL_PROTO
${PYTHON} -m pip install . -vv
${PYTHON} ${RECIPE_DIR}/copy.py
