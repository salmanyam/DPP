#!/bin/bash

mkdir -p cmake_dir
cd cmake_dir
wget https://github.com/Kitware/CMake/releases/download/v3.27.0-rc2/cmake-3.27.0-rc2.tar.gz
tar -xvf cmake-3.27.0-rc2.tar.gz
sudo apt-get install libssl-dev

cd cmake-3.27.0-rc2
./configure
make
sudo make install

cd ../..
