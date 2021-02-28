#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
. ${ZBXPATH}/_database.sh

SEMAPHOREFILE="${TEMPDIR}/.zabbix_pkg"
ZBXFILE="${ZBXDIR}/pkg"

PKG_PERIOD=${PKG_PERIOD:-86400}

# Check for one running instance only (with override after 24 hours)
if [[ -e "${SEMAPHOREFILE}" ]]; then
 fts=`stat -f %m "${SEMAPHOREFILE}"`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [[ ! -e "${SEMAPHOREFILE}" ]]; then
 touch "${SEMAPHOREFILE}" >> /dev/null 2>&1

# Check for new FreeBSD packages (default period is every 24 hours)
now=`date +%s`
if [ ! -e "${ZBXFILE}" ]; then
 ftime=$(( ${now} - ${PKG_PERIOD} - 100 ))
else
 ftime=`stat -f %m "${ZBXFILE}"`
fi
ftime=$(( ${now} - ${ftime} ))
if [[ "${ftime}" -gt "${PKG_PERIOD}" ]]; then
 echo -n > "${ZBXFILE}"
 pkg upgrade -n | grep "Number of packages to be upgraded" | awk '{print $7}' > "${ZBXFILE}"
fi

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
