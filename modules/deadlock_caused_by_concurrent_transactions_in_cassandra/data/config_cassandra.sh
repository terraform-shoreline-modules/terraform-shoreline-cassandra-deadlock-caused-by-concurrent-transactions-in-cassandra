
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