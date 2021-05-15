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

if [ x"${MFI_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/mfi"
ZBXFILE="${DATAPATH}/mfi"

XYZ=""
for ID in ${MFI_IDS}; do
 IP="${MFI_IP[$ID]}"
 PORTS="${MFI_PORT[$ID]}"
 curl -s -X POST -d "username=${MFI_USERNAME}&password=${MFI_PASSWORD}" -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${IP}/login.cgi
 for PORT in ${PORTS}; do
  curl -s -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${IP}/sensors/${PORT} | python -mjson.tool | grep ":" | grep -v "status" | grep -v "sensors" > "${TEMPFILE}_${ID}_${PORT}"
  if [[ -e "${TEMPFILE}_${ID}_${PORT}" ]]; then
   for KEY in ${MFI_KEYS}; do
    RES=`cat "${TEMPFILE}_${ID}_${PORT}" | grep "\"${KEY}\"" | cut -d ':' -f 2 | sed 's/.$//' | sed 's/^ *//'`
    RES=${RES:-0}
    echo "${RES}" > "${ZBXFILE}_${ID}_${PORT}_${KEY}"
   done
   XYZ="${XYZ}{\"{#MFIID}\":\"${ID}_${PORT}\",\"{#MFIDEVICE}\":\"${ID}\",\"{#MFIIP}\":\"${IP}\",\"{#MFIPORT}\":\"${PORT}\"},"
   /bin/rm -f "${TEMPFILE}_${ID}_${PORT}" 
  fi
 done
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}_discovery"
