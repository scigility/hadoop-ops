hdfs-encryption role
====================

This role, provides automated deployment  of  hdfs crypto zones.
Required steps for this, and current status:

What the role does
* deployment of the underlying hdfs folder (done using external/existing role)
  * -> done in playbook, or already by deploy-hdfs-folders
* DONE: deployment of the crypto zone

What the role does *not*:
* The deployment of the Hdfs Encryption Keys, which are required before deploying a hdfs crypto zone.
  * The tool to manage/create the keys depends on the Hadoop distribution. p.eg
    * On Cloudera HDP: Ranger KMS is the tool 
    * On Cloudera CDP: Hadoop KMS (Java KeyStore KMS or Key Trustee KMS backed by a Cloudera KTS)


Requirements
------------

This role does not depend on any extra modules or other roles.


Role Variables
--------------

All the role vars explained in short, including their defaults. (However the code is the best doc!):

* `hdfs_encryption_user` (default: `hdfs`): the hdfs root user upon which hdfs/crypto tasks are run.
* `hdfs_encryption_zones` (default: `[]`): a list of hdfs zones, with 1 dict per dir to deploy.


Examples
----------------

Example config of a crypto zone containing the underlying hdfs folder in the `name` field.
```
hdfs_encryption_zones:
  - name: /data/raw
    keyname: raw-data-key
```
