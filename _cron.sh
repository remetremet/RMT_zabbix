#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )

HOUR=`date +%H`
MINUTE=`date +%M`

# Get updates from Github repo every hour
if [ x"${MINUTE}" == x"01" ]; then
 if [ -e "${ZBXPATH}/_update.sh" ]; then
  ${ZBXPATH}/_update.sh > /dev/null 2>&1 &
 fi
 sleep 1
fi
# Run all the scripts
if [ -e "${ZBXPATH}/ipfw_traffic.sh" ]; then
 ${ZBXPATH}/ipfw_traffic.sh &
fi
if [ -e "${ZBXPATH}/mfi_get.sh" ]; then
 ${ZBXPATH}/mfi_get.sh &
fi
if [ x"${MINUTE}" == x"01" ]; then
 if [ -e "${ZBXPATH}/network_discovery.sh" ]; then
  ${ZBXPATH}/network_discovery.sh &
 fi
fi
if [ -e "${ZBXPATH}/rping.sh" ]; then
 ${ZBXPATH}/rping.sh &
fi
if [ -e "${ZBXPATH}/speedtest.sh" ]; then
 ${ZBXPATH}/speedtest.sh > /dev/null 2>&1 &
fi
if [ -e "${ZBXPATH}/smart.sh" ]; then
 ${ZBXPATH}/smart.sh &
fi
if [ x"${HOUR}" == x"02" ]; then
 if [ x"${MINUTE}" == x"15" ]; then
  if [ -e "${ZBXPATH}/pkg.sh" ]; then
   ${ZBXPATH}/pkg.sh &
  fi
  if [ -e "${ZBXPATH}/freebsd_update.sh" ]; then
   ${ZBXPATH}/freebsd_update.sh &
  fi
 fi
fi
