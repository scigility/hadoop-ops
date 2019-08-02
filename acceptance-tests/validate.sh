#!/usr/bin/env bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$BASE_DIR/teracfg.sh"
source "$BASE_DIR/teracommons.sh"
assertHdfsUser

LOGDIR=$BASE_DIR/logs

if [ ! -d "$LOGDIR" ]
then
    mkdir "$LOGDIR"
fi

DATE=`date +%Y-%m-%d:%H:%M:%S`

RESULTSFILE="$LOGDIR/validate_results_$DATE"

OUTPUT="$TERADIR/${SIZE}-terasort-output"
REPORT="$TERADIR/${SIZE}-terasort-report"

# teravalidate.sh
# Kill any running MapReduce jobs
mapred job -list | grep job_ | awk ' { system("mapred job -kill " $1) } '
# Delete the output directory
hadoop fs -rm -r -f -skipTrash ${REPORT}
# Run teravalidate
time hadoop jar $MR_EXAMPLES_JAR teravalidate \
-Ddfs.blocksize=256M \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dyarn.app.mapreduce.am.command-opts=-Xmx768m \
-Dmapreduce.task.io.sort.mb=1 \
-Dmapred.map.tasks=185 \
-Dmapred.reduce.tasks=185 \
${OUTPUT} ${REPORT} >> $RESULTSFILE 2>&1
[cloudera@quickstart acceptance-tests]$ cat validate.sh
#!/bin/bash

trap "" HUP

#if [ $EUID -eq 0 ]; then
#   echo "this script must not be run as root. su to hdfs user to run"
#   exit 1
#fi
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MR_EXAMPLES_JAR="$BASE_DIR/lib/hadoop-mapreduce-examples-2.6.0.jar"

#SIZE=500G
#SIZE=100G
SIZE=50M
#SIZE=1G
#SIZE=10G

LOGDIR=$BASE_DIR/logs

if [ ! -d "$LOGDIR" ]
then
    mkdir "$LOGDIR"
fi

DATE=`date +%Y-%m-%d:%H:%M:%S`

RESULTSFILE="$LOGDIR/validate_results_$DATE"

OUTPUT=/data/sandbox/poc/teragen/${SIZE}-terasort-output
REPORT=/data/sandbox/poc/teragen/${SIZE}-terasort-report

# teravalidate.sh
# Kill any running MapReduce jobs
mapred job -list | grep job_ | awk ' { system("mapred job -kill " $1) } '
# Delete the output directory
hadoop fs -rm -r -f -skipTrash ${REPORT}
# Run teravalidate
time hadoop jar $MR_EXAMPLES_JAR teravalidate \
-Ddfs.blocksize=256M \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dyarn.app.mapreduce.am.command-opts=-Xmx768m \
-Dmapreduce.task.io.sort.mb=1 \
-Dmapred.map.tasks=185 \
-Dmapred.reduce.tasks=185 \
${OUTPUT} ${REPORT} >> $RESULTSFILE 2>&1
