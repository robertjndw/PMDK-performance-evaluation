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
    build-essential \
    # Install dependencies for memkind
    libnuma-dev \
    libtool \
    numactl \
    unzip \
    # Install dependencies for libpmemobj-cpp
    libpmemobj-dev \
    cmake \
    # Install dependencies for pmemkv
    libtbb-dev

# Add the shared library path
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install PMDK
WORKDIR /
RUN git clone https://github.com/pmem/pmdk.git /pmdk
WORKDIR /pmdk
RUN git checkout 1.11.0
RUN make -j4
RUN make -j4 install

# Install memkind
WORKDIR /
RUN git clone https://github.com/memkind/memkind.git /memkind
WORKDIR /memkind
RUN git checkout v1.11.0
RUN ./autogen.sh
RUN ./configure
RUN make -j4
RUN make -j4 install

# Install libpmemobj-cpp
WORKDIR /
RUN git clone https://github.com/pmem/libpmemobj-cpp.git /libpmemobj-cpp
WORKDIR /libpmemobj-cpp
RUN git checkout stable-1.12
RUN mkdir build
WORKDIR /libpmemobj-cpp/build
RUN cmake -j4 .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOC=OFF -DBUILD_BENCHMARKS=OFF
RUN make -j4
RUN make -j4 install

# Install pmemkv
WORKDIR /
RUN git clone https://github.com/pmem/pmemkv.git /pmemkv
WORKDIR /pmemkv
RUN git checkout 1.4
RUN mkdir build
WORKDIR /pmemkv/build
RUN cmake -j4 .. -DCMAKE_BUILD_TYPE=Release -DBUILD_JSON_CONFIG=OFF -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOC=OFF
RUN make -j4
RUN make -j4 install

# Install pmemkv-bench
COPY pmemkv-bench.patch /pmemkv-bench-scripts/
WORKDIR /
RUN git clone https://github.com/pmem/pmemkv-bench.git /pmemkv-bench
WORKDIR /pmemkv-bench
RUN git checkout 32d94c0
RUN patch --forward --silent -ruN --directory=/pmemkv-bench/bench < /pmemkv-bench-scripts/pmemkv-bench.patch
RUN make bench

COPY . /pmemkv-bench-scripts
WORKDIR /pmemkv-bench-scripts

# Necessary to mount the device and use full potential
ENTRYPOINT mkdir /mnt/pmem0 && mount -o dax /dev/pmem0 /mnt/pmem0  && /bin/bash