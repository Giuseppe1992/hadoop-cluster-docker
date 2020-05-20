#!/bin/bash

# test the hadoop cluster by running wordcount

# create input directory on HDFS

# run wordcount 
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar pi  100 100
