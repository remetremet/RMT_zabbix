#!/usr/local/bin/bash -
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

if [ x"${SPEEDTEST_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/zabbix_speedtest"
SEMAPHOREFILE="${TEMPPATH}/.zabbix_speedtest"
ZBXFILE="${DATAPATH}/speedtest"
DISCOVERYFILE="${DATAPATH}/speedtest_discovery"

FIBS4="${FIBS4:-0}"
FIBS6="${FIBS6:-0}"

if [[ -e "${SEMAPHOREFILE}" ]]; then
 fts=`stat -f %m "${SEMAPHOREFILE}"`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [[ ! -e "${SEMAPHOREFILE}" ]]; then
 touch "${SEMAPHOREFILE}" >> /dev/null 2>&1

now=`date +%s`
D=""
DISCOVERY=""
for FIB in ${FIBS4}; do
 if [ ! -e "${TEMPFILE}.${FIB}" ]; then
  fibtime=$(( ${now} - ${SPEEDTEST_PERIOD[$FIB]} - 100 ))
 else
  fibtime=`stat -f %m "${TEMPFILE}.${FIB}"`
 fi
 fibtime=$(( ${now} - ${fibtime} ))
 if [[ "${fibtime}" -gt "${SPEEDTEST_PERIOD[$FIB]}" ]]; then
  echo -n > "${TEMPFILE}.${FIB}"
  setfib ${FIB} speedtest-cli --list > "${TEMPFILE}.${FIB}.serverlist"
  setfib ${FIB} speedtest-cli --csv --csv-delimiter ";" --timeout 15 ${SPEEDTEST_SERVERS} > "${TEMPFILE}.${FIB}"
  err=$?
  if [[ "${err}" -gt "0" ]]; then
   /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
  else
   Sdown=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $7}' | sed 's/\./ /g' | awk '{T=$1; if(T=="")T=0; print T;}'`
   Sup=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $8}' | sed 's/\./ /g' | awk '{T=$1; if(T=="")T=0; print T;}'`
   Sip=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $10}'`
   Sserver=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $2","$3" ["$1"]"}'`
   if [[ "${Sdown}" -gt "0" ]]; then
    echo "${Sdown}" > "${ZBXFILE}_${FIB}.down"
   else
    /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
   fi
   if [[ "${Sup}" -gt "0" ]]; then
    echo "${Sup}" > "${ZBXFILE}_${FIB}.up"
   else
    /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
   fi
   if [[ "${Sserver}" == "" ]]; then
    /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
   else
    echo "${Sserver}" > "${ZBXFILE}_${FIB}.server"
   fi
   if [[ "${Sip}" == "" ]]; then
    /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
   else
    echo "${Sip}" > "${ZBXFILE}_${FIB}.extip"
    DISCOVERY="${DISCOVERY}{\"{#SPEEDTESTFIB}\":\"${FIB}\",\"{#SPEEDTESTFIBNAME}\":\"${FIB_NAMES[$FIB]}\",\"#SPEEDTESTIP\":\"${Sip}\"},"
    D="1"
   fi
  fi
 fi
done
# here can be a problem if measuring is set diffently on each FIBs
if [[ "${D}" -eq "1" ]]; then
 echo -n "" > "${DISCOVERYFILE}"
 DISCOVERY="[${DISCOVERY::(-1)}]"
 echo "${DISCOVERY}" > "${DISCOVERYFILE}"
fi

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
