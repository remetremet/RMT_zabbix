#!/usr/local/bin/bash

# Define base directory
ZBXPATH="/var/zabbix"
SCRIPTSPATH="${ZBXPATH}/scripts"

# Software requirements
pkg install -y git fping curl smartmontools
pwd_mkdb /etc/master.passwd
pkg install -y git fping curl smartmontools

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
if [ ! -d "${SCRIPTSPATH}" ]; then
 mkdir "${SCRIPTSPATH}"
 chmod 777 "${SCRIPTSPATH}"
fi

# Setup GITHUB / local repo
git config --global pull.rebase false
git config --global user.email "remet@remet.cz"
git config --global credential.helper store
git clone https://github.com/remetremet/RMT_zabbix.git ${ZBXPATH}/github

# Copy scripts to working directory
cp -R ${ZBXPATH}/github/_*.sh ${ZBXPATH}/
chmod 755 ${ZBXPATH}/_*.sh
cp -R ${ZBXPATH}/github/scripts/*.sh ${SCRIPTSPATH}/
chmod 755 ${SCRIPTSPATH}/*.sh

# Modify Zabbix Agent configuration and restart Zabbix Agent
for ZV in "40 41 42 43 44 50 51 52 53 60"; do
 if [ -d "/usr/local/etc/zabbix${ZV}/zabbix_agentd.conf.d" ]; then
  ZBXCONFDIR="/usr/local/etc/zabbix${ZV}/zabbix_agentd.conf.d"
 fi
done
if [ -d "/usr/local/etc/zabbix/zabbix_agentd.conf.d" ]; then
 ZBXCONFDIR="/usr/local/etc/zabbix/zabbix_agentd.conf.d"
fi
cp -f ${ZBXPATH}/github/templates/userparameter_rmtzabbix.conf ${ZBXCONFDIR}/userparameter_rmtzabbix.conf
/usr/local/etc/rc.d/zabbix_agentd restart

