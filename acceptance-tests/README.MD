# Acceptance Tests Cookbook

## Run teragen, terasort & teravalidate
Test steps:
* Adapt `teracfg.sh` according to your needs
* Ensure the HDFS dir ${TERADIR} (default: /data/sandbox/poc/teragen) exists 
  * ensure your user has write perms on it (unless you run as 'hdfs' user)
```
TERADIR=/data/sandbox/poc/teragen
hdfs dfs -mkdir -p ${TERADIR}
chown ${USER} ${TERADIR}
```
* Then change to the `hdfs` user, 
* Run the test scripts
```
./teragen.sh
./terasort.sh
./validate.sh
```

* Verify that there where no errors by inspecting the log files in `log/`.
* Verify that data has been written by executing
> `hdfs dfs -ls ${TERADIR}`
* Verify that *TeraGen*, *TeraSort*, *TeraValidate* are listed as applications in the YARN ResourceManger Web UI.


## Demonstrate that HDFS is working
Steps:
* Make sure that HDFS can be browsed with the NameNode Web UI.
* Check the various charts under HDFS->Charts Library. 
* Test that your user can read and write to HDFS:
 * Note: If the Cluster is kerberized you need to have a Kerberos ticket first (`kinit` etc).
```
cd -
hdfs dfs -ls /user/$(whoami)
echo test > test.txt
hdfs dfs -copyFromLocal test.txt /user/$(whoami)
hdfs dfs -cat /user/$(whoami)/test.txt
hdfs dfs -copyToLocal /user/$(whoami)/test.txt test2.txt
cat test2.txt
```
    
## Demonstrate that Spark is working
The classic Spark test is [SparkPi](https://github.com/apache/spark/blob/v2.4.0/examples/src/main/scala/org/apache/spark/examples/SparkPi.scala).
* Run following script:
> ./run-spark-pi.sh
* Verify that it worked: At the end of the output you should see something like
```
    Pi is roughly 3.1367556837784187
```
