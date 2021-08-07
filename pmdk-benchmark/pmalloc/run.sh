#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/pmalloc
mkdir -p $RESULT_PATH

echo "Running pmalloc"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_pmalloc.cfg -f $MOUNT_PM/pmalloc.pmem -r $REPEATS > $RESULT_PATH/pmalloc.csv
rm $MOUNT_PM/pmalloc.pmem 

echo "Running pmalloc ops"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_pmalloc_ops.cfg -f $MOUNT_PM/pmalloc.pmem -r $REPEATS > $RESULT_PATH/pmalloc_ops.csv
rm $MOUNT_PM/pmalloc.pmem 

echo "Running pmalloc thread 4KB"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_pmalloc_thread_4KB.cfg -f $MOUNT_PM/pmalloc_thread.pmem -r $REPEATS > $RESULT_PATH/pmalloc_thread_4KB.csv
rm $MOUNT_PM/pmalloc_thread.pmem 

echo "Running pmalloc thread 256B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_pmalloc_thread_256B.cfg -f $MOUNT_PM/pmalloc_thread.pmem -r $REPEATS > $RESULT_PATH/pmalloc_thread_256B.csv
rm $MOUNT_PM/pmalloc_thread.pmem 

echo "Running pmalloc thread 64B"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_pmalloc_thread_64B.cfg -f $MOUNT_PM/pmalloc_thread.pmem -r $REPEATS > $RESULT_PATH/pmalloc_thread_64B.csv
rm $MOUNT_PM/pmalloc_thread.pmem 