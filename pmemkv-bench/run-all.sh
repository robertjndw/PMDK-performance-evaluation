#!/bin/bash
# Specify the parameter before running the actual benchmark
# The values be used in all subsequental benchmarking scripts
PMEMKVBENCH=/pmemkv-bench
MOUNT_PM=/mnt/pmem0
RESULT_PATH=/results

printSection (){
    echo -e "###### $1 ######"
}

# No arguments means execute all benchmarks
if [ $# -eq 0 ]; then
    printSection "Starting all benchmarks"
    declare -a operations=( "fill" "read" "randomreadwrite" "delete" "numops" )

    for op in "${operations[@]}"; do
        printSection $op
        (. ./run-pmemkv-bench-${op}.sh)
    done
else
    for op in "$@"; do
        case "$op" in
            "fill"|"read"|"randomreadwrite"|"delete"|"numops"|"test") printSection $op; (. ./run-pmemkv-bench-${op}.sh);;
            *)
                echo "Unknown option: ${op}"
                echo "Available options are: fill, read, randomreadwrite, delete, numops"
                ;;
        esac
    done
fi

exit 0