#!/usr/local/bin/bash

maxfibs=$(( $( sysctl -n net.fibs ) - 1 ))

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
if [[ ! x"${maxfibs}" == x"0" ]]; then
 if [ x"${FIBS4}" == x"" ]; then
  FIBS4="0"
  for FI in $( seq 1 1 ${maxfibs} ); do
   FIBS4="${FIBS4} ${FI}"
  done
 fi
 if [ x"${FIBS6}" == x"" ]; then
  FIBS6="0"
  for FI in $( seq 1 1 ${maxfibs} ); do
   FIBS6="${FIBS6} ${FI}"
  done
 fi
else
 FIBS4="0"
 FIBS6="0"
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
for IN in ${IFNAMES_NAME}; do
 for IC in $( seq 0 1 7 ); do
  IFN="${IN}${IC}"
  TEST=${IFNAMES["${IFN}"]}
  if [ x"${TEST}" == x"" ]; then
   IFNAMES[${IFN}]="${IFN}"
  fi
 done
done

# Human readable name of WANs (default settings can be override in _config.sh)
for FI in $( seq 0 1 ${maxfibs} ); do
 TEST=${FIB_NAMES["${FI}"]}
 if [ x"${TEST}" == x"" ]; then
  ISP=$(( ${FI} + 1 ))
  FIB_NAMES["${FI}"]="ISP ${ISP}"
 fi
done

### FreeBSD OS updates
# Check period in seconds (default settings can be override in _config.sh)
if [ x"${FREEBSD_UPDATE_PERIOD}" == x"" ]; then
 FREEBSD_UPDATE_PERIOD=86400
fi
if [ x"${FREEBSD_UPDATE_CONF}" == x"" ]; then
 FREEBSD_UPDATE_CONF="/etc/freebsd-update.conf"
fi

### FreeBSD packages check
# Period in seconds (default settings can be override in _config.sh)
if [ x"${PKG_PERIOD}" == x"" ]; then
 PKG_PERIOD=86400
fi

### IPFW traffic
# FUP renew day of month (per WAN) (default settings can be override in _config.sh)
for WI in $( seq 1 1 20 ); do
 TEST=${IPFW_TRAFFIC_RESET[${WI}]}
 if [ x"${TEST}" == x"" ]; then
  IPFW_TRAFFIC_RESET[${WI}]="1"
 fi
done

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
 MFI_PORT["1"]=$( seq 1 1 6)
fi

### SMART monitoring of HDD/SSD
# SMART check period (in seconds) (default settings can be override in _config.sh)
if [ x"${SMART_PERIOD}" == x"" ]; then
 SMART_PERIOD="3600"
fi
# Timeout to wake up sleeing disk to get SMART data (in seconds) (default settings can be override in _config.sh)
if [ x"${SMART_FORCE_PERIOD}" == x"" ]; then
 SMART_FORCE_PERIOD="86400"
fi

### Speedtest monitoring
# Proceed speedtest once a period (in seconds) (default settings can be override in _config.sh)
for WI in $( seq 0 1 19 ); do
 TEST=${SPEEDTEST_PERIOD[${WI}]}
 if [ x"${TEST}" == x"" ]; then
  SPEEDTEST_PERIOD[${WI}]="86400"
 fi
done



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
