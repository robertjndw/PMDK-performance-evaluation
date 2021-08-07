FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies for PMDK
RUN apt-get update && apt-get -qq install -y \
    # Install dependencies for PMDK
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
    # Dependencies to get and compile PMDK
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
    libtbb-dev \
    # Install dependencies for Mongo
    wget \
    python2 \
    scons \
    # Install dependencies for postgres
    libreadline-dev \
    bison \
    flex \
    # Install dependencies for Redis
    libtool \
    tcl \
    # Install dependencies for postgres
    libreadline-dev \
    bison \
    flex \
    # Install dependencies for YCSB
    openjdk-8-jdk \
    maven \
    sudo \
    python-is-python2

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

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

# Install pmemkv-java
WORKDIR /
RUN git clone https://github.com/pmem/pmemkv-java.git /pmemkv-java
WORKDIR /pmemkv-java
RUN git checkout 1.0.1
RUN mvn install

# Install mongo
WORKDIR /
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && python2 get-pip.py && rm get-pip.py
RUN git clone https://github.com/mongodb/mongo.git /mongo
RUN git clone https://github.com/pmem/pmse.git /pmse
WORKDIR /mongo
RUN git checkout r3.5.13 -b r3.5.13
RUN pip2 install -r buildscripts/requirements.txt
RUN mkdir -p src/mongo/db/modules/
RUN ln -sf /pmse src/mongo/db/modules/pmse
RUN python2 buildscripts/scons.py LIBPATH=/usr/local/lib/ -j4 core --disable-warnings-as-errors --dbg=off --opt=on

# Install redis-pmem
WORKDIR /
RUN git clone https://github.com/pmem/pmem-redis /redis-pmem
WORKDIR /redis-pmem
RUN git submodule init && git submodule update
RUN make -j4 USE_NVM=yes

# Install postgres
WORKDIR /
COPY ./dependencies/v5-0001-Add-configure-option-for-PMDK.patch /postgres-patchfiles/
COPY ./dependencies/v5-0002-Read-write-WAL-files-using-PMDK.patch /postgres-patchfiles/
COPY ./dependencies/v5-0003-Walreceiver-WAL-IO-using-PMDK.patch /postgres-patchfiles/
RUN git clone https://git.postgresql.org/git/postgresql.git /postgres
WORKDIR /postgres
RUN git checkout 9e7dbe3
# Credit: https://www.postgresql.org/message-id/CAOwnP3O3O1GbHpddUAzT=CP3aMpX99=1WtBAfsRZYe2Ui53MFQ@mail.gmail.com
# Needed for git am
RUN git config --global user.email "ycsb.docker@example.de"
RUN git config --global user.name "YCSB Docker"
RUN git am /postgres-patchfiles/v5-0001-Add-configure-option-for-PMDK.patch
RUN git am /postgres-patchfiles/v5-0002-Read-write-WAL-files-using-PMDK.patch
RUN git am /postgres-patchfiles/v5-0003-Walreceiver-WAL-IO-using-PMDK.patch
RUN rm -rf /postgres-patchfiles

RUN ./configure --with-libpmem
RUN make -j4
RUN make -j4 install
RUN adduser --disabled-password --gecos "" postgres

# Install YCSB
WORKDIR /
RUN git clone https://github.com/pmem/YCSB.git /YCSB
WORKDIR /YCSB
RUN git checkout 41e8994
# RUN mvn clean package

COPY run-YCSB-pmemkv.sh \
    run-YCSB-redis-pmem.sh \
    run-YCSB-mongodb.sh \
    run-YCSB-mongodb-original.sh \
    run-YCSB-postgresql.sh \
    large.dat \
    avg.py \
    run-all.sh \
    # Dest
    /YCSB-scripts/

WORKDIR /YCSB-scripts

# Necessary to mount the device and use full potential
ENTRYPOINT mkdir /mnt/pmem0 && mount -o dax /dev/pmem0 /mnt/pmem0  && /bin/bash