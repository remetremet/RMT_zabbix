#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
. "${ZBXPATH}/_database.sh"

# Synchronize scripts from github to local repo
cd ${ZBXPATH}/github
git pull origin master

# Copy scripts from local repo to working directory
cp -R ${ZBXPATH}/github/*.sh ${ZBXPATH}/
chmod 775 ${ZBXPATH}/*.sh
