#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH=$( dirname "${ZBXPATH}" )
else
 ZBXPATH="${ZBXPATH}"
fi
if [[ ! -e "${ZBXPATH}/_config.sh" ]]; then
 exit;
fi
. ${ZBXPATH}/_config.sh
if [[ ! -e "${ZBXPATH}/_database.sh" ]]; then
 exit;
fi
. ${ZBXPATH}/_database.sh

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
if [ -n "${IPFW_oif}" ]; then
 if [[ "${IFACES[${IPFW_oif}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_oif} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_oif}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_oif}\",\"{#IFALIAS}\":\"WAN1\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_oif}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_oif}]="1"
  if [ -n "${IPFW_oip}" ]; then
   IP4=`setfib 0 curl -s ipv4.icanhazip.com | xargs echo -n`
   echo "${IPFW_oip}" > "${ZBXFILE}.${IPFW_oif}.ipv4"
   echo "${IP4}" > "${ZBXFILE}.${IPFW_oif}.ipv4ext"
  else
   rm -f "${ZBXFILE}.${IPFW_oif}.ipv4"
   rm -f "${ZBXFILE}.${IPFW_oif}.ipv4ext"
  fi
  if [ -n "${IPFW_oip_6}" ]; then
   IP6=`setfib 0 curl -s ipv6.icanhazip.com | xargs echo -n`
   echo "${IP6}" > "${ZBXFILE}.${IPFW_oif}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_oif}.ipv6"
  fi
 fi
fi
if [ -n "${IPFW_oif2}" ]; then
 if [[ "${IFACES[${IPFW_oif2}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_oif2} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_oif2}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_oif2}\",\"{#IFALIAS}\":\"WAN2\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_oif2}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_oif2}]="1"
  if [ -n "${IPFW_oip2}" ]; then
   IP4=`setfib 1 curl -s ipv4.icanhazip.com | xargs echo -n`
   echo "${IPFW_oip2}" > "${ZBXFILE}.${IPFW_oif2}.ipv4"
   echo "${IP4}" > "${ZBXFILE}.${IPFW_oif2}.ipv4ext"
  else
   rm -f "${ZBXFILE}.${IPFW_oif2}.ipv4"
   rm -f "${ZBXFILE}.${IPFW_oif2}.ipv4ext"
  fi
  if [ -n "${IPFW_oip2_6}" ]; then
   IP6=`setfib 1 curl -s ipv6.icanhazip.com | xargs echo -n`
   echo "${IP6}" > "${ZBXFILE}.${IPFW_oif2}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_oif2}.ipv6"
  fi
 fi
fi
if [ -n "${IPFW_oif3}" ]; then
 if [[ "${IFACES[${IPFW_oif3}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_oif3} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_oif3}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_oif3}\",\"{#IFALIAS}\":\"WAN3\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_oif3}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_oif3}]="1"
  if [ -n "${IPFW_oip3}" ]; then
   IP4=`setfib 2 curl -s ipv4.icanhazip.com | xargs echo -n`
   echo "${IPFW_oip3}" > "${ZBXFILE}.${IPFW_oif3}.ipv4"
   echo "${IP4}" > "${ZBXFILE}.${IPFW_oif3}.ipv4ext"
  else
   rm -f "${ZBXFILE}.${IPFW_oif3}.ipv4"
   rm -f "${ZBXFILE}.${IPFW_oif3}.ipv4ext"
  fi
  if [ -n "${IPFW_oip3_6}" ]; then
   IP6=`setfib 2 curl -s ipv6.icanhazip.com | xargs echo -n`
   echo "${IP6}" > "${ZBXFILE}.${IPFW_oif3}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_oif3}.ipv6"
  fi
 fi
fi
if [ -n "${IPFW_iif}" ]; then
 if [[ "${IFACES[${IPFW_iif}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif}\",\"{#IFALIAS}\":\"LAN1\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif}]="1"
  if [ -n "${IPFW_iip}" ]; then
   echo "${IPFW_iip}" > "${ZBXFILE}.${IPFW_iif}.ipv4"
  else
   rm -f "${ZBXFILE}.${IPFW_iif}.ipv4"
  fi
  if [ -n "${IPFW_iip_6}" ]; then
   echo "${IPFW_iip_6}" > "${ZBXFILE}.${IPFW_iif}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_iif}.ipv6"
  fi
 fi
fi
if [ -n "${IPFW_iif2}" ]; then
 if [[ "${IFACES[${IPFW_iif2}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif2} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif2}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif2}\",\"{#IFALIAS}\":\"LAN2\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif2}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif2}]="1"
  if [ -n "${IPFW_iip2}" ]; then
   echo "${IPFW_iip2}" > "${ZBXFILE}.${IPFW_iif2}.ipv4"
  else
   rm -f "${ZBXFILE}.${IPFW_iif2}.ipv4"
  fi
  if [ -n "${IPFW_iip2_6}" ]; then
   echo "${IPFW_iip2_6}" > "${ZBXFILE}.${IPFW_iif2}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_iif2}.ipv6"
  fi
 fi
fi
if [ -n "${IPFW_iif3}" ]; then
 if [[ "${IFACES[${IPFW_iif3}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif3} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif3}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif3}\",\"{#IFALIAS}\":\"LAN3\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif3}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif3}]="1"
  if [ -n "${IPFW_iip3}" ]; then
   echo "${IPFW_iip3}" > "${ZBXFILE}.${IPFW_iif3}.ipv4"
  else
   rm -f "${ZBXFILE}.${IPFW_iif3}.ipv4"
  fi
  if [ -n "${IPFW_iip3_6}" ]; then
   echo "${IPFW_iip3_6}" > "${ZBXFILE}.${IPFW_iif3}.ipv6"
  else
   rm -f "${ZBXFILE}.${IPFW_iif3}.ipv6"
  fi
 fi
fi
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}"
chmod 666 "${ZBXFILE}"
