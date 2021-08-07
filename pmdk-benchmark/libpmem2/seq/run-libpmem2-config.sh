#!/bin/bash
echo "Running libpmem"
# Start with pmem section
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem.cfg -f $MOUNT_PM/pmem2_seq.pmem -r $REPEATS > $RESULT_PATH/libpmem2_seq.csv
rm $MOUNT_PM/pmem2_seq.pmem
# Append the different files for the granularity settings
echo "Running libpmem2 BYTE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=BYTE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_byte.cfg -f $MOUNT_PM/pmem2_seq.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_seq.csv
rm $MOUNT_PM/pmem2_seq.pmem
echo "Running libpmem2 CACHE_LINE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=CACHE_LINE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_cacheline.cfg -f $MOUNT_PM/pmem2_seq.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_seq.csv
rm $MOUNT_PM/pmem2_seq.pmem
echo "Running libpmem2 PAGE"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH PMEM2_FORCE_GRANULARITY=PAGE PMEM_IS_PMEM_FORCE=1 $PMEMBENCH ./pmembench_libpmem2_page.cfg -f $MOUNT_PM/pmem2_seq.pmem -r $REPEATS >> $RESULT_PATH/libpmem2_seq.csv
rm $MOUNT_PM/pmem2_seq.pmem