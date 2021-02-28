#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH="${ZBXPATH}/.."
else
 ZBXPATH="${ZBXPATH}"
fi
. "${ZBXPATH}/_config.sh"
. "${ZBXPATH}/_database.sh"

echo "P1: $1"
echo "P2: $2"
