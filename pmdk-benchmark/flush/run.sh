#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/flush
mkdir -p $RESULT_PATH

echo "Running flush rand"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_flush_rand.cfg -f $MOUNT_PM/flush_rand.pmem -r $REPEATS > $RESULT_PATH/flush_rand.csv
rm $MOUNT_PM/flush_rand.pmem

echo "Running flush seq"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_flush_seq.cfg -f $MOUNT_PM/flush_seq.pmem -r $REPEATS > $RESULT_PATH/flush_seq.csv
rm $MOUNT_PM/flush_seq.pmem

echo "Running threads 4KB"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_flush_thread_4KB.cfg -f $MOUNT_PM/flush_thread.pmem -r $REPEATS > $RESULT_PATH/flush_thread_4KB.csv
rm $MOUNT_PM/flush_thread.pmem

echo "Running threads 256B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_flush_thread_256B.cfg -f $MOUNT_PM/flush_thread_256B.pmem -r $REPEATS > $RESULT_PATH/flush_thread_256B.csv
rm $MOUNT_PM/flush_thread_256B.pmem

echo "Running threads 64B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_flush_thread_64B.cfg -f $MOUNT_PM/flush_thread_64B.pmem -r $REPEATS > $RESULT_PATH/flush_thread_64B.csv
rm $MOUNT_PM/flush_thread_64B.pmem