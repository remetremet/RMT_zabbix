#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
if [[ -e "${ZBXPATH}/../_config.sh" ]]; then
 ZBXPATH="${ZBXPATH}/.."
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

FUNCTION=$1
case ${FUNCTION} in
# FREEBSD_UPDATE
        freebsd_update.*)
         INDEX="${FUNCTION:15}"
         case ${INDEX} in
                 latest)
                  cat "${DATAPATH}/freebsd_update.latest"
                 ;;
                 running)
                  cat "${DATAPATH}/freebsd_update.running"
                 ;;
                 EOL)
                  cat "${DATAPATH}/freebsd_update.EOL"
                 ;;
                 *)
                  echo 0
                 ;;
         esac
        ;;
# IPFW_TRAFFIC
        ipfw_traffic.*)
         INDEX="${FUNCTION:13}"
         case ${INDEX} in
                 ipv4)
                  cat "${DATAPATH}/ipfw_traffic.ipv4"
                 ;;
                 ipv6)
                  cat "${DATAPATH}/ipfw_traffic.ipv6"
                 ;;
                 ipv4_in)
                  cat "${DATAPATH}/ipfw_traffic.ipv4_in"
                 ;;
                 ipv6_in)
                  cat "${DATAPATH}/ipfw_traffic.ipv6_in"
                 ;;
                 ipv4_out)
                  cat "${DATAPATH}/ipfw_traffic.ipv4_out"
                 ;;
                 ipv6_out)
                  cat "${DATAPATH}/ipfw_traffic.ipv6_out"
                 ;;
                 *)
                  echo 0
                 ;;
         esac
        ;;
# NETWORK_DISCOVERY
        discovery_network)
         cat "${DATAPATH}/network_discovery"
        ;;
        network_mac.*)
         INDEX="${FUNCTION:12}"
         cat "${DATAPATH}/network_discovery.${INDEX}.mac"
        ;;
# PKG
        pkg)
         cat "${DATAPATH}/pkg"
        ;;
# RPING
        discovery_rping)
         cat "${DATAPATH}/rping_discovery"
        ;;
        rping_*)
         INDEX="${FUNCTION:6}"
         cat "${DATAPATH}/rping_${INDEX}"
        ;;
        rpl_*)
         INDEX="${FUNCTION:4}"
         cat "${DATAPATH}/rpl_${INDEX}"
        ;;
# SMART
        discovery_smartctl)
         cat "${DATAPATH}/smartctl_discovery"
        ;;
        smartctl.*)
         INDEX="${FUNCTION:9}"
         cat "${DATAPATH}/smartctl.${INDEX}"
        ;;
# SPEEDTEST
        discovery_speedtest)
         cat "${DATAPATH}/speedtest_discovery"
        ;;
        speedtest.*.extip)
         INDEX="${FUNCTION:10:1}"
         cat "${DATAPATH}/speedtest_${INDEX}.extip"
        ;;
        speedtest.*.down)
         INDEX="${FUNCTION:10:1}"
         cat "${DATAPATH}/speedtest_${INDEX}.down"
        ;;
        speedtest.*.up)
         INDEX="${FUNCTION:10:1}"
         cat "${DATAPATH}/speedtest_${INDEX}.up"
        ;;
# other/unknown function request
        *)
         echo "0"
        ;;
esac
