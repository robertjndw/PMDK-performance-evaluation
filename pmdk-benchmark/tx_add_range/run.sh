#!/bin/bash
REPEATS=100
RESULT_PATH=$RESULT_PATH/tx_add_range
mkdir -p $RESULT_PATH

echo "Running tx"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./tx_add_range.cfg -f $MOUNT_PM/tx_add_range.pmem -r $REPEATS > $RESULT_PATH/tx_add_range.csv
rm $MOUNT_PM/tx_add_range.pmem

echo "Running ops"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./tx_add_range_ops.cfg -f $MOUNT_PM/tx_add_range.pmem -r $REPEATS > $RESULT_PATH/tx_add_range_ops.csv
rm $MOUNT_PM/tx_add_range.pmem

echo "Running threads"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./tx_add_range_thread.cfg -f $MOUNT_PM/tx_add_range.pmem -r $REPEATS > $RESULT_PATH/tx_add_range_thread.csv
rm $MOUNT_PM/tx_add_range.pmem
