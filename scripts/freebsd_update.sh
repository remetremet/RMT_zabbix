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

if [ x"${FREEBSD_UPDATE_ENABLE}" == x"no" ]; then
 exit;
fi

SEMAPHOREFILE="${TEMPPATH}/.zabbix_freebsd_update"
ZBXFILE="${DATAPATH}/freebsd_update"

FREEBSD_UPDATE_PERIOD="${FREEBSD_UPDATE_PERIOD:-86400}"
FREEBSD_UPDATE_CONF="${FREEBSD_UPDATE_CONF:-/etc/freebsd-update.conf}"
FREEBSD_UPDATE_PUB_SSL="${FREEBSD_UPDATE_PUB_SSL:-${TEMPPATH}/freebsd-update-pub.ssl}"

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

now=`date +%s`
if [ ! -e "${ZBXFILE}.running" ]; then
 ftime=$(( ${now} - ${FREEBSD_UPDATE_PERIOD} - 100 ))
else
 ftime=`stat -f %m "${ZBXFILE}.running"`
fi
ftime=$(( ${now} - ${ftime} ))
if [[ "${ftime}" -gt "${FREEBSD_UPDATE_PERIOD}" ]]; then

DONE=0
#set -o pipefail
get_conf(){
 key="$1"
 grep -o "^[[:space:]]*${key}[[:space:]]*\([^[:space:]]*\)" ${FREEBSD_UPDATE_CONF} | sed 's/.*[[:space:]]//'
}
get_servers(){
 name="_http._tcp.$1"
 host -t srv "${name}" | sed -nE "s/${name} (has SRV record|server selection) //I; s/\.$//; p" | sort -n -k 1 | cut -f 4 -d ' ' | sort -R
}
check_update(){
 base_url="$1"
 if [ ! -f "${FREEBSD_UPDATE_PUB_SSL}" ]; then
  fetch -q -o "${FREEBSD_UPDATE_PUB_SSL}" "${base_url}/pub.ssl" || return
 fi
 sig=`sha256 ${FREEBSD_UPDATE_PUB_SSL} | sed 's/.*= //'`
 [ x"${sig}" == x"${KEYPRINT}" ] || return
 meta=`fetch -q -o - "${base_url}/latest.ssl" | openssl rsautl -pubin -inkey ${FREEBSD_UPDATE_PUB_SSL} -verify | sed 's/|/ /g'` || return
 set -- $meta
 rel="$3"
 patchlevel="$4"
 eol="$6"
 running=`uname -r`
 echo "${running}" > "${ZBXFILE}.running"
 echo "${rel}-p${patchlevel}" > "${ZBXFILE}.latest"
 echo "${eol}" >  "${ZBXFILE}.EOL"
 DONE=1
}

KEYPRINT=`get_conf KeyPrint`
servername=`get_conf ServerName`
rel=`freebsd-version | sed -E -e 's,-p[0-9]+,,' -e 's,-SECURITY,-RELEASE,'`
arch=`uname -m`
for s in `get_servers ${servername}`; do
 if [[ "${DONE}" -eq "0" ]]; then
  base_url="http://$s/${rel}/${arch}"
  check_update ${base_url}
 fi

done
fi

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
