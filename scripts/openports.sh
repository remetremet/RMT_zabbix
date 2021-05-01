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

if [ x"${OPENPORTS_ENABLE}" == x"no" ]; then
 exit;
fi

SEMAPHOREFILE="${TEMPPATH}/.zabbix_openports"
ZBXFILE="${DATAPATH}/openports"

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
 netstat -na | grep "*.*" | grep -E "(tcp|udp)" | awk '{ print $4; }' | sed -E 's/^.*\.([0-9]+)$/\1/' | uniq | sort | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/' | sed 's/,/ /g' > "${ZBXFILE}"
 cat "${ZBXFILE}" | sha256 > "${ZBXFILE}.hash"
 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
