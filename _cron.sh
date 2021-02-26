#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )

HOUR=`date +%H`
MINUTE=`date +%M`

if [ x"${MINUTE}" == x"01" ]; then
 if [ -e "${ZBXPATH}/_update.sh" ]; then
  ${ZBXPATH}/_update.sh
 fi
 sleep 1
fi
if [ -e "${ZBXPATH}/if6_traffic.sh" ]; then
 ${ZBXPATH}/if6_traffic.sh &
fi
if [ -e "${ZBXPATH}/mfi_get.sh" ]; then
 ${ZBXPATH}/mfi_get.sh &
fi
if [ -e "${ZBXPATH}/network_discovery.sh" ]; then
 ${ZBXPATH}/network_discovery.sh &
fi
if [ -e "${ZBXPATH}/rping.sh" ]; then
 ${ZBXPATH}/rping.sh &
fi
if [ -e "${ZBXPATH}/speedtest.sh" ]; then
 ${ZBXPATH}/speedtest.sh >> /dev/null 2>&1 &
fi
if [ -e "${ZBXPATH}/smartctl.sh" ]; then
 ${ZBXPATH}/smartctl.sh &
fi
if [ x"${HOUR}" == x"02" ]; then
 if [ x"${MINUTE}" == x"15" ]; then
  if [ -e "${ZBXPATH}/pkg.sh" ]; then
   ${ZBXPATH}/pkg.sh &
  fi
  if [ -e "${ZBXPATH}/freebsd-update.sh" ]; then
   ${ZBXPATH}/freebsd-update.sh &
  fi
 fi
fi
