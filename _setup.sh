#!/usr/local/bin/bash

# Define base directory
ZBXDIR="/var/zabbix"

# Software requirements
pkg -y install git fping curl smartmontools

# Setup directories
if [ ! -d "${ZBXDIR}" ]; then
 mkdir "${ZBXDIR}"
 chmod 777 "${ZBXDIR}"
fi
if [ ! -d "${ZBXDIR}/temp" ]; then
 mkdir "${ZBXDIR}/temp"
 chmod 777 "${ZBXDIR}/temp"
fi

# Setup GITHUB / local repo
git config --global pull.rebase false
git config --global user.email "remet@remet.cz"
git config --global credential.helper store
git clone https://github.com/remetremet/RMT_zabbix.git ${ZBXDIR}/github

# Copy scripts to working directory
cp -R ${ZBXDIR}/github/*.sh ${ZBXDIR}/
chmod 755 ${ZBXDIR}/*.sh
