#!/usr/bin/env bash

: ${HADOOP_VERSION:="$(hdfs version | egrep '^Hadoop\>' | egrep '\<[0-9]+\.[0-9]+\.[0-9]+' -o)"}
: ${TERADIR:=/data/sandbox/poc/teragen}
: ${LIB_PATH:="$BASE_DIR/lib"}
: ${MR_EXAMPLES_JAR:="$LIB_PATH/hadoop-mapreduce-examples-${HADOOP_VERSION}.jar"}
: ${SIZE:=50M}
: ${ROWS:=5000}
