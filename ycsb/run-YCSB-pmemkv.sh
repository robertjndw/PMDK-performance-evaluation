#!/bin/bash
RESULT_PATH=$RESULT_PATH/pmemkv
mkdir -p $RESULT_PATH

REPEATS=10
MAX_THREADS=16
MAX_VALUESIZE=8192

declare -a workloads=( a b c d )

# ##### Benchmark pmemkv #####
# pmemkv parameters
mkdir -p $MOUNT_PM/pmemkvYCSB
chown $(whoami) $MOUNT_PM/pmemkvYCSB
DATABASE_PATH=$MOUNT_PM/pmemkvYCSB/database
DATABASE_SIZE=1073741824 # 10GB

##### THREAD SECTION #####
RESULT_PATH_SECTION=$RESULT_PATH/threads
mkdir -p $RESULT_PATH_SECTION
for (( thread=1; thread<=$MAX_THREADS; thread=thread+1 )); do
    echo  "##### Run YCSB for pmemkv and thread ${thread} #####"
    RESULT_PATH_THREAD=$RESULT_PATH_SECTION/${thread}_threads
    mkdir -p $RESULT_PATH_THREAD

    # First test the performance of the load operation
    for i in $(seq 1 $REPEATS); do
        # Load the values for the workload, only load workloada once
        # All other use these loaded values
        (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb load pmemkv -P workloads/workloada -P $CURRENT_PATH/large.dat -p pmemkv.dbpath=$DATABASE_PATH -p pmemkv.dbsize=$DATABASE_SIZE -p pmemkv.engine=cmap -p threadcount=$thread -s) > $RESULT_PATH_THREAD/Load_$i.log
        for w in "${workloads[@]}"; do
            # Execute the actual benchmark operation
            (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb run pmemkv -P workloads/workload$w -P $CURRENT_PATH/large.dat -p pmemkv.dbpath=$DATABASE_PATH -p pmemkv.dbsize=$DATABASE_SIZE -p pmemkv.engine=cmap -p threadcount=$thread -s) > $RESULT_PATH_THREAD/Workload${w}_$i.log
        done
        rm -rf $DATABASE_PATH
    done
done
echo "##### YCSB pmemkv threads DONE #####"
for thread in $(seq 1 $MAX_THREADS ); do
    RESULT_PATH_THREAD=$RESULT_PATH_SECTION/${thread}_threads
    
    echo  "##### Generating avg file for pmemkv and thread ${thread} #####"
    declare -a files=( )
    for i in $(seq 1 $REPEATS); do
        files+=( $RESULT_PATH_THREAD/Load_$i.log )
    done
    python3 avg.py --files ${files[@]} -r $RESULT_PATH_THREAD/Load.log

    for w in "${workloads[@]}"; do
        declare -a files=( )
        for i in $(seq 1 $REPEATS); do
            files+=( $RESULT_PATH_THREAD/Workload${w}_$i.log )
        done
        python3 avg.py --files ${files[@]} -r $RESULT_PATH_THREAD/Workload${w}.log
    done
done

##### VALUESIZE SECTION #####
RESULT_PATH_SECTION=$RESULT_PATH/valuesize
mkdir -p $RESULT_PATH_SECTION
for (( valuesize=8; valuesize<=$MAX_VALUESIZE; valuesize=valuesize*2 )); do
    echo  "##### Run YCSB for pmemkv and valuesize ${valuesize} #####"
    RESULT_PATH_VALUESIZE=$RESULT_PATH_SECTION/${valuesize}_valuesize
    mkdir -p $RESULT_PATH_VALUESIZE

    # First test the performance of the load operation
    for i in $(seq 1 $REPEATS); do
        # Load the values for the workload, only load workloada once
        # All other use these loaded values
        (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb load pmemkv -P workloads/workloada -P $CURRENT_PATH/large.dat -p pmemkv.dbpath=$DATABASE_PATH -p pmemkv.dbsize=$DATABASE_SIZE -p pmemkv.engine=cmap -p fieldlength=$valuesize -s) > $RESULT_PATH_VALUESIZE/Load_$i.log
        for w in "${workloads[@]}"; do
            # Execute the actual benchmark operation
            (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb run pmemkv -P workloads/workload$w -P $CURRENT_PATH/large.dat -p pmemkv.dbpath=$DATABASE_PATH -p pmemkv.dbsize=$DATABASE_SIZE -p pmemkv.engine=cmap -p fieldlength=$valuesize -s) > $RESULT_PATH_VALUESIZE/Workload${w}_$i.log
        done
        rm -rf $DATABASE_PATH
    done
done
echo "##### YCSB pmemkv valuesize DONE #####"
for (( valuesize=8; valuesize<=$MAX_VALUESIZE; valuesize=valuesize*2 )); do
    RESULT_PATH_VALUESIZE=$RESULT_PATH_SECTION/${valuesize}_valuesize
    
    echo  "##### Generating avg file for pmemkv and valuesize ${valuesize} #####"
    declare -a files=( )
    for i in $(seq 1 $REPEATS); do
        files+=( $RESULT_PATH_VALUESIZE/Load_$i.log )
    done
    python3 avg.py --files ${files[@]} -r $RESULT_PATH_VALUESIZE/Load.log

    for w in "${workloads[@]}"; do
        declare -a files=( )
        for i in $(seq 1 $REPEATS); do
            files+=( $RESULT_PATH_VALUESIZE/Workload${w}_$i.log )
        done
        python3 avg.py --files ${files[@]} -r $RESULT_PATH_VALUESIZE/Workload${w}.log
    done
done
# Remove the whole folder
sudo rm -rf $MOUNT_PM/pmemkvYCSB