#!/usr/bin/env bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TEST_DIR="$(basename "$BASE_DIR")"
rsync -av "$BASE_DIR" /tmp
sudo chgrp hdfs -R "/tmp/$TEST_DIR"
sudo chmod g+w -R "/tmp/$TEST_DIR"

