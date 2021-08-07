#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/alloc_free
mkdir -p $RESULT_PATH

echo "Running tx alloc datasize"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_alloc_datasize.cfg -f $MOUNT_PM/tx_alloc.pmem -r $REPEATS > $RESULT_PATH/tx_alloc_datasize.csv
rm $MOUNT_PM/tx_alloc.pmem

echo "Running tx alloc ops"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_alloc_ops.cfg -f $MOUNT_PM/tx_alloc.pmem -r $REPEATS > $RESULT_PATH/tx_alloc_ops.csv
rm $MOUNT_PM/tx_alloc.pmem

echo "Running tx alloc threads"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_alloc_threads.cfg -f $MOUNT_PM/tx_alloc.pmem -r $REPEATS > $RESULT_PATH/tx_alloc_threads.csv
rm $MOUNT_PM/tx_alloc.pmem


echo "Running tx free datasize"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_free_datasize.cfg -f $MOUNT_PM/tx_free.pmem -r $REPEATS > $RESULT_PATH/tx_free_datasize.csv
rm $MOUNT_PM/tx_free.pmem

echo "Running tx free ops"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_free_ops.cfg -f $MOUNT_PM/tx_free.pmem -r $REPEATS > $RESULT_PATH/tx_free_ops.csv
rm $MOUNT_PM/tx_free.pmem

echo "Running tx free threads"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./obj_tx_free_threads.cfg -f $MOUNT_PM/tx_free.pmem -r $REPEATS > $RESULT_PATH/tx_free_threads.csv
rm $MOUNT_PM/tx_free.pmem
