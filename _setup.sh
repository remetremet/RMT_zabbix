#!/usr/local/bin/bash

# Setup directories
if [ ! -d /var/zabbix ]; then
 mkdir /var/zabbix
 chmod 777 /var/zabbix
fi
if [ ! -d /var/zabbix/temp ]; then
 mkdir /var/zabbix/temp
 chmod 777 /var/zabbix/temp
fi

# Setup GITHUB / local repo
git config --global pull.rebase false
git config --global user.email "remet@remet.cz"
git config --global credential.helper store
git clone https://github.com/remetremet/RMT_zabbix.git /var/zabbix/github
