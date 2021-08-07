#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/pmemlocks
mkdir -p $RESULT_PATH

echo "Running single mutex"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./single_mutex.cfg -f $MOUNT_PM/pmem_lock.pmem -r $REPEATS > $RESULT_PATH/single_mutex.csv
rm $MOUNT_PM/pmem_lock.pmem

echo "Running multi mutex"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./multi_mutex.cfg -f $MOUNT_PM/pmem_lock.pmem -r $REPEATS > $RESULT_PATH/multi_mutex.csv
rm $MOUNT_PM/pmem_lock.pmem

echo "Running multi mutex all"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./multi_mutex_all.cfg -f $MOUNT_PM/pmem_lock.pmem -r $REPEATS > $RESULT_PATH/multi_mutex_all.csv
rm $MOUNT_PM/pmem_lock.pmem

echo "Running rw locks"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./rw_locks.cfg -f $MOUNT_PM/pmem_lock.pmem -r $REPEATS > $RESULT_PATH/rw_locks.csv
rm $MOUNT_PM/pmem_lock.pmem