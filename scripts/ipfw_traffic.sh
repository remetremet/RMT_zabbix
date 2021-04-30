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

if [ x"${IPFW_ENABLE}" == x"no" ]; then
 exit;
fi
if [ ! -e "/etc/rc.firewall.config" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/ipfw_traffic"
ZBXFILE="${DATAPATH}/ipfw_traffic"

COUNT=0
IPV4=0
IPV4IN=0
IPV4OUT=0
IPV6=0
IPV6IN=0
IPV6OUT=0

XYZ="info"
. /etc/rc.firewall.config
XYZ=""

# IPFW counters autodetect
for i in ${IPFW_WANS_list}; do
 j="IPFW_oif${i}"
 k="IPFW_oip${i}"
 m="IPFW_oip${i}_6"
 if [ -n "${!j}" ]; then
  if [ -n "${!k}" ]; then
   COUNT=`ipfw -a list | grep "count ip4" | grep "via ${!j} in" | /usr/bin/awk '{s+=$3} END {print s}'`
   echo "${COUNT}" > ${TEMPFILE}.ipv4_in${i}
   IPV4IN=$(( ${IPV4IN} + ${COUNT} ))
   COUNT=`ipfw -a list | grep "count ip4" | grep "via ${!j} out" | /usr/bin/awk '{s+=$3} END {print s}'`
   echo "${COUNT}" > ${TEMPFILE}.ipv4_out${i}
   IPV4OUT=$(( ${IPV4OUT} + ${COUNT} ))
  fi
  if [ -n "${!m}" ]; then
   COUNT=`ipfw -a list | grep "count ip6" | grep "via ${!j} in" | /usr/bin/awk '{s+=$3} END {print s}'`
   echo "${COUNT}" > ${TEMPFILE}.ipv6_in${i}
   IPV6IN=$(( ${IPV6IN} + ${COUNT} ))
   COUNT=`ipfw -a list | grep "count ip6" | grep "via ${!j} out" | /usr/bin/awk '{s+=$3} END {print s}'`
   echo "${COUNT}" > ${TEMPFILE}.ipv6_out${i}
   IPV6OUT=$(( ${IPV6OUT} + ${COUNT} ))
  fi
 fi
done
echo "${IPV4IN}" > ${ZBXFILE}.ipv4_in
echo "${IPV4OUT}" > ${ZBXFILE}.ipv4_out
echo "${IPV6IN}" > ${ZBXFILE}.ipv6_in
echo "${IPV6OUT}" > ${ZBXFILE}.ipv6_out
IPV4=$(( ${IPV4OUT} + ${IPV4IN} ))
echo "${IPV4}" > ${ZBXFILE}.ipv4
IPV6=$(( ${IPV6OUT} + ${IPV6IN} ))
echo "${IPV6}" > ${ZBXFILE}.ipv6
chmod 666 ${ZBXFILE}.ip*
