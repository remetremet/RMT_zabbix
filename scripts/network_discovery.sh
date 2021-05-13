#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH=$( dirname "${ZBXPATH}" )
else
 ZBXPATH="${ZBXPATH}"
fi
if [[ ! -e "${ZBXPATH}/_database.sh" ]]; then
 exit;
fi
. ${ZBXPATH}/_database.sh
if [[ ! -e "${ZBXPATH}/_config.sh" ]]; then
 exit;
fi
. ${ZBXPATH}/_config.sh

if [ x"${NETWORK_DISCOVERY_ENABLE}" == x"no" ]; then
 exit;
fi
if [ ! -e "/etc/rc.firewall.config" ]; then
 exit;
fi

ZBXFILE="${DATAPATH}/network_discovery"
unset IFACES; declare -A IFACES;

XYZ="info"
. /etc/rc.firewall.config
XYZ=""
for i in ${IPFW_WANS_list}; do
 j="IPFW_oif${i}"
 k="IPFW_oip${i}"
 l="IPFW_ofib${i}"
 m="IPFW_oip${i}_6"
 n="IPFW_ofib${i}_6"
 if [ -n "${!j}" ]; then
  if [[ "${IFACES[${!j}]}" -eq "" ]]; then
   MAC=`ifconfig ${!j} | grep "ether" | awk '{ print $2}'`
   echo "${MAC}" > "${ZBXFILE}.${!j}.mac"
   XYZ="${XYZ}{\"{#IFNAME}\":\"${!j}\",\"{#IFALIAS}\":\"WAN${i}\",\"{#IFDESCR}\":\"${IFNAMES[${!j}]}\",\"{#IFMAC}\":\"${MAC}\"},"
   IFACES[${!j}]="1"
   if [ -n "${!k}" ]; then
    IP4=`setfib ${!l} curl -m 15 -s ipv4.icanhazip.com | xargs echo -n`
    echo "${!k}" > "${ZBXFILE}.${!j}.ipv4"
    echo "${IP4}" > "${ZBXFILE}.${!j}.ipv4ext"
   else
    rm -f "${ZBXFILE}.${!j}.ipv4"
    rm -f "${ZBXFILE}.${!j}.ipv4ext"
   fi
   if [ -n "${!m}" ]; then
    IP6=`setfib ${!n} curl -m 15 -s ipv6.icanhazip.com | xargs echo -n`
    echo "${IP6}" > "${ZBXFILE}.${!j}.ipv6"
   else
    rm -f "${ZBXFILE}.${!j}.ipv6"
   fi
  fi
 fi
done
for i in ${IPFW_LANS_list}; do
 j="IPFW_iif${i}"
 k="IPFW_iip${i}"
 m="IPFW_iip${i}_6"
 if [ -n "${!j}" ]; then
  if [[ "${IFACES[${!j}]}" -eq "" ]]; then
   MAC=`ifconfig ${!j} | grep "ether" | awk '{ print $2}'`
   echo "${MAC}" > "${ZBXFILE}.${!j}.mac"
   XYZ="${XYZ}{\"{#IFNAME}\":\"${!j}\",\"{#IFALIAS}\":\"LAN${i}\",\"{#IFDESCR}\":\"${IFNAMES[${!j}]}\",\"{#IFMAC}\":\"${MAC}\"},"
   IFACES[${!j}]="1"
   if [ -n "${!k}" ]; then
    echo "${!k}" > "${ZBXFILE}.${!j}.ipv4"
   else
    rm -f "${ZBXFILE}.${!j}.ipv4"
   fi
   if [ -n "${!m}" ]; then
    echo "${!m}" > "${ZBXFILE}.${!j}.ipv6"
   else
    rm -f "${ZBXFILE}.${!j}.ipv6"
   fi
  fi
 fi
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}"
chmod 666 "${ZBXFILE}"
