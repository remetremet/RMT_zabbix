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

if [ x"${RPING_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/zabbix_rping_addr"
RESFILE="${TEMPPATH}/zabbix_rping_results"
SEMAPHOREFILE="${TEMPPATH}/.zabbix_rping"
DISCOVERYFILE="${DATAPATH}/rping_discovery"
RPINGFILE="${DATAPATH}/rping"
RPLFILE="${DATAPATH}/rpl"

FIBS4="${FIBS4:-0}"
FIBS6="${FIBS6:-0}"

# Check for one running instance only (with override after 24 hours)
if [[ -e "${SEMAPHOREFILE}" ]]; then
 fts=`stat -f %m ${SEMAPHOREFILE}`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [[ ! -e "${SEMAPHOREFILE}" ]]; then
 touch "${SEMAPHOREFILE}"

echo -n "" > "${TEMPFILE}4"
echo -n "" > "${TEMPFILE}6"
echo -n "" > "${DISCOVERYFILE}"
DISCOVERY4=""
DISCOVERY6=""
DISCOVERY=""

for A in ${ADDRS4}; do
 echo ${A} >> "${TEMPFILE}4"
 DISCOVERY4="${DISCOVERY4}{\"{#PINGADDR}\":\"${A}\",\"{#PINGFAMILY}\":\"4\",\"{#PINGNAME}\":\"${ADDR_NAMES[$A]}\"%FIB%},"
done
for A in ${ADDRS6}; do
 echo ${A} >> "${TEMPFILE}6"
 DISCOVERY6="${DISCOVERY6}{\"{#PINGADDR}\":\"${A}\",\"{#PINGFAMILY}\":\"6\",\"{#PINGNAME}\":\"${ADDR_NAMES[$A]}\"%FIB%},"
done

for FIB in ${FIBS4}; do
 /bin/rm -f "${TEMPDIR}/rping_done${FIB}_4" >> /dev/null 2>&1
 D=`echo "${DISCOVERY4}" | sed "s/%FIB%/,\"{#PINGFIB}\":\"${FIB}\",\"{#PINGFIBNAME}\":\"${FIB_NAMES[$FIB]}\"/g"`
 DISCOVERY="${DISCOVERY}${D}"
 A=${GW_ADDRS4[$FIB]}
 DISCOVERY="${DISCOVERY}{\"{#PINGADDR}\":\"${A}\",\"{#PINGFAMILY}\":\"4\",\"{#PINGNAME}\":\"${ADDR_NAMES[$A]}\",\"{#PINGFIB}\":\"${FIB}\",\"{#PINGFIBNAME}\":\"${FIB_NAMES[$FIB]}\"},"
 cat "${TEMPFILE}4" > "${TEMPFILE}4${FIB}"
 echo "${A}" >> "${TEMPFILE}4${FIB}"
 /usr/sbin/setfib ${FIB} fping -q4 -t 500 -p 100 -c 100 -f "${TEMPFILE}4${FIB}" 2>&1 | sed 's/\// /g' | awk '{T=$15; if(T=="")T=0; print $1" "T" "$9; }' | sed 's/%//' | sed 's/,//' > "${RESFILE}${FIB}_4" && echo "1" > "${TEMPDIR}/rping_done${FIB}_4" &
done
for FIB in ${FIBS6}; do
 /bin/rm -f "${TEMPDIR}/rping_done${FIB}_6" >> /dev/null 2>&1
 D=`echo "${DISCOVERY6}" | sed "s/%FIB%/,\"{#PINGFIB}\":\"${FIB}\",\"{#PINGFIBNAME}\":\"${FIB_NAMES[$FIB]}\"/g"`
 DISCOVERY="${DISCOVERY}${D}"
 A=${GW_ADDRS6[$FIB]}
 cat "${TEMPFILE}6" > "${TEMPFILE}6${FIB}"
 echo "${A}" >> "${TEMPFILE}6${FIB}"
 DISCOVERY="${DISCOVERY}{\"{#PINGADDR}\":\"${A}\",\"{#PINGFAMILY}\":\"6\",\"{#PINGNAME}\":\"${ADDR_NAMES[$A]}\",\"{#PINGFIB}\":\"${FIB}\",\"{#PINGFIBNAME}\":\"${FIB_NAMES[$FIB]}\"},"
 /usr/sbin/setfib ${FIB} fping -q6 -t 500 -p 100 -c 100 -f "${TEMPFILE}6${FIB}" 2>&1 | sed 's/\// /g' | awk '{T=$15; if(T=="")T=0; print $1" "T" "$9; }' | sed 's/%//' | sed 's/,//' > "${RESFILE}${FIB}_6" && echo "1" > "${TEMPDIR}/rping_done${FIB}_6" &
done
DISCOVERY="[${DISCOVERY::(-1)}]"
echo "${DISCOVERY}" > "${DISCOVERYFILE}"
for FIB in ${FIBS4}; do
 while [[ ! -e "${TEMPDIR}/rping_done${FIB}_4" ]]; do
  /bin/sleep 1
 done
done
for FIB in ${FIBS6}; do
 while [[ ! -e "${TEMPDIR}/rping_done${FIB}_6" ]]; do
  /bin/sleep 1
 done
done
/bin/rm -f "${TEMPFILE}4" >> /dev/null 2>&1
/bin/rm -f "${TEMPFILE}6" >> /dev/null 2>&1
for FIB in ${FIBS4}; do
 for A in ${ADDRS4}; do
  cat "${RESFILE}${FIB}_4" | grep "${A}" | awk '{ print $3; }' > "${RPLFILE}_${FIB}_${A}"
  cat "${RESFILE}${FIB}_4" | grep "${A}" | awk '{ print $2; }' > "${RPINGFILE}_${FIB}_${A}"
 done
 cat "${RESFILE}${FIB}_4" | grep "${GW_ADDRS4[$FIB]}" | awk '{ print $3; }' > "${RPLFILE}_${FIB}_${GW_ADDRS4[$FIB]}"
 cat "${RESFILE}${FIB}_4" | grep "${GW_ADDRS4[$FIB]}" | awk '{ print $2; }' > "${RPINGFILE}_${FIB}_${GW_ADDRS4[$FIB]}"
 /bin/rm -f "${RESFILE}${FIB}_4" >> /dev/null 2>&1
 /bin/rm -f "${TEMPDIR}/rping_done${FIB}_4" >> /dev/null 2>&1
 /bin/rm -f "${TEMPFILE}4${FIB}" >> /dev/null 2>&1
done
for FIB in ${FIBS6}; do
 for A in ${ADDRS6}; do
  cat "${RESFILE}${FIB}_6" | grep "${A}" | awk '{ print $3; }' > "${RPLFILE}_${FIB}_${A}"
  cat "${RESFILE}${FIB}_6" | grep "${A}" | awk '{ print $2; }' > "${RPINGFILE}_${FIB}_${A}"
 done
 cat "${RESFILE}${FIB}_6" | grep "${GW_ADDRS6[$FIB]}" | awk '{ print $3; }' > "${RPLFILE}_${FIB}_${GW_ADDRS6[$FIB]}"
 cat "${RESFILE}${FIB}_6" | grep "${GW_ADDRS6[$FIB]}" | awk '{ print $2; }' > "${RPINGFILE}_${FIB}_${GW_ADDRS6[$FIB]}"
 /bin/rm -f "${RESFILE}${FIB}_6" >> /dev/null 2>&1
 /bin/rm -f "${TEMPDIR}/rping_done${FIB}_6" >> /dev/null 2>&1
 /bin/rm -f "${TEMPFILE}6${FIB}" >> /dev/null 2>&1
done

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
