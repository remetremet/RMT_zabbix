#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
SCRIPTSPATH="${ZBXPATH}/scripts"

HOUR=`date +%H`
MINUTE=`date +%M`

### Get updates from Github repo every hour
if [ x"${MINUTE}" == x"01" ]; then
 if [ -e "${ZBXPATH}/_update.sh" ]; then
  ${ZBXPATH}/_update.sh auto > /dev/null 2>&1 &
 fi
 sleep 1
fi

### Run all the scripts
if [ -e "${SCRIPTSPATH}/hdd_traffic.sh" ]; then
 ${SCRIPTSPATH}/hdd_traffic.sh &
fi
if [ -e "${SCRIPTSPATH}/ipfw_traffic.sh" ]; then
 ${SCRIPTSPATH}/ipfw_traffic.sh &
fi
if [ -e "${SCRIPTSPATH}/mfi_get.sh" ]; then
 ${SCRIPTSPATH}/mfi_get.sh &
fi
if [ x"${MINUTE}" == x"01" ]; then
 if [ -e "${SCRIPTSPATH}/network_discovery.sh" ]; then
  ${SCRIPTSPATH}/network_discovery.sh &
 fi
fi
if [ -e "${SCRIPTSPATH}/rping.sh" ]; then
 ${SCRIPTSPATH}/rping.sh &
fi
if [ -e "${SCRIPTSPATH}/speedtest.sh" ]; then
 ${SCRIPTSPATH}/speedtest.sh > /dev/null 2>&1 &
fi
if [ -e "${SCRIPTSPATH}/smart.sh" ]; then
 ${SCRIPTSPATH}/smart.sh &
fi
if [ x"${HOUR}" == x"02" ]; then
 if [ x"${MINUTE}" == x"15" ]; then
  if [ -e "${SCRIPTSPATH}/pkg.sh" ]; then
   ${SCRIPTSPATH}/pkg.sh &
  fi
  if [ -e "${SCRIPTSPATH}/freebsd_update.sh" ]; then
   ${SCRIPTSPATH}/freebsd_update.sh &
  fi
 fi
fi
