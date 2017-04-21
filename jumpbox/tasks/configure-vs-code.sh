#!/bin/sh
set -e -x

#Script Formatting
RESET="\e[0m"
INPUT="\e[7m"
BOLD="\e[4m"

mkdir  ~/.ssh/

cp keys-folder/* ~/.ssh/
cp -f ansible-configs/hosts azure-oss-demos-ci/ansible/hosts

ansiblecommand=" -i hosts ../../ansible-configs/playbook-configure-vs-code.yml --private-key ~/.ssh/jumpbox_${jumpbox_prefix}_id_rsa"
#we need to run ansible-playbook in the same directory as the CFG file.  Go to that directory then back out...
cd azure-oss-demos-ci/ansible
    ansible-playbook ${ansiblecommand}
cd ..
