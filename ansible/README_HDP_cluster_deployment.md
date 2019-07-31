HDP cluster deployment using the external ansible-hortonworks role
---

## Prerequisites

### Submodule: external ansible role
The Role (later referenced as 'HWX role'): https://github.com/scigility/ansible-hortonworks
* branch scigilty: contains any custom fixes, required from our side (goal: get these into upstream repo)
* branch: master: used to track the official/upstream repo (master branch)
The role is provisioned automatically as a git submodule.

### ansible
You need ansible (version >2.5.x) and some other python modules:
* boto, boto3 (for AWS deployments)
* jinja2 >=v2.10 (automatically installed as part of the ansible dependencies)

The deployment was tested with following ansible versions:
* v2.6.4
* v2.7.11
* v2.8.1


## Configuration
The complete config is best managed in (in ansible called) inventory group_vars.
Each deployed cluster will have it's own inventory (folder).
In the following example, we assume to have the inventory folder: inventory/hdp3demo  (for a cluster named 'hdp3demo')

Quick explanation why the cfg needs to be in group_vars/*all* (where 'all' is the special group, used for any host)
Indeed group_vars/*ec2* works 'almost' (ec2 being a group with all ec2 hosts created),
but the problem is the role (set_variables.yml playbook) runs task under 'host: localhost' (and usually 'localhost' will not be part of your cluster inventory, unless you explicitly add it,  OR you use the group 'all' which contains all hosts incl. localhost)

Following documents the ansible config files to be done, and the central parameters.
Note: The easiest is to start a new cluster config, copy&pasting the cfg from an existing inventory.

If no existing inventory, you have to base your configs from the original HWX repo:
* hdp-aws.yml: containing all configs *only* required during build_cloud (creating the AWS/cloud cluster). 
  * Template: https://github.com/scigility/ansible-hortonworks/blob/master/inventory/aws/group_vars/all#L26 
* hdp.yml:  containing all other configs req. by the HWX HDP/HDF deployment
  * Template: https://github.com/scigility/ansible-hortonworks/blob/master/playbooks/group_vars/all  

### inventory/xxx/group_vars/hdp-aws.yml
Main configs to check:
```
region: 'eu-west-1'
zone: 'eu-west-1a'
(...)
# Configure the ssh key-pair to use during the deployment.
publickey: '~/.ssh/id_rsa.pub'
privatekey: '~/.ssh/id_rsa'
(...)
image: ami-2a7d75c0     # AMI id varies between regions.
```

### inventory/xxx/group_vars/hdp.yml
Main configs to check:
```
cluster_name: '......'
ambari_admin_password: 'xyz...'         # the password for the Ambari admin user
```

## Deployment

### Deployment to AWS

Following shows the commands used for the deployment of cluster named  `hdp3demo` (that has its config in the equally named inventory folder).

```
# ENV required for a deployment to the cloud:
export CLOUD_TO_USE=aws
# Example ENVs required for an AWS deployment:
export AWS_ACCESS_KEY_ID='.....'
export AWS_SECRET_ACCESS_KEY='...'

# script to deploy the cloud (VPC etc and the nodes)
./build_cloud.sh -i inventory/hdp3demo -vv

# deploy Ambari incl. (first) pre-requisites, the ambari server, finally apply the blueprint
./install_cluster.sh -vv -i inventory/hdp3demo

```
### Deployment to other clouds
Check the documentation in the original HWX role.
Disclaimer: As we haven't yet tested on other cloud providers (from this repo), it's probable that fixes are required in HWX role.

### Deployment using a static inventory
First check the original Doc: https://github.com/hortonworks/ansible-hortonworks/blob/master/INSTALL_static.md
In this case the inventory hosts must be defined manually in a file (see p.eg the config in `hdp3demo`).
Notes:
* The 'static' method can also be used for a cluster in the cloud (`build_cloud.sh` also useful!), which can be useful to test a config before doing the 'real' deployment on bare-metal nodes.
* The `hdp-aws.yml` config is not required by the installation (it was only used by `build_cloud.sh`), but is still useful to keep to allow for changes in the AWS configs like to update the security-groups (using the same playbook behind `build_cloud.sh`)

Commands used:
```
# need to override the cloud_name param (to aws), because in our config it's set to `static` ()
./build_cloud.sh -v -i inventory/hdp3demo -e cloud_name=aws

# Note: The install cmd looks exactly the same (as for AWS) .. the
 cluster is deployed using the static inventory strategy:
./install_cluster.sh -v -i inventory/hdp3demo
```

### Offline deployment
The playbooks can also be used when deploying a cluster without internet access.
But some things need to be considered.

#### external yum repositories
In the role in some places additional/external yum repositories are added (p.eg. to get postgres >v9.6) automatically
But for an offline install this can be disabled (setting add_repo=no), and instead the required postgres rpms can be provided p.eg. in a local repository or spacewalk.

#### Ambari mpacks
Without internet, nor local repository, the mpacks can also be provided on the Ambari node's local fs, by setting following vars:
* hdf_mpack_base_url: "file:///root"
* solr_mpack_base_url: "file:///root"
Feature added in PR: https://github.com/hortonworks/ansible-hortonworks/pull/133: configurable mpack base urls ...

#### Offline deployment with Spacewalk
For an 'offline installation' with spacewalk/satellite following 2 vars must be set 'False':
* ambari_repo_enabled: False
* ambari_managed_repositories: False
Feature added in PR: https://github.com/hortonworks/ansible-hortonworks/pull/135: Support Satellite/Spacewalk repositories ...


### Deployment using a special DB/postgres
At one of our customers we could not use the HWX-role supported pgsql repo, but had to use a redhat postgres repo, which requires config changes in the postgres dirs and service name.
To avoid patching the vars in the HWX role file ($HWX_role/playbooks/roles/database/vars/redhat-7.yml), it's cleaner to override using extra-vars, eg:
./install_cluster.sh  -t database -e  "@inventory/*/group_vars/$groupname/postgres.yml" -v


### Deploy Notes:
* The `-vv` params above are optional, but recommended for more informative ansible (debug) output
* For an AWS deployment, you need to set 2 working AWS access+secret ENV vars (see above)
* Note that the ssh-keys (incl. priv. key) configured above, will be automatically pushed to the AWS console (in the  build-could.sh script..). On the EC2 nodes, *only* the pub key will be uploaded (to the authorized_keys file of course)


## Learnings
* For Ranger, need to use a proper DB like postgres (not 'embedded')
* For Atlas, you need also to select the HBASE component
* When you just want to rerun the blueprint deployment/playbook ("apply_blueprint.yml"), you can skip the first 2 playbooks, but not skip "configure_ambari.yml"
* The default 15GB volume size is not enough (better >50GB) neither for a master node with many services, nor for slave nodes with hdfs, kafka etc.
* Deploy java using option `openjdk`, then no extra JCE crypto extensions required
* offline installation: In case ansible and dependent modules are installed using rpms (and not python pip), ensure the required modules are not outdated (esp. jinja2 >2.10)
* offline installation with spacewalk repositories: See section `Offline deployment`
* The admin password used for RANGER_USERSYNC (default_password by default) must follow rule:
> Password should be minimum 8 characters with minimum one alphabet and one numeric.

## TODOs
* Test deployments to other clouds (like Azure, GCP)
* In group_vars/hdp-aws.yml: Prepare a reusable `security_groups` dict (containing a good std-set of rules) that can be referenced from other inventories
* Add more features in the deployment, see also what's missing in the HWX role doc (bottom of main README), like
  * NiFi SSL
