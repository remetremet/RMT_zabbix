#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH="${ZBXPATH}/.."
else
 ZBXPATH="${ZBXPATH}"
fi
. "${ZBXPATH}/_config.sh"
. "${ZBXPATH}/_database.sh"

FUNCTION=$1
case ${FUNCTION} in
        pkg)
         echo "1"
        ;;
        freebsd_update)
         echo "2"
        ;;
        network_discovery)
         cat "${DATAPATH}/network_discovery"
        ;;
        network_mac.*)
         INDEX="${FUNCTION:12}"
         cat "${DATAPATH}/network_discovery.${INDEX}.mac"
        ;;
        speedtest_discovery)
         echo "4"
        ;;
        speedtest.*.extip)
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
