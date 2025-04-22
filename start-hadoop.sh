#!/bin/bash

# Set environment variables
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root

# Format HDFS only if not already formatted
if [ ! -d "/tmp/hadoop-root/dfs/name/current" ]; then
  #echo "Formatting HDFS NameNode..."
  $HADOOP_HOME/bin/hdfs namenode -format
fi

# Start HDFS daemons
echo "Starting NameNode and DataNode..."
$HADOOP_HOME/bin/hdfs --daemon start namenode
$HADOOP_HOME/bin/hdfs --daemon start datanode

# Start YARN daemons
echo "Starting ResourceManager and NodeManager..."
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
$HADOOP_HOME/bin/yarn --daemon start nodemanager

# Show running daemons
echo "Running Hadoop processes:"
jps
