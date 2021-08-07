#!/bin/bash
# Specify the parameter before running the actual benchmark
# The values be used in all subsequental benchmarking scripts
CURRENT_PATH=`pwd`
PATH_YCSB=/YCSB
MOUNT_PM=/mnt/pmem0
RESULT_PATH=/results

printSection (){
    echo -e "###### $1 ######"
}

# No arguments means execute all benchmarks
if [ $# -eq 0 ]; then
    printSection "Starting all benchmarks"
    declare -a operations=( "pmemkv" "redis" "mongodb" "mongodb-original" "postgresql" "postgresql-original" )

    for op in "${operations[@]}"; do
        printSection $op
        (. ./run-YCSB-${op}.sh)
    done
else
    for op in "$@"; do
        case "$op" in
            "pmemkv"|"redis"|"mongodb"|"mongodb-original"|"postgresql"|"postgresql-original") printSection $op; (. ./run-YCSB-${op}.sh);;
            *)
                echo "Unknown option: ${op}"
                echo "Available options are: pmemkv, redis, mongodb, mongodb-original, postgresql, postgresql-original"
                ;;
        esac
    done
fi

exit 0