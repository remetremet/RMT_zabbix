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
. "${ZBXPATH}/_config.sh"
if [[ ! -e "${ZBXPATH}/_database.sh" ]]; then
 exit;
fi
. "${ZBXPATH}/_database.sh"

if [ x"$1" == x"auto" ]; then
 if [ x"${AUTOUPDATE}" == x"no" ]; then
  exit;
 fi
fi

if [ ! -d "${ZBXPATH}" ]; then
 mkdir "${ZBXPATH}"
 chmod 777 "${ZBXPATH}"
fi
if [ ! -d "${ZBXPATH}/temp" ]; then
 mkdir "${ZBXPATH}/temp"
 chmod 777 "${ZBXPATH}/temp"
fi
if [ ! -d "${ZBXPATH}/data" ]; then
 mkdir "${ZBXPATH}/data"
 chmod 777 "${ZBXPATH}/data"
fi
if [ ! -d "${SCRIPTSPATH}" ]; then
 mkdir "${SCRIPTSPATH}"
 chmod 777 "${SCRIPTSPATH}"
fi

# Synchronize scripts from github to local repo
cd ${ZBXPATH}/github
git pull origin master

# Copy scripts to working directory
cp -R ${ZBXPATH}/github/_*.sh ${ZBXPATH}/
chmod 755 ${ZBXPATH}/_*.sh
cp -R ${ZBXPATH}/github/scripts/*.sh ${SCRIPTSPATH}/
chmod 755 ${SCRIPTSPATH}/*.sh
