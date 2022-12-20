#!/bin/bash
set -euxo pipefail

# Utilities
apt-get -qq update
apt-get install -y \
    wget build-essential python3.9-dev python3-pip tar \
    libboost-dev libboost-python-dev libboost-thread-dev libxml2
mkdir -p /wheels

pip install --upgrade setuptools pip wheel numpy

# CUDA Library
wget -q --show-progress --progress=bar:force:noscroll https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run
chmod +x cuda_11.7.1_515.65.01_linux.run
./cuda_11.7.1_515.65.01_linux.run --silent --no-man-page --toolkit --installpath=/usr/local/cuda-11.7
export PATH=$PATH:/usr/local/cuda/bin

# Download pycuda source
wget -q --show-progress --progress=bar:force:noscroll https://github.com/inducer/pycuda/archive/refs/tags/v2022.2.tar.gz -O pycuda-v2022.2.tar.gz
tar xfz pycuda-v2022.2.tar.gz

# Build pycuda wheel
cd pycuda-2022.2
python3 configure.py --cuda-root=/usr/local/cuda --boost-python-libname=boost_python39
CUDA_INC_DIR=/usr/local/cuda/include make install
pip wheel --wheel-dir=/wheels .