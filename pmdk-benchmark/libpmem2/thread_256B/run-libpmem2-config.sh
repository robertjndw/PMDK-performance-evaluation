#!/bin/bash
echo "Running libpmem2 thread 256B"
# Start with pmem section
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem_thread.cfg -f $MOUNT_PM/pmem2_thread.pmem -r $REPEATS > $RESULT_PATH/libpmem2_thread_256B.csv
rm $MOUNT_PM/pmem2_thread.pmem
# Append the different files for the granularity settings
echo "Running libpmem2 thread 256B BYTE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=BYTE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_thread_byte.cfg -f $MOUNT_PM/pmem2_thread.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_thread_256B.csv
rm $MOUNT_PM/pmem2_thread.pmem
echo "Running libpmem2 thread 256B CACHE_LINE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=CACHE_LINE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_thread_cacheline.cfg -f $MOUNT_PM/pmem2_thread.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_thread_256B.csv
rm $MOUNT_PM/pmem2_thread.pmem
echo "Running libpmem2 thread 256B PAGE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=PAGE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_thread_page.cfg -f $MOUNT_PM/pmem2_thread.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_thread_256B.csv
rm $MOUNT_PM/pmem2_thread.pmem