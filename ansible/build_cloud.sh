#!/usr/bin/env bash
# This script originates from the  ansible-hortonworks repo, and was adapted to run the playbooks in an external repo
export cloud_to_use=$CLOUD_TO_USE

# HWX_ROLE_DIR is set to the 'ansible-hortonworks' repository included as a 'git submodule' by default
export HWX_ROLE_DIR=${HWX_ROLE_DIR:-../ansible-hortonworks}
echo using HWX_ROLE_DIR="$HWX_ROLE_DIR"

case $cloud_to_use in
aws|azure|gce|openstack)
  ;;
*)
  message="CLOUD_TO_USE environment variable was set to \"$CLOUD_TO_USE\" but must be set to one of the following: aws, azure, gce, openstack"
  echo -e $message
  exit 1
  ;;
esac

ansible-playbook --connection=local "${HWX_ROLE_DIR}/playbooks/clouds/build_${cloud_to_use}.yml" "$@"
