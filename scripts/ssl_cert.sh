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

if [ x"${SSL_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/zabbix_ssl"
SEMAPHOREFILE="${TEMPPATH}/.zabbix_ssl"
ZBXFILE="${DATAPATH}/ssl"

f=$1
host=$2
port=$3
sni=$4
proto=$5

if [ -z "${sni}" ]; then
  servername=${host}
else
  servername=${sni}
fi
if [ -n "${proto}" ]; then
  starttls="-starttls ${proto}"
fi
end_date=`openssl s_client -servername ${servername} -host ${host} -port ${port} -showcerts ${starttls} -prexit </dev/null 2>/dev/null | sed -n '/BEGIN CERTIFICATE/,/END CERT/p' | openssl x509 -text 2>/dev/null | sed -n 's/ *Not After : *//p' | sed 's/ GMT//g'`
if [ -n "${end_date}" ]; then
 end_date_seconds=`date -j -f "%b %d %T %Y" "${end_date}" "+%s"`
 now_seconds=`date '+%s'`
 echo $(((${end_date_seconds}-${now_seconds})/86400))
fi
