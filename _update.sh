#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
. "${ZBXPATH}/_database.sh"

# Setup
#git config --global pull.rebase false
#git config --global user.email "remet@remet.cz"
#git config --global credential.helper store
#git clone https://github.com/remetremet/RMT_zabbix.git /var/zabbix/github

# Synchronize scripts from github to local repo
cd ${ZBXPATH}/github
git pull origin master

# Copy scripts from local repo to working directory
cp -R ${ZBXPATH}/github/*.sh ${ZBXPATH}/
chmod 775 ${ZBXPATH}/*.sh
