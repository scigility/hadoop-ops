#!/usr/bin/env bash

# HWX_ROLE_DIR is set to the 'ansible-hortonworks' repository included as a 'git submodule' by default
export HWX_ROLE_DIR=${HWX_ROLE_DIR:-../ansible-hortonworks}
echo using HWX_ROLE_DIR="$HWX_ROLE_DIR"

## Following ENV var we set manually outside the script
#export CLOUD_TO_USE=aws

## Note: "set_cloud.sh" (from HWX repo) not moved into this repo (not needed)
#cloud_to_use=$(echo "$CLOUD_TO_USE" | tr '[:upper:]' '[:lower:]')
#source ${HWX_ROLE_DIR}/set_cloud.sh

# Ensure no hortonworks repos 'group_vars/all' file (overriding our inventory/xxx/groups_vars)
if [ -f "${HWX_ROLE_DIR}/playbooks/group_vars/all" ]; then
  rm -f "${HWX_ROLE_DIR}/playbooks/group_vars/all"
  echo "!!! Removing original config: ${HWX_ROLE_DIR}/playbooks/group_vars/all"
fi

#Note: we could also just set the 'cloud_name' var. in the inventory !
#ansible-playbook -e "cloud_name=${cloud_to_use}" "${HWX_ROLE_DIR}/playbooks/install_cluster.yml"  "$@"
ansible-playbook  "${HWX_ROLE_DIR}/playbooks/install_cluster.yml"  "$@"
