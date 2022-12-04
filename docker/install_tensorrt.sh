#!/bin/bash

set -euxo pipefail

"${CUDA_LIB_VERSION:=11.8}"
"${CUDA_PKG_VERSION:=11-8}"
"${CUDNN_VERSION:=8.6.0.84}"
"${TENSORRT_VERSION:=7.2.2}"

# Add NVidia Repo
# wget -q -O - https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/3bf863cc.pub | apt-key add -
# echo "deb https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/ /" | tee /etc/apt/sources.list.d/nvidia-cuda.list
wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
add-apt-repository contrib
apt-get -qq update

# CUDA Base
apt-get install -y --no-install-recommends \
    cuda-cudart-${CUDA_PKG_VERSION} \
    cuda-compat-${CUDA_PKG_VERSION} \
    cuda-cupti-${CUDA_PKG_VERSION} && \
    ln -s cuda-${CUDA_LIB_VERSION} /usr/local/cuda

# CUDA Runtime
apt-get install -y --no-install-recommends \
    cuda-libraries-${CUDA_PKG_VERSION} \
    libnpp-${CUDA_PKG_VERSION} \
    cuda-nvtx-${CUDA_PKG_VERSION} \
    libcublas-${CUDA_PKG_VERSION}

# cuDNN Runtime
apt-get install -y --no-install-recommends \
    libcudnn8

# TensorRT Runtime
apt-get install -y --no-install-recommends \
    libvinfer
