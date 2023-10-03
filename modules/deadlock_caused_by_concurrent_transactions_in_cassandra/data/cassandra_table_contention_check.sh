

#!/bin/bash



# Set the table name

table=${TABLE_NAME}



# Get the process IDs of all Cassandra instances

cassandra_pids=$(pgrep -f "cassandra")



# Loop through each process ID and check for contention on the specified table

for pid in $cassandra_pids; do

    # Use nodetool to get the thread dump for the process

    thread_dump=$(nodetool --pid $pid --threaddump)



    # Check if the table name appears in the thread dump

    if echo "$thread_dump" | grep -q "$table"; then

        # If it does, print a warning message

        echo "WARNING: Contention detected on table $table in process $pid"

    fi

done