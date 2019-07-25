deploy-hdp-app
==============

This role, in short, provides the generic deployment of files (from jars to templated configs) to hdfs.

It provides quite some flexibility on following levels:

* Configurable (list)vars (of dictionaries) to define what files to deploy
 * See role variables: `deploy_app_config_files`,`deploy_app_jars`
 * For each file, one can specify if the config is templated (by default 'no'), the destination (hdfs)dir, etc
* Each deployed file, runs through upto 3 deployment stages, each of which can be selectively disabled.
 * See role variables: `deploy_old_to_stage`,`deploy_new_to_stage`,`deploy_to_hdfs`.
 * Note by default only stages 2+3 are enabled, because stage°1 is usually not required.
 * However during the adoption-phase of this (ansible based) deployments, enabling stage°1 (`deploy_old_to_stage: yes`)
   is useful to show the diffs getting deployed between the original file/config in hdfs and the newly deployed one.


Requirements
------------

This role does not depend on any extra modules or other roles.


Role Variables
--------------

All the role vars explained in short, including their defaults. (However the code is the best doc!):

* `deploy_stage_dir` (default: `/tmp/deploy_staging_dir`): the remote directory used as a staging directory,
  required because we have to first deploy files to a local dir before running 'hdfs dfs -put' cmds, because
  there's no (complete) hdfs module (yet) to directly deploy a file/template to a (remote) hdfs.
* `deploy_old_to_stage` (default: `no`): If yes, first deploy existing files from hdfs to the staging dir.
* `deploy_new_to_stage` (default: `yes`): If yes, deploy files (from local) to the staging dir.
* `deploy_to_hdfs` (default: `yes`): If yes, deploy files from the staging dir to hdfs.
* `deploy_to_hdfs_force` (default: `yes`): If yes, `hdfs dfs -put -f` is used to overwrite any existing file.
* `hdfs_root_user` (default: `hdfs`): the hdfs root user used as the `become_user` for the hdfs dir deploy tasks.
* `deploy_app` (default: `{}`): this optional dictionary is forwarded as variable `app` (usable in templated configs).
* `deploy_app_config_files` (default: `[]`): a list of dicts, with 1 dict per file to deploy. Example in the role defaults.
* `deploy_app_jars` (default: `[]`): a list of dicts, with 1 dict per file to deploy.
* `deploy_hdfs_dirs` (default: `[]`): a list of hdfs dirs, with 1 dict per dir to deploy.


Examples
----------------
