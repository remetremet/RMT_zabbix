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

if [ x"${IPFW_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/ipfw_traffic"
ZBXFILE="${DATAPATH}/ipfw_traffic"

IPV4=0
IPV4IN=0
IPV4OUT=0
IPV6=0
IPV6IN=0
IPV6OUT=0

IPV4A=`/sbin/ipfw -a list | grep "count" | grep "^13000 " | /usr/bin/awk '{print $3}' `; IPV4A=${IPV4A:-0}
echo "${IPV4A}" > ${TEMPFILE}.ipv4_in1
IPV4IN=$(( $IPV4IN + $IPV4A ))
IPV4A=`/sbin/ipfw -a list | grep "count" | grep "^13100 " | /usr/bin/awk '{print $3}' `; IPV4A=${IPV4A:-0}
echo "${IPV4A}" > ${TEMPFILE}.ipv4_in2
IPV4IN=$(( $IPV4IN + $IPV4A ))
IPV4A=`/sbin/ipfw -a list | grep "count" | grep "^13200 " | /usr/bin/awk '{print $3}' `; IPV4A=${IPV4A:-0}
echo "${IPV4A}" > ${TEMPFILE}.ipv4_in3
IPV4IN=$(( $IPV4IN + $IPV4A ))
echo "${IPV4IN}" > ${ZBXFILE}.ipv4_in
IPV4B=`/sbin/ipfw -a list | grep "count" | grep "^15000 " | /usr/bin/awk '{print $3}' `; IPV4B=${IPV4B:-0}
echo "${IPV4B}" > ${TEMPFILE}.ipv4_out1
IPV4OUT=$(( $IPV4OUT + $IPV4B ))
IPV4B=`/sbin/ipfw -a list | grep "count" | grep "^15100 " | /usr/bin/awk '{print $3}' `; IPV4B=${IPV4B:-0}
echo "${IPV4B}" > ${TEMPFILE}.ipv4_out2
IPV4OUT=$(( $IPV4OUT + $IPV4B ))
IPV4B=`/sbin/ipfw -a list | grep "count" | grep "^15200 " | /usr/bin/awk '{print $3}' `; IPV4B=${IPV4B:-0}
echo "${IPV4B}" > ${TEMPFILE}.ipv4_out3
IPV4OUT=$(( $IPV4OUT + $IPV4B ))
echo "${IPV4OUT}" > ${ZBXFILE}.ipv4_out
IPV4=$(( $IPV4 + $IPV4IN + $IPV4OUT ))
echo "${IPV4}" > ${ZBXFILE}.ipv4

IPV6A=`/sbin/ipfw -a list | grep "count" | grep "^09000 " | /usr/bin/awk '{print $3}' `; IPV6A=${IPV6A:-0}
echo "${IPV6A}" > ${TEMPFILE}.ipv6_in1
IPV6IN=$(( $IPV6IN + $IPV6A ))
IPV6A=`/sbin/ipfw -a list | grep "count" | grep "^09100 " | /usr/bin/awk '{print $3}' `; IPV6A=${IPV6A:-0}
echo "${IPV6A}" > ${TEMPFILE}.ipv6_in2
IPV6IN=$(( $IPV6IN + $IPV6A ))
IPV6A=`/sbin/ipfw -a list | grep "count" | grep "^09200 " | /usr/bin/awk '{print $3}' `; IPV6A=${IPV6A:-0}
echo "${IPV6A}" > ${TEMPFILE}.ipv6_in3
IPV6IN=$(( $IPV6IN + $IPV6A ))
echo "${IPV6IN}" > ${ZBXFILE}.ipv6_in
IPV6B=`/sbin/ipfw -a list | grep "count" | grep "^11000 " | /usr/bin/awk '{print $3}' `; IPV6B=${IPV6B:-0}
echo "${IPV6B}" > ${TEMPFILE}.ipv6_out1
IPV6OUT=$(( $IPV6OUT + $IPV6B ))
IPV6B=`/sbin/ipfw -a list | grep "count" | grep "^11100 " | /usr/bin/awk '{print $3}' `; IPV6B=${IPV6B:-0}
echo "${IPV6B}" > ${TEMPFILE}.ipv6_out2
IPV6OUT=$(( $IPV6OUT + $IPV6B ))
IPV6B=`/sbin/ipfw -a list | grep "count" | grep "^11200 " | /usr/bin/awk '{print $3}' `; IPV6B=${IPV6B:-0}
echo "${IPV6B}" > ${TEMPFILE}.ipv6_out3
IPV6OUT=$(( $IPV6OUT + $IPV6B ))
echo "${IPV6OUT}" > ${ZBXFILE}.ipv6_out
IPV6=$(( $IPV6 + $IPV6IN + $IPV6OUT ))
echo "${IPV6}" > ${ZBXFILE}.ipv6

chmod 666 ${ZBXFILE}.ip*
