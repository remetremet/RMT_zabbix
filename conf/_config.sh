#!/usr/local/bin/bash

# Base directory of scripts and all the stuff
ZBXDIR="/var/zabbix"
TEMPDIR="${ZBXDIR}/temp"

# Optional modules (on/off)
MFI_ENABLE="no"
SPEEDTEST_ENABLE="yes"

# IPv4 addresses of default gateway and it's possible to add few next hops too
unset GW_ADDRS4; declare -A GW_ADDRS4;
GW_ADDRS4["0"]="0.0.0.0"

# IPv6 addresses of default gateway and it's possible to add few next hops too
unset GW_ADDRS6; declare -A GW_ADDRS6;
GW_ADDRS6["0"]="0:0:0:0:0:0:0:0"

# Multiple WANs supported in both stacks (IPv4/6)
FIBS4="0"
FIBS6="0"

# IP addresses to ping check (by default its public DNS and peering ports)
ADDRS4="8.8.8.8 1.1.1.1 9.9.9.9 185.43.135.1 91.210.16.190"
ADDRS6="2001:4860:4860::8844 2606:4700:4700::1111 2620:fe::fe 2001:148f:ffff::1 2001:7f8:14::1:1"

# Human readable name of network interfaces
unset IFNAMES; declare -A IFNAMES;
IFNAMES["lo0"]="Loopback"
IFNAMES["bce0"]="ISP"
IFNAMES["bce1"]="LAN"

# Human readable name of WANs
unset FIB_NAMES; declare -A FIB_NAMES;
FIB_NAMES["0"]="ISP"

### Ubiquiti mFI sockets
MFI_SESSIONID="1234567890ABCDEF1234567890ABCDEF"
MFI_USERNAME="ubnt"
MFI_PASSWORD="ubnt"
MFI_KEYS="output voltage power powerfactor current"
MFI_SOCKETS=3;
unset MFI_IP; declare -A MFI_IP;
unset MFI_ID; declare -A MFI_ID;
unset MFI_PORTS; declare -A MFI_PORTS;
MFI_IP["1"]="192.168.250.1"
MFI_ID["1"]="1"
MFI_PORTS["1"]="1 2 3"
MFI_IP["2"]="192.168.250.2"
MFI_ID["2"]="2"
MFI_PORTS["2"]="1 2 3 4 5 6"
MFI_IP["3"]="192.168.250.4"
MFI_ID["3"]="4"
MFI_PORTS["3"]="1 2 3"

### Ookla Speedtest.Net settings
# Selected servers (leave blank if you want autoselect)
SPEEDTEST_SERVERS="--server=21975 --server=21429 --server=16913 --server=4162 --server=4010 --server=30620 --server=18718 --server=5094"
# Proceed speedtest once a period (in seconds), 86400 (1 day) is default
unset SPEEDTEST_PERIOD; declare -A SPEEDTEST_PERIOD;
SPEEDTEST_PERIOD["0"]="86400"
SPEEDTEST_PERIOD["1"]="86400"
SPEEDTEST_PERIOD["2"]="86400"
