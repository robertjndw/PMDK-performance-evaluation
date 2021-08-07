#!/bin/bash
REDIS_PATH=/redis-pmem

RESULT_PATH=$RESULT_PATH/redis
mkdir -p $RESULT_PATH

REPEATS=10

declare -a workloads=( a b c d )

##### Benchmark redis-pmem #####
# redis parameters
DATABASE_PATH=$MOUNT_PM/redis
mkdir -p $DATABASE_PATH

DATABASE_SIZE=10 # 10GB

for i in $(seq 1 $REPEATS); do
    # Start the redis server
    (cd $REDIS_PATH && ./src/redis-server --nvm-maxcapacity $DATABASE_SIZE --nvm-dir $DATABASE_PATH --nvm-threshold 64 &) > /dev/null
    sleep 1
    (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb load redis -P workloads/workloada -P $CURRENT_PATH/large.dat -p "redis.host=127.0.0.1" -p "redis.port=6379" -s) > $RESULT_PATH/Load_$i.log
    for w in "${workloads[@]}"; do
    # Execute the actual benchmark operation
        (cd $PATH_YCSB && PMEM_IS_PMEM_FORCE=1 ./bin/ycsb run redis -P workloads/workload$w -P $CURRENT_PATH/large.dat -p "redis.host=127.0.0.1" -p "redis.port=6379" -s) > $RESULT_PATH/Workload${w}_$i.log  
    done
    # Stop the database after finishing the tests
    (cd $REDIS_PATH/src && ./redis-cli flushall && pkill redis-server)
    # Sleep to make sure database is down before deleting database
    sleep 1
    (cd $DATABASE_PATH && rm -rf *)
done

sudo rm -rf $DATABASE_PATH
echo "##### YCSB Redis DONE #####"

echo  "##### Generating avg file for ${bench} #####"
declare -a files=( )
for i in $(seq 1 $REPEATS); do
    files+=( $RESULT_PATH/Load_$i.log )
done
python3 avg.py --files ${files[@]} -r $RESULT_PATH/Load.log

for w in "${workloads[@]}"; do
    declare -a files=( )
    for i in $(seq 1 $REPEATS); do
        files+=( $RESULT_PATH/Workload${w}_$i.log )
    done
    python3 avg.py --files ${files[@]} -r $RESULT_PATH/Workload${w}.log
done