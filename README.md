# hadoop-ops
Ansible based IaC deployment of (mostly) Cloudera (CDH,HDP,HDF) big data clusters including pre-requisites and utility playbooks

## Folder Structure
* ansible: Contains the ansible playbooks (and is the main folder to run from)
* ansible/roles: internal roles (that could be moved to their own repo later)
* ansible/roles_ext_pub: ansible roles included via git submodules
* ansible/group_vars/all: Folder to put global default variables (that may be re-used over multiple playbooks / roles)
* ansible-hortonworks: submodule reference of https://github.com/scigility/ansible-hortonworks
* cloudera-playbook: submodule reference of https://github.com/scigility/cloudera-playbook
* prereq-checks: submodule reference of https://github.com/scigility/prereq-checks
* acceptance-tests: Acceptance Tests Cookbook for a Hadoop cluster

## Features
* Deployment of both Cloudera distributions on a bare-metal cluster
* Deployment of a (linux based) cluster (of linux machines) on various clouds (provided by the HWX role)
  * Entry script: `build_cloud.sh`
* Deployment of a Cloudera/Hortonworks(HWX) HDP/HDF 3.x cluster (on RHEL/centos, Ubuntu and Suse)
  * based mainly on the "ansible-hortonworks" repo
  * Specific Doc in: `ansible/README_HDP_cluster_deployment.md`
* Deployment of a Cloudera/Hortonworks CDH 6.x cluster (on RHEL/centos 7.x)
  * based mainly on the "cloudera-playbook" repo
* Deployment of Pre-requisites before a Hadoop deployment (provided by the HWX 'common' role)
* Deployment of external services required by a Hadoop Cluster (on RHEL/centos 7.x)
  * Deployment of a MIT kerberos server & kdc (by role kerberos_server)
  * Deployment of a Postgres 9.6.x server (by role ansible-role-postgresql)
* Acceptance Tests Cookbook: Scripts to run various Hdfs and Spark tests on a (newly installed) Hadoop cluster
* Post-Install Deployment Features
  * Deployment of OS Users & Groups (p.eg useful on test clusters without Active Directory)
  * Deployment of Kerberos Principals
  * Deployment of HDFS Folders (incl. Kerberos kinit support for the 'hdfs' superuser)
  * Deployment of HDFS Folders with extended ACLs
  * Deployment of HDFS encryption zones (depending on pre-created KMS Keys) 
  * Deployment of Ranger policies (for Yarn, Hdfs, Hive, HBase, Kafka and Storm) 

TODO include infos about the playbooks, from our Wiki

## Requirements

### Ansible
You need ansible (version >2.5.x) and some other python modules:
* jinja2 >=v2.10 (automatically installed as part of the ansible dependencies)
* boto, boto3 (for AWS deployments)

The deployment was tested with following ansible versions:
* v2.7.11
* v2.8.1
* v2.6.4 (upto 2019/04)

### Infrastructure
Of course you need some infrastructure/servers:
* For a single node cluster following are the minimum resources:
 * 32G memory (enough to get a running cluster. 16G might be only if you install a subset of Hadoop)
 * 4 (better 8) CPUs
