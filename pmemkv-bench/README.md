# pmemkv-bench requirements
- libpmemkv (requirement for this is libpmemobj-cpp)
- libpmempool (part of the PMDK)
- python3
(for a detailed list of required packages take a look at the Dockerfile)

# pmemkv-bench execution
Please modify the `MOUNT_PM` variable in the `run-pmemkv-bench-*.sh` scripts. This should point to the mounting point of the persistent memory.

## Docker
1. Build the Docker-Image `docker build -t pmemkv-bench .`
2. Create result directory to bind it into the Container by running: `mkdir -p results`
3. Run the Docker-Container `docker run --privileged --device=/dev/pmem0:/dev/pmem0 -v $(pwd)/results:/results --security-opt seccomp:unconfined -it pmemkv-bench /bin/bash` (adapt the path from /dev/shm to the mount of the persistent memory)
4. Inside the Docker-container, you can now run the script with `./run-script.sh`. This will run consecutively all benchmarks and store the resulting csv in the `./results`