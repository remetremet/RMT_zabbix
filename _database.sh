#!/usr/local/bin/bash

### DEFAULT SETTINGS
# IPv4 addresses of default gateway or a few next hops (default settings can be override in _config.sh)
TEST=${GW_ADDRS4["0"]}
if [ x"${TEST}" == x"" ]; then
 GW_ADDRS4["0"]=$( /usr/bin/netstat -nr4 | /usr/bin/grep "default" | /usr/bin/awk ' { print $2; } ' )
fi

# IPv6 addresses of default gateway or a few next hops (default settings can be override in _config.sh)
TEST=${GW_ADDRS6["0"]}
if [ x"${TEST}" == x"" ]; then
 GW_ADDRS6["0"]=$( /usr/bin/netstat -nr6 | /usr/bin/grep "default" | /usr/bin/awk ' { print $2; } ' )
fi

# Multiple WANs supported in both stacks (IPv4/6) (default settings can be override in _config.sh)
if [ x"${FIBS4}" == x"" ]; then
 maxfibs=$(( $( sysctl -n net.fibs ) - 1 ))
 FIBS4="0"
 if [[ ! x"${maxfibs}" == x"0" ]]; then
  for FI in $( seq 1 ${maxfivs} ); do
   FIBS4="${FIBS4} ${FI}"
  done
 fi
fi
if [ x"${FIBS6}" == x"" ]; then
 maxfibs=$(( $( sysctl -n net.fibs ) - 1 ))
 FIBS6="0"
 if [[ ! x"${maxfibs}" == x"0" ]]; then
  for FI in $( seq 1 ${maxfivs} ); do
   FIBS6="${FIBS6} ${FI}"
  done
 fi
fi

# IP addresses to ping check (default settings can be override in _config.sh)
if [ x"${ADDRS4}" == x"" ]; then
 ADDRS4="8.8.8.8 1.1.1.1 9.9.9.9 185.43.135.1 91.210.16.190"
fi
if [ x"${ADDRS6}" == x"" ]; then
 ADDRS6="2001:4860:4860::8844 2606:4700:4700::1111 2620:fe::fe 2001:148f:ffff::1 2001:7f8:14::1:1"
fi

# Human readable name of network interfaces (default settings can be override in _config.sh)
TEST=${IFNAMES["lo0"]}
if [ x"${TEST}" == x"" ]; then
 IFNAMES["lo0"]="Loopback"
fi
IFNAMES_NAME="lagg wlan igb em bce bge bnxt bxe cxgb cxgbe fxp gem ixgbe ixl mlx4en mlx5en ue re ice"
IFNAMES_CNT="0 1 2 3 4 5 6 7"
for IN in ${IFNAMES_NAME}; do
 for IC in ${IFNAMES_CNT}; do
  IFN="${IN}${IC}"
  TEST=${IFNAMES["${IFN}"]}
  if [ x"${TEST}" == x"" ]; then
   IFNAMES[${IFN}]="${IFN}"
  fi
 done
done

# Human readable name of WANs (default settings can be override in _config.sh)
TEST=${FIB_NAMES["0"]}
if [ x"${TEST}" == x"" ]; then
 FIB_NAMES["0"]="ISP 1"
fi
TEST=${FIB_NAMES["1"]}
if [ x"${TEST}" == x"" ]; then
 FIB_NAMES["1"]="ISP 2"
fi
TEST=${FIB_NAMES["2"]}
if [ x"${TEST}" == x"" ]; then
 FIB_NAMES["2"]="ISP 3"
fi
TEST=${FIB_NAMES["3"]}
if [ x"${TEST}" == x"" ]; then
 FIB_NAMES["3"]="ISP 4"
fi

### FreeBSD OS updates check period in seconds (default settings can be override in _config.sh)
if [ x"${FREEBSD_UPDATE_PERIOD}" == x"" ]; then
 FREEBSD_UPDATE_PERIOD=86400
fi
if [ x"${FREEBSD_UPDATE_CONF}" == x"" ]; then
 FREEBSD_UPDATE_CONF="/etc/freebsd-update.conf"
fi

### FreeBSD packages check period in seconds (default settings can be override in _config.sh)
if [ x"${PKG_PERIOD}" == x"" ]; then
 PKG_PERIOD=86400
fi

### Ubiquiti mFI sockets (default settings can be override in _config.sh)
if [ x"${MFI_SESSIONID}" == x"" ]; then
 MFI_SESSIONID="00000000000000000000000000000000"
fi
if [ x"${MFI_USERNAME}" == x"" ]; then
 MFI_USERNAME="username"
