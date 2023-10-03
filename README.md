
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Deadlock caused by concurrent transactions in Cassandra.
---

Deadlock is a type of incident that can occur when multiple transactions are executed concurrently in a distributed database management system such as Cassandra. In this scenario, two or more transactions might try to acquire the same exclusive lock on a resource, and neither transaction can proceed until the other releases its lock. This can result in a situation where all the transactions are blocked, and no progress can be made. In the context of Cassandra, this can lead to blocked queries and overall decreased performance of the system.

### Parameters
```shell
export CASSANDRA_JMX_PASSWORD="PLACEHOLDER"

export CASSANDRA_NODE_IP="PLACEHOLDER"

export CASSANDRA_JMX_USERNAME="PLACEHOLDER"

export CASSANDRA_JMX_PORT="PLACEHOLDER"

```

## Debug

### Check the load on the system
```shell
top
```

### Check the load on the CPU
```shell
mpstat
```

### Check the CPU usage per process
```shell
ps -eo %cpu,pid,cmd | sort -k 1 -r | head -10
```

### Check the memory usage per process
```shell
ps -eo %mem,pid,cmd | sort -k 1 -r | head -10
```

### Check the number of connections to Cassandra
```shell
nodetool tpstats
```

### Check the number of running threads in Cassandra
```shell
nodetool -h ${CASSANDRA_NODE_IP} -p ${CASSANDRA_JMX_PORT} -u ${CASSANDRA_JMX_USERNAME} -pw ${CASSANDRA_JMX_PASSWORD} -ssl enable get /metrics/thread-pool/RequestResponseStage/ActiveTasks
```

### Check the Cassandra system log for errors
```shell
tail -f /var/log/cassandra/system.log
```

### Check the Cassandra slow query log for queries taking too long
```shell
tail -f /var/log/cassandra/slowquery.log
```

### Multiple queries trying to access the same Cassandra table simultaneously, leading to contention and deadlock.
```shell


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


```

## Repair

### Tune the Cassandra cluster settings to optimize performance and minimize the risk of deadlocks.
```shell

#!/bin/bash

CLUSTER_NAME=${CLUSTER_NAME}

SEED_NODE_IP=${SEED_NODE_IP}

NUM_TOKENS=${NUM_TOKENS}

CONCURRENT_READS=${CONCURRENT_READS}

CONCURRENT_WRITES=${CONCURRENT_WRITES}

COMMITLOG_SYNC=${COMMITLOG_SYNC}

sed -i "s/cluster_name: .*/cluster_name: $CLUSTER_NAME/g" /etc/cassandra/cassandra.yaml

sed -i "s/seeds: .*/seeds: \"$SEED_NODE_IP\"/g" /etc/cassandra/cassandra.yaml

sed -i "s/num_tokens: .*/num_tokens: $NUM_TOKENS/g" /etc/cassandra/cassandra.yaml

sed -i "s/concurrent_reads: .*/concurrent_reads: $CONCURRENT_READS/g" /etc/cassandra/cassandra.yaml

sed -i "s/concurrent_writes: .*/concurrent_writes: $CONCURRENT_WRITES/g" /etc/cassandra/cassandra.yaml

sed -i "s/commitlog_sync: .*/commitlog_sync: $COMMITLOG_SYNC/g" /etc/cassandra/cassandra.yaml


```