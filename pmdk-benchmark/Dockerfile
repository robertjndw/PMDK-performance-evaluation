FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies for PMDK
RUN apt-get update && apt-get -qq install -y \
    autoconf \
    automake \
    pkg-config \
    libndctl-dev \
    libdaxctl-dev \
    libglib2.0-dev \
    libncurses5-dev \
    libfuse-dev \
    libuv1-dev \
    pandoc \
    libfabric-dev \
    # Dependencies to compile PMDK
    git \
    build-essential

# Add the shared library path
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

COPY pmdk-bench.patch /pmdk-benchmark/

# Clone PMDK and install
RUN git clone https://github.com/pmem/pmdk.git /pmdk
WORKDIR /pmdk
RUN git checkout 1.11.0
RUN patch --forward --silent -ruN --directory=/pmdk/src/benchmarks < /pmdk-benchmark/pmdk-bench.patch
RUN make -j4
RUN make -j4 install

COPY . /pmdk-benchmark
WORKDIR /pmdk-benchmark

# Necessary to mount the device and use full potential
ENTRYPOINT mkdir /mnt/pmem0 && mount -o dax /dev/pmem0 /mnt/pmem0  && /bin/bash