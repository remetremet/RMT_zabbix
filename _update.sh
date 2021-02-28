#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
. "${ZBXPATH}/_config.sh"
. "${ZBXPATH}/_database.sh"
SCRIPTSPATH="${ZBXPATH}/scripts"

if [ x"${AUTOUPDATE}" == x"no" ]; then
 exit;
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
