#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/memcpy
mkdir -p $RESULT_PATH

echo "Running memcpy seq"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memcpy_seq.cfg -f $MOUNT_PM/memcpy_seq.pmem -r $REPEATS > $RESULT_PATH/memcpy_seq.csv
rm $MOUNT_PM/memcpy_seq.pmem

echo "Running memcpy rand"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memcpy_rand.cfg -f $MOUNT_PM/memcpy_rand.pmem -r $REPEATS > $RESULT_PATH/memcpy_rand.csv
rm $MOUNT_PM/memcpy_rand.pmem

echo "Running memcpy thread 4KB"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memcpy_thread_4KB.cfg -f $MOUNT_PM/memcpy_thread.pmem -r $REPEATS > $RESULT_PATH/memcpy_thread_4KB.csv
rm $MOUNT_PM/memcpy_thread.pmem

echo "Running memcpy thread 256B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memcpy_thread_256B.cfg -f $MOUNT_PM/memcpy_thread_256B.pmem -r $REPEATS > $RESULT_PATH/memcpy_thread_256B.csv
rm $MOUNT_PM/memcpy_thread_256B.pmem

echo "Running memcpy thread 64B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_memcpy_thread_64B.cfg -f $MOUNT_PM/memcpy_thread_64B.pmem -r $REPEATS > $RESULT_PATH/memcpy_thread_64B.csv
rm $MOUNT_PM/memcpy_thread_64B.pmem