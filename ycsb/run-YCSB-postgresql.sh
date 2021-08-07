#!/bin/bash
POSTGRES_PATH=/postgres

RESULT_PATH=$RESULT_PATH/postgres
mkdir -p $RESULT_PATH

REPEATS=10

declare -a workloads=( a b c d )

# Prepare the PG_DATA directory
cd $POSTGRES_PATH
sudo mkdir $MOUNT_PM/pgsql_data
sudo chown postgres $MOUNT_PM/pgsql_data
# Initialize the database, replace config to use pmem_drain and start database server
(sudo -u postgres /usr/local/pgsql/bin/initdb -D $MOUNT_PM/pgsql_data) > /dev/null
sudo sed -i 's/#wal_sync_method = fsync/wal_sync_method = pmem_drain/g' $MOUNT_PM/pgsql_data/postgresql.conf
sudo -u postgres PMEM_IS_PMEM_FORCE=1 /usr/local/pgsql/bin/pg_ctl -s -D $MOUNT_PM/pgsql_data start

cd $CURRENT_PATH

# Bug where multiple threads generate duplicate key error
# Workaround only use one thread for insert
# First test the performance of the load operation
for i in $(seq 1 $REPEATS); do
    # Create table
    /usr/local/pgsql/bin/psql -U postgres -c "CREATE DATABASE ycsb;"
    /usr/local/pgsql/bin/psql ycsb -U postgres -c "CREATE TABLE usertable (YCSB_KEY VARCHAR(255) PRIMARY KEY not NULL, YCSB_VALUE JSONB not NULL);"
    /usr/local/pgsql/bin/psql ycsb -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE ycsb to postgres;"
    (cd $PATH_YCSB && ./bin/ycsb load postgrenosql -P workloads/workloada -P $CURRENT_PATH/large.dat -p postgrenosql.url=jdbc:postgresql://localhost:5432/ycsb -p postgrenosql.user=postgres -p postgrenosql.passwd="" -p postgrenosql.autocommit=true -s) > $RESULT_PATH/Load_$i.log

    for w in "${workloads[@]}"; do
        # Execute the actual benchmark operation
        (cd $PATH_YCSB && ./bin/ycsb run postgrenosql -P workloads/workload$w -P $CURRENT_PATH/large.dat -p postgrenosql.url=jdbc:postgresql://localhost:5432/ycsb -p postgrenosql.user=postgres -p postgrenosql.passwd=postgres -p postgrenosql.autocommit=true -s) > $RESULT_PATH/Workload${w}_$i.log
    done
    sleep 1
    /usr/local/pgsql/bin/psql -U postgres -c "DROP DATABASE ycsb WITH (FORCE);"
done

# Stop the database if it was running before
sudo -u postgres /usr/local/pgsql/bin/pg_ctl -D $MOUNT_PM/pgsql_data stop
sleep 1
sudo rm -rf $MOUNT_PM/pgsql_data
echo "##### YCSB postgres DONE #####"

echo  "##### Generating avg file for ${bench} #####"
declare -a files=( )
for i in $(seq 1 $REPEATS); do
    files+=( $RESULT_PATH/Load_$i.log )
done
python3 avg.py --files ${files[@]} -r $RESULT_PATH/Load.log

for w in "${workloads[@]}"; do
    declare -a files=( )
    for i in $(seq 1 $REPEATS); do
        files+=( $RESULT_PATH/Workload${w}_$i.log )
    done
    python3 avg.py --files ${files[@]} -r $RESULT_PATH/Workload${w}.log
done
