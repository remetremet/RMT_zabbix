#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH="${ZBXPATH}/.."
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

if [ x"${HDD_TRAFFIC_ENABLE}" == x"no" ]; then
 exit;
fi
TEMPFILE="${TEMPPATH}/hdd_traffic"
ZBXFILE="${DATAPATH}/hdd_traffic"
DISCOVERYFILE="${DATAPATH}/hdd_discovery"

iostat  -x -w 50 -t da -c 2 | grep -v "device" > "${TEMPFILE}"
DISKS=`/sbin/sysctl -n kern.disks`
XYZ=""
for DISK in ${DISKS}; do
 XYZ="${XYZ}{\"{#HDDNAME}\":\"${DISK}\"},"
 cat "${TEMPFILE}" | grep "^${DISK}" | tail -n 1 > "${TEMPFILE}.${DISK}"
 read_per_sec=0;
 write_per_sec=0;
 read_kb_per_sec=0;
 write_kb_per_sec=0;
 read_per_sec=`cat "${TEMPFILE}.${DISK}" | awk '{print $2}'`
 write_per_sec=`cat "${TEMPFILE}.${DISK}" | awk '{print $3}'`
 read_kb_per_sec=`cat "${TEMPFILE}.${DISK}" | awk '{print $4}'`
 write_kb_per_sec=`cat "${TEMPFILE}.${DISK}" | awk '{print $5}'`
 echo "${read_per_sec}" > "${ZBXFILE}.${DISK}.rps"
 echo "${write_per_sec}" > "${ZBXFILE}.${DISK}.wps"
 echo "${read_kb_per_sec}" > "${ZBXFILE}.${DISK}.rkb"
 echo "${write_kb_per_sec}" > "${ZBXFILE}.${DISK}.wkb"
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${DISCOVERYFILE}"
chmod 666 "${ZBXFILE}.*"
chmod 666 "${DISCOVERYFILE}"
