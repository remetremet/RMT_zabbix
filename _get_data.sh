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

case ${FUNCTION} in
        pkg)
         echo "1"
        ;;
        freebsd_update)
         echo "2"
        ;;
        network.discovery)
         echo "3"
        ;;
        speedtest.discovery)
         echo "4"
        ;;
        speedtest.extip)
         echo "5"
        ;;
        speedtest.*.down)
         echo "6"
        ;;
        speedtest.*.up)
         echo "7"
        ;;
# other/unknown function request
        *)
         echo "0"
         exit
        ;;
esac
