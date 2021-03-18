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

if [ x"${ACPIBATT_ENABLE}" == x"no" ]; then
 exit;
fi

ZBXFILE="${ZBXPATH}/acpi_battery"
TEMPFILE="${TEMPPATH}/acpi_battery"
SEMAPHOREFILE="${TEMPPATH}/.zabbix_battery"

if [[ -e "${SEMAPHOREFILE}" ]]; then
 fts=`stat -f %m "${SEMAPHOREFILE}"`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [[ ! -e "${SEMAPHOREFILE}" ]]; then
 touch "${SEMAPHOREFILE}" >> /dev/null 2>&1

 batt_available=`acpiconf -i 0 | grep -v "Device not configured" | wc -l | awk '{ print $1 }'`
 if [[ "${batt_available}" -gt "0" ]]; then
  acpiconf -i 0 > ${TEMPFILE}
  cat ${TEMPFILE} | grep "" > "${ZBXFILE}."
  chmod 666 "${ZBXFILE}"
 fi

fi
