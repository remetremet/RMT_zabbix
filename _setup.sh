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
if [ ! -d "${ZBXDIR}/data" ]; then
 mkdir "${ZBXDIR}/data"
 chmod 777 "${ZBXDIR}/data"
fi
if [ ! -d "${ZBXDIR}/scripts" ]; then
 mkdir "${ZBXDIR}/scripts"
 chmod 777 "${ZBXDIR}/scripts"
fi

# Setup GITHUB / local repo
git config --global pull.rebase false
git config --global user.email "remet@remet.cz"
git config --global credential.helper store
git clone https://github.com/remetremet/RMT_zabbix.git ${ZBXDIR}/github

# Copy scripts to working directory
cp -R ${ZBXDIR}/github/_*.sh ${ZBXDIR}/
chmod 755 ${ZBXDIR}/_*.sh
cp -R ${ZBXDIR}/github/*.sh ${ZBXDIR}/scripts/
rm -f ${ZBXDIR}/scripts/_*.sh
chmod 755 ${ZBXDIR}/scripts/*.sh
