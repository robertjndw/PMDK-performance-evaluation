#!/bin/bash
MONGODB_PATH=/mongo

RESULT_PATH=$RESULT_PATH/mongodb-original
mkdir -p $RESULT_PATH

REPEATS=10

declare -a workloads=( a b c d )

##### Benchmark mongodb #####
# mongodb parameters
DATABASE_PATH=$MOUNT_PM/mongodb
mkdir -p $DATABASE_PATH

sudo chown $(whoami) $DATABASE_PATH
# Start the mongodb server
(cd $MONGODB_PATH && ./mongod --dbpath=$DATABASE_PATH --fork --syslog &) > /dev/null
sleep 1

for i in $(seq 1 $REPEATS); do
    (cd $PATH_YCSB && ./bin/ycsb load mongodb -P workloads/workloada -P $CURRENT_PATH/large.dat -s) | tail -n +2 > $RESULT_PATH/Load_$i.log
    for w in "${workloads[@]}"; do
    # Execute the actual benchmark operation
        (cd $PATH_YCSB && ./bin/ycsb run mongodb -P workloads/workload$w -P $CURRENT_PATH/large.dat -s) | tail -n +2 > $RESULT_PATH/Workload${w}_$i.log  
    done
    sleep 1
    (cd $MONGODB_PATH && ./mongo ycsb --eval "db.dropDatabase()")
done

# Stop the database after finishing the tests
(cd $MONGODB_PATH && killall mongod) > /dev/null
sudo rm -rf $DATABASE_PATH
sleep 1
echo "##### YCSB mongodb original DONE #####"

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