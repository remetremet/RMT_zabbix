#!/usr/local/bin/bash -

ZBXPATH=$( dirname "$(realpath $0)" )
. ${ZBXPATH}/_database.sh

if [ x"${SPEEDTEST_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPDIR}/zabbix_speedtest"
SEMAPHOREFILE="${TEMPDIR}/.zabbix_speedtest"
ZBXFILE="${ZBXDIR}/speedtest"
DISCOVERYFILE="${ZBXDIR}/speedtest_discovery"

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
  setfib ${FIB} speedtest-cli --csv --csv-delimiter ";" --timeout 8 ${SPEEDTEST_SERVERS} > "${TEMPFILE}.${FIB}"
  err=$?
  if [[ "${err}" -gt "0" ]]; then
   /bin/rm -f "${TEMPFILE}.${FIB}" >> /dev/null 2>&1
  else
   Sdown=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $7" "$8" "$10}' | sed 's/\./ /g' | awk '{T=$1; if(T=="")T=0; print T;}'`
   Sup=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $7" "$8" "$10}' | sed 's/\./ /g' | awk '{T=$3; if(T=="")T=0; print T;}'`
   Sip=`cat "${TEMPFILE}.${FIB}" | awk -F ";" '{print $7" "$8" "$10}' | awk '{T=$3; if(T=="")T="0.0.0.0"; print T;}'`
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
