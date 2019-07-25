#!/usr/bin/env bash

findSparkBinPath() {
    if [[ -d "/usr/lib/spark/bin" ]]; then
        echo "/usr/lib/spark/bin"
    elif [[ -L "/usr/bin/spark-shell" ]]; then
        echo "$(dirname "$(readlink -f /usr/bin/spark-shell)")/../lib/spark/bin"
    else
        echo "/please/set/spark/bin/path/manually"
    fi
}

: ${SPARK_BIN_PATH:="$(findSparkBinPath)"}

"$SPARK_BIN_PATH/run-example" SparkPi | grep '^Pi is roughly .*' --color
