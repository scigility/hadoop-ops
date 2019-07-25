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

RESULTSFILE="$LOGDIR/terasort_results_$DATE"

INPUT="$TERADIR/${SIZE}-terasort-input"
OUTPUT="$TERADIR/${SIZE}-terasort-output"

# terasort.sh
# Kill any running MapReduce jobs
mapred job -list | grep job_ | awk ' { system("mapred job -kill " $1) } '
# Delete the output directory
hadoop fs -rm -r -f -skipTrash ${OUTPUT}

# Run terasort
time hadoop jar $MR_EXAMPLES_JAR terasort \
-Dmapreduce.map.log.level=INFO \
-Dmapreduce.reduce.log.level=INFO \
-Dyarn.app.mapreduce.am.log.level=INFO \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.cpu.vcores=1 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.map.maxattempts=1 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.output.compress=true \
-Dmapreduce.map.output.compress.codec=org.apache.hadoop.io.compress.Lz4Codec \
-Dmapreduce.reduce.cpu.vcores=1 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dmapreduce.reduce.maxattempts=1 \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.task.io.sort.factor=300 \
-Dmapreduce.task.io.sort.mb=384 \
-Dyarn.app.mapreduce.am.command.opts=-Xmx768m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dmapred.reduce.tasks=92 \
-Dmapreduce.terasort.output.replication=1 \
${INPUT} ${OUTPUT} >> $RESULTSFILE 2>&1