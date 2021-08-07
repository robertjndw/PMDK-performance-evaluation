#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/libpmem2
mkdir -p $RESULT_PATH

cd rand
. ./run-libpmem2-config.sh
cd ..

cd seq
. ./run-libpmem2-config.sh
cd ..

cd thread_4KB
. ./run-libpmem2-config.sh
cd ..

cd thread_256B
. ./run-libpmem2-config.sh
cd ..

cd thread_64B
. ./run-libpmem2-config.sh
cd ..