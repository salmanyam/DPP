#!/bin/bash
  
# go to the dpp-llvm dir
cd dpp-llvm

# create a build directory and cd into it
mkdir -p build && cd build

# configure the build
cmake -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" -DLLVM_EXTERNAL_PROJECTS=SVF -DLLVM_EXTERNAL_SVF_SOURCE_DIR=${PWD}/../../SVF -DCMAKE_BUILD_TYPE=Release -G Ninja ../llvm

# build
ninja
