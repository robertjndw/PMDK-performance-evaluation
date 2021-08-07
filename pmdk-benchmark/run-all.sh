#!/bin/bash

# Specify the parameter before running the actual benchmark
# The values be used in all subsequental benchmarking scripts
LD_LIBRARY_PATH=/pmdk/src/nondebug
PMEMBENCH=/pmdk/src/benchmarks/pmembench
MOUNT_PM=/mnt/pmem0
RESULT_PATH=/results

printSection (){
    echo -e "###### $1 ######"
}

# PMEMBENCH_DIR="$(dirname "${PMEMBENCH}")"
# echo $PMEMBENCH_DIR
# patch --forward --silent -ruN --directory=$PMEMBENCH_DIR < pmdk-bench.patch
# printSection "Executing make file"
# (cd $PMEMBENCH_DIR && make)

# No arguments means execute all benchmarks
if [ $# -eq 0 ]; then
    printSection "Starting all benchmarks"
    declare -a subfolder=( flush libpmem2 memcpy memset pmalloc pmemlocks tx tx_add_range )

    for f in "${subfolder[@]}"; do
        printSection $f
        (cd $f && . ./run.sh)
    done
else
    for var in "$@"; do
        case "$var" in
            "flush"|"libpmem2"|"libpmem2_cmp"|"memcpy"|"memset"|"pmalloc"|"pmemlocks"|"tx"|"tx_add_range") printSection $var; (cd $var && . ./run.sh);;
            *)
                echo "Unknown option: ${var}"
                echo "Available options are: flush, libpmem2, memcpy, memset, pmalloc, pmemlocks, tx, tx_add_range"
                ;;
        esac
    done
fi

exit 0