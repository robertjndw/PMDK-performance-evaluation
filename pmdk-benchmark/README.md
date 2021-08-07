# PMDK-Benchmark

## Usage
To use the script just edit the `run-all.sh`. Add your custom values for `LD_LIBRARY_PATH`,`PMEMBENCH`,`MOUNT_PM` and `RESULT_PATH`.

Afterwards, you can execute all benchmarks with the single command `./run-all.sh`. Make sure that the script is executable.

## Docker
You can run all the tests using a Dockerfile. You do not need to modify the paths in `run-all.sh`, because by default they will work with the docker configuration.

1. Build the Docker-Image `docker build -t pmem .`
2. Create result directory to bind it into the Container by running: `mkdir -p results`
3. Run the Docker-Container `docker run --privileged --device=/dev/pmem0:/dev/pmem0 -v $(pwd)/results:/results --security-opt seccomp:unconfined -it pmem /bin/bash` (adapt the path from /dev/pmem0 to the mount of the persistent memory or to /dev/shm for DRAM)
4. Inside the Docker-container, you can now run the script with `./run-all.sh`. This will run consecutively all benchmarks and store the resulting csv in the `./results` 

## List of Benchmarks
| Benchmarks        | Description             |
| ------------- |:-------------| 
| flush     | Compare flush, persist, msync and deep_persist |
| libpmem2      | Compare libpmem2 persisting mechanism against libpmem | 
| memcpy | Compare libpmem pmem_memcpy against libc memcpy variations | 
| memset | Compare libpmem pmem_memset against libc memset variations | 
| pmalloc | Compare low-level allocation methods | 
| pmemlocks | Compare synchronization mechanism of libpmemobj with POSIX | 
| tx | Compare libpmemobj atomic and transactional allocations| 
| tx_add_range | Examine performance behavior of snapshotting | 
