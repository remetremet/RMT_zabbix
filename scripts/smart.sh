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

if [ x"${SMART_ENABLE}" == x"no" ]; then
 exit;
fi

TEMPFILE="${TEMPPATH}/zabbix_smartctl"
SEMAPHOREFILE="${TEMPPATH}/.zabbix_smartctl"
ZBXFILE="${DATAPATH}/smartctl"
DISCOVERYFILE="${DATAPATH}/smartctl_discovery"

SMART_PERIOD="${SMART_PERIOD:-60}"
SMART_FORCE_PERIOD="${SMART_FORCE_PERIOD:-86400}"

if [ -e "${SEMAPHOREFILE}" ]; then
 tts=`date +%s`
 fts=`stat -f %m "${SEMAPHOREFILE}"`
 fts=$((${fts}+85500))
 if [[ "${fts}" -lt "${tts}" ]]; then
  /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
 fi
fi
if [ ! -e "${SEMAPHOREFILE}" ]; then
 touch "${SEMAPHOREFILE}" >> /dev/null 2>&1

now=`date +%s`
D=""
DISCOVERY=""
if [ ! -e "${TEMPFILE}" ]; then
 temptime=$(( ${now} - ${SMART_PERIOD} - 100 ))
else
 temptime=`stat -f %m "${TEMPFILE}"`
