#!/usr/local/bin/bash
ZBXPATH=$( dirname "$(realpath $0)" )
. ${ZBXPATH}/_database.sh

if [ x"${MFI_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPDIR}/mfi"
ZBXFILE="${ZBXDIR}/mfi"
MFI_SESSIONID="1234567890ABCDEF1234567890ABCDEF"
MFI_USERNAME="ubnt"
MFI_PASSWORD="ubnt"
MFI_KEYS="output voltage power powerfactor current"

MFI_IP="192.168.250.1"
MFI_ID="1"
MFI_PORTS="1 2 3"
XYZ=""
curl -s -X POST -d "username=${MFI_USERNAME}&password=${MFI_PASSWORD}" -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/login.cgi
for PORT in ${MFI_PORTS}; do
 curl -s -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/sensors/${PORT} | python -mjson.tool | grep ":" | grep -v "status" | grep -v "sensors" > "${TEMPFILE}_${MFI_ID}_${PORT}"
 for KEY in ${MFI_KEYS}; do
  cat "${TEMPFILE}_${MFI_ID}_${PORT}" | grep "\"${KEY}\"" | cut -d ':' -f 2 | sed 's/.$//' | sed 's/^ *//' > "${ZBXFILE}_${MFI_ID}_${PORT}_${KEY}"
 done
 XYZ="${XYZ}{\"{#MFIPORT}\":\"${PORT}\"},"
 /bin/rm -f "${TEMPFILE}_${MFI_ID}_${PORT}" 
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}_${MFI_ID}_discovery"


MFI_IP="192.168.250.2"
MFI_ID="2"
MFI_PORTS="1 2 3 4 5 6"
XYZ=""
curl -s -X POST -d "username=${MFI_USERNAME}&password=${MFI_PASSWORD}" -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/login.cgi
for PORT in ${MFI_PORTS}; do
 curl -s -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/sensors/${PORT} | python -mjson.tool | grep ":" | grep -v "status" | grep -v "sensors" > "${TEMPFILE}_${MFI_ID}_${PORT}"
 for KEY in ${MFI_KEYS}; do
  cat "${TEMPFILE}_${MFI_ID}_${PORT}" | grep "\"${KEY}\"" | cut -d ':' -f 2 | sed 's/.$//' | sed 's/^ *//' > "${ZBXFILE}_${MFI_ID}_${PORT}_${KEY}"
 done
 XYZ="${XYZ}{\"{#MFIPORT}\":\"${PORT}\"},"
 /bin/rm -f "${TEMPFILE}_${MFI_ID}_${PORT}"
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}_${MFI_ID}_discovery"


MFI_IP="192.168.250.4"
MFI_ID="3"
MFI_PORTS="1 2 3"
XYZ=""
curl -s -X POST -d "username=${MFI_USERNAME}&password=${MFI_PASSWORD}" -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/login.cgi
for PORT in ${MFI_PORTS}; do
 curl -s -b "AIROS_SESSIONID=${MFI_SESSIONID}" ${MFI_IP}/sensors/${PORT} | python -mjson.tool | grep ":" | grep -v "status" | grep -v "sensors" > "${TEMPFILE}_${MFI_ID}_${PORT}"
 for KEY in ${MFI_KEYS}; do
  cat "${TEMPFILE}_${MFI_ID}_${PORT}" | grep "\"${KEY}\"" | cut -d ':' -f 2 | sed 's/.$//' | sed 's/^ *//' > "${ZBXFILE}_${MFI_ID}_${PORT}_${KEY}"
 done
 XYZ="${XYZ}{\"{#MFIPORT}\":\"${PORT}\"},"
 /bin/rm -f "${TEMPFILE}_${MFI_ID}_${PORT}"
done
XYZ="[${XYZ::(-1)}]"
echo "${XYZ}" > "${ZBXFILE}_${MFI_ID}_discovery"
