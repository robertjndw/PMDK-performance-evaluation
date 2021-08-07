#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/memset
mkdir -p $RESULT_PATH

echo "Running memset seq"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memset_seq.cfg -f $MOUNT_PM/memset_seq.pmem -r $REPEATS > $RESULT_PATH/memset_seq.csv
rm $MOUNT_PM/memset_seq.pmem

echo "Running memset rand"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memset_rand.cfg -f $MOUNT_PM/memset_rand.pmem -r $REPEATS > $RESULT_PATH/memset_rand.csv
rm $MOUNT_PM/memset_rand.pmem

echo "Running memset thread 4KB"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memset_thread_4KB.cfg -f $MOUNT_PM/memset_thread.pmem -r $REPEATS > $RESULT_PATH/memset_thread_4KB.csv
rm $MOUNT_PM/memset_thread.pmem

echo "Running memset thread 256B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memset_thread_256B.cfg -f $MOUNT_PM/memset_thread_256B.pmem -r $REPEATS > $RESULT_PATH/memset_thread_256B.csv
rm $MOUNT_PM/memset_thread_256B.pmem

echo "Running memset thread 64B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memset_thread_64B.cfg -f $MOUNT_PM/memset_thread_64B.pmem -r $REPEATS > $RESULT_PATH/memset_thread_64B.csv
rm $MOUNT_PM/memset_thread_64B.pmem