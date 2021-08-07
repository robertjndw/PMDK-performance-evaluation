# YCSB requirements
- libpmemkv (requirement for this is libpmemobj-cpp)
- libpmempool (part of the PMDK)
- python3
(for a detailed list of required packages take a look at the Dockerfile)

# YCSB execution
Please modify the `MOUNT_PM` variable in the `run-YCSB-*.sh` scripts. This should point to the mounting point of the persistent memory.

## Docker
1. Build the Docker-Image `docker build -t ycsb .`
2. Create result directory to bind it into the Container by running: `mkdir -p results`
3. Run the Docker-Container `docker run --privileged --device=/dev/pmem0:/dev/pmem0 -v $(pwd)/results:/results --security-opt seccomp:unconfined -it ycsb /bin/bash` (adapt the path from /dev/shm to the mount of the persistent memory)