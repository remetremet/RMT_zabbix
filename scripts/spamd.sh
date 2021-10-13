#!/usr/local/bin/bash -
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

if [ x"${SPAMD_ENABLE}" == x"no" ]; then
 exit;
fi

SEMAPHOREFILE="${TEMPPATH}/.zabbix_spamd"
ZBXFILE="${DATAPATH}/spamd"

SPAMD_PERIOD="${SPAMD_PERIOD:-800}"

# Check for one running instance only (with override after 24 hours)
if [[ -e "${SEMAPHOREFILE}" ]]; then
 tts=`date +%s`
 fts=`stat -f %m "${SEMAPHOREFILE}"`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [[ ! -e "${SEMAPHOREFILE}" ]]; then
 touch "${SEMAPHOREFILE}" >> /dev/null 2>&1

# Check for spamd running instances (default period is every 15 minutes)
now=`date +%s`
if [ ! -e "${ZBXFILE}" ]; then
 ftime=$(( ${now} - ${SPAMD_PERIOD} - 100 ))
else
 ftime=`stat -f %m "${ZBXFILE}"`
fi
ftime=$(( ${now} - ${ftime} ))
if [[ "${ftime}" -gt "${SPAMD_PERIOD}" ]]; then
 echo -n > "${ZBXFILE}"

# Get the number of running spamd instances
 ps ax | grep "spamd" | grep -v "grep" | wc -l | sed 's/ //g' > "${ZBXFILE}"

fi

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