fi
if [ x"${MFI_PASSWORD}" == x"" ]; then
 MFI_PASSWORD="password"
fi
if [ x"${MFI_KEYS}" == x"" ]; then
 MFI_KEYS="output voltage power powerfactor current"
fi
if [ x"${MFI_IDS}" == x"" ]; then
 MFI_IDS=""
fi
TEST=${MFI_IP["1"]}
if [ x"${TEST}" == x"" ]; then
 MFI_IP["1"]="0.0.0.0"
fi
TEST=${MFI_PORT["1"]}
if [ x"${TEST}" == x"" ]; then
 MFI_PORT["1"]="1 2 3 4 5 6"
fi

### SMART monitoring of HDD/SSD
# SMART check period in seconds
if [ x"${SMART_PERIOD}" == x"" ]; then
 SMART_PERIOD="3600"
fi
# Timeout to wake up sleeing disk to get SMART data
if [ x"${SMART_FORCE_PERIOD}" == x"" ]; then
 SMART_FORCE_PERIOD="86400"
fi

# Proceed speedtest once a period (in seconds) (default settings can be override in _config.sh)
TEST=${SPEEDTEST_PERIOD["0"]}
if [ x"${TEST}" == x"" ]; then
 SPEEDTEST_PERIOD["0"]="86400"
fi
TEST=${SPEEDTEST_PERIOD["1"]}
if [ x"${TEST}" == x"" ]; then
 SPEEDTEST_PERIOD["1"]="86400"
fi
TEST=${SPEEDTEST_PERIOD["2"]}
if [ x"${TEST}" == x"" ]; then
 SPEEDTEST_PERIOD["2"]="86400"
fi
TEST=${SPEEDTEST_PERIOD["3"]}
if [ x"${TEST}" == x"" ]; then
 SPEEDTEST_PERIOD["3"]="86400"
fi



### LOOKUP ARRAYS
# Human readable names for IP addresses
unset ADDR_NAMES; declare -A ADDR_NAMES;
ADDR_NAMES["127.0.0.1"]="Localhost"
ADDR_NAMES["::1"]="Localhost (IPv6)"
ADDR_NAMES["91.210.16.190"]="NIX.CZ"
ADDR_NAMES["2001:7f8:14::1:1"]="NIX.CZ (IPv6)"
ADDR_NAMES["8.8.8.8"]="Google DNS"
ADDR_NAMES["8.8.4.4"]="Google DNS"
ADDR_NAMES["2001:4860:4860::8844"]="Google DNS (IPv6)"
ADDR_NAMES["2001:4860:4860::8888"]="Google DNS (IPv6)"
ADDR_NAMES["9.9.9.9"]="Quad9 DNS"
ADDR_NAMES["2620:fe::fe"]="Quad9 DNS (IPv6)"
ADDR_NAMES["1.1.1.1"]="Cloudflare DNS"
ADDR_NAMES["2606:4700:4700::1111"]="Cloudflare DNS (IPv6)"
ADDR_NAMES["217.31.204.130"]="CZNIC"
ADDR_NAMES["2001:678:1::206"]="CZNIC (IPv6)"
ADDR_NAMES["193.17.47.1"]="CZNIC"
ADDR_NAMES["185.43.135.1"]="CZNIC"
ADDR_NAMES["2001:148f:fffe::1"]="CZNIC (IPv6)"
ADDR_NAMES["2001:148f:ffff::1"]="CZNIC (IPv6)"
ADDR_NAMES["81.90.244.209"]="Abak GW"
ADDR_NAMES["10.11.227.1"]="Abak GW"
ADDR_NAMES["10.62.14.1"]="Abak GW"
ADDR_NAMES["10.17.161.1"]="Abak GW"
ADDR_NAMES["10.96.1.1"]="Abak GW"
ADDR_NAMES["2a00:1268:10:18f0::1"]="Abak GW (IPv6)"
ADDR_NAMES["2a00:1268:15:13f0::1"]="Abak GW (IPv6)"
ADDR_NAMES["2a00:1268:16:13f0::1"]="Abak GW (IPv6)"
ADDR_NAMES["80.250.15.1"]="WIA Strahov GW"
ADDR_NAMES["80.250.15.126"]="WIA Nagano GW"
ADDR_NAMES["80.250.24.254"]="WIA Nagano GW"
ADDR_NAMES["2a01:6400:0109::1"]="WIA Strahov GW (IPv6)"
ADDR_NAMES["2a01:6400:1091::1"]="WIA Nagano GW (IPv6)"
ADDR_NAMES["109.107.223.3"]="Vodafone GW"
ADDR_NAMES["91.210.16.96"]="Tmobile GW"
ADDR_NAMES["194.228.190.157"]="O2 GW"
ADDR_NAMES["192.168.255.254"]="Remet GW"
ADDR_NAMES["2a00:1268:10:1800::254"]="Remet GW (IPv6)"
ADDR_NAMES["192.168.11.254"]="Radiomed GW"
ADDR_NAMES["2a00:1268:15:1300::1"]="Radiomed GW (IPv6)"
ADDR_NAMES["192.168.123.254"]="Garaz GW"
ADDR_NAMES["2a00:1268:16:1300:ffff:ffff:ffff:fffe"]="Garaz GW (IPv6)"
ADDR_NAMES["10.10.10.254"]="MGMT GW"
ADDR_NAMES["10.11.12.254"]="VPN GW"
ADDR_NAMES["10.21.22.254"]="VPS GW"

