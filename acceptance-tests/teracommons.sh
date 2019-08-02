#!/usr/bin/env bash

downloadHadoopMapReduceExamples() {
    local hadoopVersion="$1"
    local libPath="$2"
    local jarName="hadoop-mapreduce-examples-$hadoopVersion.jar"
    local jarPath="$libPath/$jarName"
    local jarUrl="http://central.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-examples/$hadoopVersion/$jarName"

    if [[ ! -f "$jarPath" ]]; then
        if [[ ! -d "$libPath" ]]; then
            mkdir -p "$libPath"
        fi

        cd "$libPath"
        wget "$jarUrl"
        cd -
    else
        echo "$jarPath already downloaded"
    fi
}

assertHdfsUser() {
    if [[ "hdfs" != "$USER" ]]; then
        >&2 echo "You must be the hdfs user to run this script"
        exit 1
    fi
}