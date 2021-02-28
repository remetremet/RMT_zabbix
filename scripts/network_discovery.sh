#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH="${ZBXPATH}/.."
else
 ZBXPATH="${ZBXPATH}"
fi
. ${ZBXPATH}/_config.sh
. ${ZBXPATH}/_database.sh

if [ x"${NETWORK_DISCOVERY_ENABLE}" == x"no" ]; then
 exit;
fi
if [ ! -e "/etc/rc.firewall.config" ]; then
 exit;
fi

ZBXFILE="${ZBXDIR}/network_discovery"
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
 fi
fi
if [ -n "${IPFW_oif2}" ]; then
 if [[ "${IFACES[${IPFW_oif2}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_oif2} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_oif2}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_oif2}\",\"{#IFALIAS}\":\"WAN2\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_oif2}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_oif2}]="1"
 fi
fi
if [ -n "${IPFW_oif3}" ]; then
 if [[ "${IFACES[${IPFW_oif3}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_oif3} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_oif3}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_oif3}\",\"{#IFALIAS}\":\"WAN3\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_oif3}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_oif3}]="1"
 fi
fi
if [ -n "${IPFW_iif}" ]; then
 if [[ "${IFACES[${IPFW_iif}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif}\",\"{#IFALIAS}\":\"LAN1\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif}]="1"
 fi
fi
if [ -n "${IPFW_iif2}" ]; then
 if [[ "${IFACES[${IPFW_iif2}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif2} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif2}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif2}\",\"{#IFALIAS}\":\"LAN2\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif2}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif2}]="1"
 fi
fi
if [ -n "${IPFW_iif3}" ]; then
 if [[ "${IFACES[${IPFW_iif3}]}" -eq "" ]]; then
  MAC=`ifconfig ${IPFW_iif3} | grep "ether" | awk '{ print $2}'`
  echo "${MAC}" > "${ZBXFILE}.${IPFW_iif3}.mac"
  XYZ="${XYZ}{\"{#IFNAME}\":\"${IPFW_iif3}\",\"{#IFALIAS}\":\"LAN3\",\"{#IFDESCR}\":\"${IFNAMES[${IPFW_iif3}]}\",\"{#IFMAC}\":\"${MAC}\"},"
  IFACES[${IPFW_iif3}]="1"
 fi
fi
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}"
chmod 666 "${ZBXFILE}"