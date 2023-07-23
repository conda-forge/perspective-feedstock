#!/bin/bash
curl https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.gz -o boost_1_82_0.tar.gz
tar xfzv boost_1_82_0.tar.gz
pushd boost_1_82_0
./bootstrap.sh
./b2 -j8 cxxflags=-fPIC cflags=-fPIC link=static -a --with-program_options --with-filesystem --with-thread --with-system install 
popd
rm -rf boost_1_82_0
