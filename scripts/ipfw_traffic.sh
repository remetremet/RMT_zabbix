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
TODAY=`date +%d`
TODAY=$(( ${TODAY} + 0 ))
COUNT=0
IPV4=0
IPV4IN=0
IPV4OUT=0
IPV6=0
IPV6IN=0
IPV6OUT=0
IP=0
OLD=0
LAST=0
DELTA=0
MAXDELTA=3750000000 

XYZ="info"
. /etc/rc.firewall.config
XYZ=""

# IPFW counters autodetect
for i in ${IPFW_WANS_list}; do
 j="IPFW_oif${i}"
 k="IPFW_oip${i}"
 m="IPFW_oip${i}_6"
 if [ -n "${!j}" ]; then
  TEST=${IPFW_TRAFFIC_RESET["${i}"]}
echo "${i} ${TODAY} ${TEST}"
  if [ ${TODAY} -eq ${TEST} ]; then
echo "RESET"
   if [ ! -e "${TEMPFILE}.reset.${i}" ]; then
    echo "0" > "${TEMPFILE}.ip4_in${i}"
    echo "0" > "${TEMPFILE}.ip4_out${i}"
    echo "0" > "${TEMPFILE}.ip6_in${i}"
    echo "0" > "${TEMPFILE}.ip6_out${i}"
    touch "${TEMPFILE}.reset.${i}"
   fi
  else
   if [ -e "${TEMPFILE}.reset.${i}" ]; then
    rm -f "${TEMPFILE}.reset.${i}"
   fi
  fi
  protos="ip4 ip6"
  for proto in ${protos}; do
   ok=0
   if [ x"${proto}" == x"ip4" -a -n "${!k}" ]; then
    ok=1
   fi
   if [ x"${proto}" == x"ip6" -a -n "${!m}" ]; then
    ok=1
   fi
   if [ ${ok} -eq 1 ]; then
    ways="in out"
    for way in ${ways}; do
     LAST=0
     OLD=0
     DELTA=0
     COUNT=0
     if [ -e "${TEMPFILE}.${proto}_last${way}${i}" ]; then
      LAST=`cat "${TEMPFILE}.${proto}_last${way}${i}"`
      LAST=${LAST:-0}
     else
      LAST=0;
     fi
     if [ -e "${TEMPFILE}.${proto}_${way}${i}" ]; then
      OLD=`cat "${TEMPFILE}.${proto}_${way}${i}"`
      OLD=${OLD:-0}
     else
      OLD=0;
     fi
     COUNT=`ipfw -a list | grep "count ${proto}" | grep "via ${!j} ${way}" | /usr/bin/awk '{s+=$3} END {print s}'`
     COUNT=${COUNT:-0}
     echo "${COUNT}" > ${TEMPFILE}.${proto}_last${way}${i}
     if [ ${LAST} -le ${COUNT} ]; then
      DELTA=$(( ${COUNT} - ${LAST} ))
     else
      DELTA="${COUNT}"
     fi
     if [ ${DELTA} -lt 0 ]; then
      DELTA=0;
     fi
     if [ ${DELTA} -gt ${MAXDELTA} ]; then
      DELTA=${MAXDELTA};
     fi
     OLD=$(( ${OLD} + ${DELTA} ))
     echo "${OLD}" > ${TEMPFILE}.${proto}_${way}${i}
    done
   fi
  done
 fi
done
IPV4IN=`cat ${TEMPFILE}.ip4_in* | /usr/bin/awk '{s+=$1} END {print s}'`
IPV4IN=${IPV4IN:-0}
IPV4OUT=`cat ${TEMPFILE}.ip4_out* | /usr/bin/awk '{s+=$1} END {print s}'`
IPV4OUT=${IPV4OUT:-0}
IPV6IN=`cat ${TEMPFILE}.ip6_in* | /usr/bin/awk '{s+=$1} END {print s}'`
IPV6IN=${IPV6IN:-0}
IPV6OUT=`cat ${TEMPFILE}.ip6_out* | /usr/bin/awk '{s+=$1} END {print s}'`
IPV6OUT=${IPV6OUT:-0}
echo "${IPV4IN}" > ${ZBXFILE}.ipv4_in
echo "${IPV4OUT}" > ${ZBXFILE}.ipv4_out
echo "${IPV6IN}" > ${ZBXFILE}.ipv6_in
echo "${IPV6OUT}" > ${ZBXFILE}.ipv6_out
IPV4=$(( ${IPV4OUT} + ${IPV4IN} ))
echo "${IPV4}" > ${ZBXFILE}.ipv4
IPV6=$(( ${IPV6OUT} + ${IPV6IN} ))
echo "${IPV6}" > ${ZBXFILE}.ipv6
IP=$(( ${IPV6} + ${IPV4} ))
echo "${IP}" > ${ZBXFILE}.ip
chmod 666 ${ZBXFILE}.ip*
