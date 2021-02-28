#!/usr/local/bin/bash

# Define base directory
ZBXPATH="/var/zabbix"

# Software requirements
pkg -y install git fping curl smartmontools

# Setup directories
if [ ! -d "${ZBXPATH}" ]; then
 mkdir "${ZBXPATH}"
 chmod 777 "${ZBXPATH}"
fi
if [ ! -d "${ZBXPATH}/temp" ]; then
 mkdir "${ZBXPATH}/temp"
 chmod 777 "${ZBXPATH}/temp"
fi
if [ ! -d "${ZBXPATH}/data" ]; then
 mkdir "${ZBXPATH}/data"
 chmod 777 "${ZBXPATH}/data"
fi
if [ ! -d "${ZBXPATH}/scripts" ]; then
 mkdir "${ZBXPATH}/scripts"
 chmod 777 "${ZBXPATH}/scripts"
fi

# Setup GITHUB / local repo
git config --global pull.rebase false
git config --global user.email "remet@remet.cz"
git config --global credential.helper store
git clone https://github.com/remetremet/RMT_zabbix.git ${ZBXPATH}/github

# Copy scripts to working directory
cp -R ${ZBXPATH}/github/_*.sh ${ZBXPATH}/
chmod 755 ${ZBXPATH}/_*.sh
cp -R ${ZBXPATH}/github/*.sh ${ZBXPATH}/scripts/
rm -f ${ZBXPATH}/scripts/_*.sh
chmod 755 ${ZBXPATH}/scripts/*.sh