fi
temptime=$(( ${now} - ${temptime} ))
if [[ "${temptime}" -gt "${SMART_PERIOD}" ]]; then
 echo -n > "${TEMPFILE}"
 ${CAMCONTROL_PROG} devlist | sort | grep -vE "(cd.|ses.)" | awk -F "(" '{ print $2; }' | sed 's/)//g' | sed 's/,/ /g' > "${TEMPFILE}"
 while read fl; do
  DEVICE_PARENT=`echo "${fl}" | awk '{ print $2; }' | sed -e 's/[[:space:]]*$//'`
  if [ "${DEVICE_PARENT}" = "" ]; then
   DEVICE_PARENT=`echo "${fl}" | awk '{ print $1; }' | sed -e 's/[[:space:]]*$//'`
   DEVICE="${DEVICE_PARENT}"
  else
   if [ "${DEVICE_PARENT:0:4}" = "pass" ]; then
    DEVICE="${DEVICE_PARENT}"
    DEVICE_PARENT=`echo "${fl}" | awk '{ print $1; }' | sed -e 's/[[:space:]]*$//'`
   else
    DEVICE=`echo "${fl}" | awk '{ print $1; }' | sed -e 's/[[:space:]]*$//'`
   fi
  fi
  ${SMARTCTL_PROG} -i -n never /dev/${DEVICE} > "${TEMPFILE}.${DEVICE_PARENT}.info"
  DEVICE_POWER_STATE=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Power mode " | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_MODEL=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Device Model:" | awk '{ print $3" "$4" "$5" "$6 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_PRODUCT=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Product:" | awk '{ print $2" "$3 }' | sed -e 's/[[:space:]]*$//'`
  if [ "${DEVICE_MODEL}" = "" ]; then
   DEVICE_MODEL="${DEVICE_PRODUCT}"
  fi
  DEVICE_TYPE=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Model Family:" | awk '{ print $3" "$4" "$5" "$6 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_VENDOR=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Vendor:" | awk '{ print $2" "$3 }' | sed -e 's/[[:space:]]*$//'`
  if [ "${DEVICE_TYPE}" = "" ]; then
   DEVICE_TYPE="${DEVICE_VENDOR} ${DEVICE_PRODUCT}"
  fi
  DEVICE_SERIAL_NUMBER=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Serial Number:" | awk '{ print $3 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_RPM=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Rotation Rate:" | awk '{ print $3 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_CAP=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "User Capacity:" | awk '{ print $3 }' | sed "s/,//g" | sed -e 's/[[:space:]]*$//'`
  DEVICE_FORM_FACTOR=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Form Factor:" | awk '{ print $3" "$4 }' | sed -e 's/[[:space:]]*$//'`
  DEVICE_TRANSPORT_PROTOCOL=`cat "${TEMPFILE}.${DEVICE_PARENT}.info" | grep "Transport protocol:" | awk '{ print $3 }' | sed -e 's/[[:space:]]*$//'`
  if [ "${DEVICE_TRANSPORT_PROTOCOL}" = "" ]; then
   DEVICE_TRANSPORT_PROTOCOL="SATA"
  fi
  if [ "${DEVICE_CAP}" != "" ]; then
   SPINUP=0
   if [ "${DEVICE_POWER_STATE}" = "ACTIVE" ]; then
    SPINUP=1
   else
    if [ ! -e "${TEMPFILE}.${DEVICE_PARENT}.full" ]; then
     fulltime=$(( ${now} - ${SMART_FORCE_PERIOD} - 100 ))
    else
     fulltime=`stat -f %m "${TEMPFILE}.${DEVICE_PARENT}.full"`
    fi
    fulltime=$(( ${now} - ${fulltime} ))
    if [[ "${fulltime}" -gt "${SMART_FORCE_PERIOD}" ]]; then
     SPINUP=1
    fi
   fi
   if [[ "${SPINUP}" -eq "1" ]]; then
    if [ "${DEVICE_TRANSPORT_PROTOCOL}" = "SAS" ]; then
     SMARTCTL_OPTIONS="-d sat"
    else
     SMARTCTL_OPTIONS=""
    fi
    ${SMARTCTL_PROG} -x ${SMARTCTL_OPTIONS} /dev/${DEVICE} > "${TEMPFILE}.${DEVICE_PARENT}.full"
   fi
   if [ -e "${TEMPFILE}.${DEVICE_PARENT}.full" ]; then
    DEVICE_POH=""
    DEVICE_POH_1=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "9 Power_On_Hours" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_POH_2=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep -v " Spindle Motor Power-on Hours" | grep " Power-on Hours" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_POH_1}" != x"" ]; then DEVICE_POH="${DEVICE_POH_1}"; fi
    if [ x"${DEVICE_POH_2}" != x"" ]; then DEVICE_POH="${DEVICE_POH_2}"; fi
    DEVICE_SPOH=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep " Spindle Motor Power-on Hours" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_SPOH}" == x"" ]; then DEVICE_SPOH="0"; fi
    DEVICE_PCC=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "12 Power_Cycle_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_PCC}" == x"" ]; then DEVICE_PCC="0"; fi
    DEVICE_LCC=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "193 Load_Cycle_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_LCC}" == x"" ]; then DEVICE_LCC="0"; fi
    DEVICE_WLC=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "173 Wear_Leveling_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_WLC}" == x"" ]; then DEVICE_WLC="0"; fi
    DEVICE_TEMP=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "194 Temperature_Celsius" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_ERR5=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "5 Reallocated_Sector_Ct" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR5}" == x"" ]; then DEVICE_ERR5="0"; fi
    DEVICE_ERR196=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "196 Reallocated_Event_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR196}" == x"" ]; then DEVICE_ERR196="0"; fi
    DEVICE_ERR197=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "197 Current_Pending_Sector" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR197}" == x"" ]; then DEVICE_ERR197="0"; fi
    DEVICE_ERR199=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "199 UDMA_CRC_Error_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR199}" == x"" ]; then DEVICE_ERR199="0"; fi
    DEVICE_ERR218=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "218 CRC_Error_Count" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR218}" == x"" ]; then DEVICE_ERR218="0"; fi
    DEVICE_ERROR=$(( ${DEVICE_ERR5} + ${DEVICE_ERR196} + ${DEVICE_ERR197} + ${DEVICE_ERR199} + ${DEVICE_ERR218} ))
    DEVICE_ERR_OT=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep " Time in Over-Temperature" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_ERR_OT}" == x"" ]; then DEVICE_ERR_OT="0"; fi
    if [ x"${DEVICE_ERR_OT}" == x"-" ]; then DEVICE_ERR_OT="0"; fi
    DEVICE_WRITE=""
    DEVICE_WRITE_1=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep " Logical Sectors Written" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_WRITE_2=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "241 Host_Writes_32MiB" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_WRITE_3=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "241 Lifetime_Writes_GiB" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_WRITE_3}" != x"" ]; then
     DEVICE_WRITE_3=$(( ${DEVICE_WRITE_3} * 1024 * 1024 * 1024 ))
     DEVICE_WRITE="${DEVICE_WRITE_3}"
    fi
    if [ x"${DEVICE_WRITE_2}" != x"" ]; then
     DEVICE_WRITE_2=$(( ${DEVICE_WRITE_2} * 32 * 1024 * 1024 ))
     DEVICE_WRITE="${DEVICE_WRITE_2}"
    fi
    if [ x"${DEVICE_WRITE_1}" != x"" ]; then
     DEVICE_WRITE_1=$(( ${DEVICE_WRITE_1} * 512 ))
     DEVICE_WRITE="${DEVICE_WRITE_1}"
    fi
    if [ x"${DEVICE_WRITE}" == x"" ]; then DEVICE_WRITE="-1"; fi
    DEVICE_READ=""
    DEVICE_READ_1=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep " Logical Sectors Read" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_READ_2=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "242 Host_Reads_32MiB" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_READ_3=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "242 Lifetime_Reads_GiB" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_READ_3}" != x"" ]; then
     DEVICE_READ_3=$(( ${DEVICE_READ_3} * 1024 * 1024 * 1024 ))
     DEVICE_READ="${DEVICE_READ_3}"
    fi
    if [ x"${DEVICE_READ_2}" != x"" ]; then
     DEVICE_READ_2=$(( ${DEVICE_READ_2} * 32 * 1024 * 1024 ))
     DEVICE_READ="${DEVICE_READ_2}"
    fi
    if [ x"${DEVICE_READ_1}" != x"" ]; then
     DEVICE_READ_1=$(( ${DEVICE_READ_1} * 512 ))
     DEVICE_READ="${DEVICE_READ_1}"
    fi
    if [ x"${DEVICE_READ}" == x"" ]; then DEVICE_READ="-1"; fi
    DEVICE_SSDLIFELEFT=""
    DEVICE_SSDLIFELEFT_1=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "202 Perc_Rated_Life_Used" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_SSDLIFELEFT_2=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep " Percentage Used Endurance Indicator" | awk '{ print $4 }' | sed -e 's/[[:space:]]*$//'`
    DEVICE_SSDLIFELEFT_3=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "231 SSD_Life_Left" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_SSDLIFELEFT_1}" != x"" ]; then DEVICE_SSDLIFELEFT="${DEVICE_SSDLIFELEFT_1}"; fi
    if [ x"${DEVICE_SSDLIFELEFT_2}" != x"" ]; then DEVICE_SSDLIFELEFT="${DEVICE_SSDLIFELEFT_2}"; fi
    if [ x"${DEVICE_SSDLIFELEFT_3}" != x"" ]; then
     DEVICE_SSDLIFELEFT_3=$(( 100 - ${DEVICE_SSDLIFELEFT_3} ))
     DEVICE_SSDLIFELEFT="${DEVICE_SSDLIFELEFT_3}"
    fi
    if [ x"${DEVICE_SSDLIFELEFT}" == x"" ]; then DEVICE_SSDLIFELEFT="-1"; fi
    DEVICE_HL=`cat "${TEMPFILE}.${DEVICE_PARENT}.full" | grep "22 Helium_Level" | awk '{ print $8 }' | sed -e 's/[[:space:]]*$//'`
    if [ x"${DEVICE_HL}" == x"" ]; then DEVICE_HL="-1"; fi
           
    DEVICEINFO="";
    DEVICEINFO="${DEVICEINFO}${DEVICE_POH};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_SPOH};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_PCC};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_LCC};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_WLC};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_TEMP};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_ERROR};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR5};";
    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR196};";
    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR197};";
    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR199};";
    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR218};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_ERR_OT};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_WRITE};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_READ};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_SSDLIFELEFT};";

    DEVICEINFO="${DEVICEINFO}${DEVICE_HL};";
    echo "${DEVICEINFO}" > "${ZBXFILE}.${DEVICE_PARENT}"
   fi
   DISCOVERY="${DISCOVERY}{"
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_DEVICE}\":\"${DEVICE}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_PARENT_DEVICE}\":\"${DEVICE_PARENT}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_TYPE}\":\"${DEVICE_TYPE}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_MODEL}\":\"${DEVICE_MODEL}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_SERIAL_NUMBER}\":\"${DEVICE_SERIAL_NUMBER}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_FORM_FACTOR}\":\"${DEVICE_FORM_FACTOR}\","
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_TRANSPORT_PROTOCOL}\":\"${DEVICE_TRANSPORT_PROTOCOL}\","
   if [ "${DEVICE_RPM}" != "Solid" ]; then
    if [ "${DEVICE_RPM}" != "" ]; then
     DISCOVERY="${DISCOVERY}\"{#SMARTCTL_RPM}\":\"${DEVICE_RPM}\","
    else
     DISCOVERY="${DISCOVERY}\"{#SMARTCTL_RPM}\":\"-1\","
    fi
   else
    DISCOVERY="${DISCOVERY}\"{#SMARTCTL_RPM}\":\"-1\","
   fi
   DISCOVERY="${DISCOVERY}\"{#SMARTCTL_CAPACITY}\":\"${DEVICE_CAP}\""
   DISCOVERY="${DISCOVERY}},"
   D="1"
  fi
#  /bin/rm -f "${TEMPFILE}.${DEVICE_PARENT}.info" >> /dev/null 2>&1
 done < "${TEMPFILE}"
fi

if [[ "${D}" -eq "1" ]]; then
 echo -n "" > "${DISCOVERYFILE}"
 DISCOVERY="[${DISCOVERY::(-1)}]"
 echo "${DISCOVERY}" > "${DISCOVERYFILE}"
fi

 /bin/rm -f "${SEMAPHOREFILE}" >> /dev/null 2>&1
fi