# Directory for "size of" checks definitions
unset DIRS; declare -A DIRS;
DIRS["varlog"]="/var/log"
DIRS["varmail"]="/var/mail"
DIRS["md"]="/md"
DIRS["dataSQL"]="/data/SQL"
DIRS["dataSQL2"]="/data/SQL2"
DIRS["data"]="/data"
DIRS["vardbmysql"]="/var/db/mysql"
DIRS["vardbmysql2"]="/var/db/mysql2"
unset DIRnames; declare -A DIRnames;
DIRnames["varlog"]="Logs"
DIRnames["varmail"]="Mails"
DIRnames["md"]="Memory disk"
DIRnames["dataSQL"]="SQL data"
DIRnames["dataSQL2"]="SQL2 data"
DIRnames["data"]="Data disk"
DIRnames["vardbmysql"]="SQL data"
DIRnames["vardbmysql2"]="SQL2 data"
unset DIRwarnings; declare -A DIRwarnings;
DIRwarnings["varlog"]=4294967296
DIRwarnings["varmail"]=536870912
DIRwarnings["md"]=2147483648
DIRwarnings["dataSQL"]=42949672960
DIRwarnings["dataSQL2"]=42949672960
DIRwarnings["data"]=268435456000
DIRwarnings["vardbmysql"]=42949672960
DIRwarnings["vardbmysql2"]=85899345920
unset DIRcriticals; declare -A DIRcriticals;
DIRcriticals["varlog"]=10737418240
DIRcriticals["varmail"]=1073741824
DIRcriticals["md"]=3758096384
DIRcriticals["dataSQL"]=64424509440
DIRcriticals["dataSQL2"]=64424509440
DIRcriticals["data"]=536870912000
DIRcriticals["vardbmysql"]=102005473280
DIRcriticals["vardbmysql2"]=102005473280

### FIREWALL SETTINGS
# IPFW2 count rules numbers (3x WAN, 3x LAN, IPv4/6, in + out)
IPFW_LAN1_6OUT="01000"
IPFW_LAN1_6IN="03000"
IPFW_LAN1_4OUT="05000"
IPFW_LAN1_4IN="07000"
IPFW_LAN2_6OUT="01100"
IPFW_LAN2_6IN="03100"
IPFW_LAN2_4OUT="05100"
IPFW_LAN2_4IN="07100"
IPFW_LAN3_6OUT="01200"
IPFW_LAN3_6IN="03200"
IPFW_LAN3_4OUT="05200"
IPFW_LAN3_4IN="07200"
IPFW_WAN1_6IN="09000"
IPFW_WAN1_6OUT="11000"
IPFW_WAN1_4IN="13000"
IPFW_WAN1_4OUT="15000"
IPFW_WAN2_6IN="09100"
IPFW_WAN2_6OUT="11100"
IPFW_WAN2_4IN="13100"
IPFW_WAN2_4OUT="15100"
IPFW_WAN3_6IN="09200"
IPFW_WAN3_6OUT="11200"
IPFW_WAN3_4IN="13200"
IPFW_WAN3_4OUT="15200"

### PROGRAM PATHS
# Used program paths
SETFIB_PROG="/usr/sbin/setfib"
RM_PROG="/bin/rm"
CP_PROG="/bin/cp"
CAMCONTROL_PROG="/sbin/camcontrol"
SMARTCTL_PROG="/usr/local/sbin/smartctl"
SPEEDTEST_PROG="/usr/local/bin/speedtest-cli"
FPING_PROG="/usr/local/sbin/fping"
NETSTAT_PROG="/usr/bin/netstat"
AWK_PROG="/usr/bin/awk"
GREP_PROG="/usr/bin/grep"
