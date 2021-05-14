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
. "${ZBXPATH}/_database.sh"
if [[ ! -e "${ZBXPATH}/_config.sh" ]]; then
 exit;
fi
. "${ZBXPATH}/_config.sh"

FUNCTION=$1
case ${FUNCTION} in
# FREEBSD_UPDATE
        freebsd_update.*)
         INDEX="${FUNCTION:15}"
         case ${INDEX} in
                 latest)
                  if [ -e "${DATAPATH}/freebsd_update.latest" ]; then
                   cat "${DATAPATH}/freebsd_update.latest"
                  else
                   echo ""
                  fi
                 ;;
                 running)
                  if [ -e "${DATAPATH}/freebsd_update.running" ]; then
                   cat "${DATAPATH}/freebsd_update.running"
                  else
                   echo ""
                  fi
                 ;;
                 EOL)
                  if [ -e "${DATAPATH}/freebsd_update.EOL" ]; then
                   cat "${DATAPATH}/freebsd_update.EOL"
                  else
                   echo "0"
                  fi
                 ;;
                 *)
                  echo 0
                 ;;
         esac
        ;;
# HDD_TRAFFIC
        discovery_hdd)
         if [ -e "${DATAPATH}/hdd_discovery" ]; then
          cat "${DATAPATH}/hdd_discovery"
         else
          echo ""
         fi
        ;;
        hdd_traffic_rps.*)
         INDEX="${FUNCTION:16}"
         if [ -e "${DATAPATH}/hdd_traffic.${INDEX}.rps" ]; then
          cat "${DATAPATH}/hdd_traffic.${INDEX}.rps"
         else
          echo "0"
         fi
        ;;
        hdd_traffic_wps.*)
         INDEX="${FUNCTION:16}"
         if [ -e "${DATAPATH}/hdd_traffic.${INDEX}.wps" ]; then
          cat "${DATAPATH}/hdd_traffic.${INDEX}.wps"
         else
          echo "0"
         fi
        ;;
        hdd_traffic_rkb.*)
         INDEX="${FUNCTION:16}"
         if [ -e "${DATAPATH}/hdd_traffic.${INDEX}.rkb" ]; then
          cat "${DATAPATH}/hdd_traffic.${INDEX}.rkb"
         else
          echo "0"
         fi
        ;;
        hdd_traffic_wkb.*)
         INDEX="${FUNCTION:16}"
         if [ -e "${DATAPATH}/hdd_traffic.${INDEX}.wkb" ]; then
          cat "${DATAPATH}/hdd_traffic.${INDEX}.wkb"
         else
          echo "0"
         fi
        ;;
# IPFW_TRAFFIC
        ipfw_traffic.*)
         INDEX="${FUNCTION:13}"
         case ${INDEX} in
                 ip)
                  if [ -e "${DATAPATH}/ipfw_traffic.ip" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ip"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv4)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv4" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv4"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv6)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv6" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv6"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv4_in)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv4_in" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv4_in"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv6_in)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv6_in" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv6_in"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv4_out)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv4_out" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv4_out"
                  else
                   echo "0"
                  fi
                 ;;
                 ipv6_out)
                  if [ -e "${DATAPATH}/ipfw_traffic.ipv6_out" ]; then
                   cat "${DATAPATH}/ipfw_traffic.ipv6_out"
                  else
                   echo "0"
                  fi
                 ;;
                 *)
                  echo "0"
                 ;;
                 wan_in.*)
                  INDEX2="${INDEX:7}"
                  if [ -e "${DATAPATH}/ipfw_traffic.wan${INDEX2}_in" ]; then
                   cat "${DATAPATH}/ipfw_traffic.wan${INDEX2}_in"
                  else
                   echo "0"
                  fi
                 ;;
                 wan_out.*)
                  INDEX2="${INDEX:8}"
                  if [ -e "${DATAPATH}/ipfw_traffic.wan${INDEX2}_out" ]; then
                   cat "${DATAPATH}/ipfw_traffic.wan${INDEX2}_out"
                  else
                   echo "0"
                  fi
                 ;;
                 wan.*)
                  INDEX2="${INDEX:4}"
                  if [ -e "${DATAPATH}/ipfw_traffic.wan${INDEX2}" ]; then
                   cat "${DATAPATH}/ipfw_traffic.wan${INDEX2}"
                  else
                   echo "0"
                  fi
                 ;;
         esac
        ;;
# NETWORK_DISCOVERY
        discovery_network)
         if [ -e "${DATAPATH}/network_discovery" ]; then
          cat "${DATAPATH}/network_discovery"
         else
          echo ""
         fi
        ;;
        network_mac.*)
         INDEX="${FUNCTION:12}"
         if [ -e "${DATAPATH}/network_discovery.${INDEX}.mac" ]; then
          cat "${DATAPATH}/network_discovery.${INDEX}.mac"
         else
          echo ""
         fi
        ;;
        network_ipv4.*)
         INDEX="${FUNCTION:13}"
         if [ -e "${DATAPATH}/network_discovery.${INDEX}.ipv4" ]; then
          cat "${DATAPATH}/network_discovery.${INDEX}.ipv4"
         else
          echo ""
         fi
        ;;
        network_ipv4ext.*)
         INDEX="${FUNCTION:16}"
         if [ -e "${DATAPATH}/network_discovery.${INDEX}.ipv4ext" ]; then
          cat "${DATAPATH}/network_discovery.${INDEX}.ipv4ext"
         else
          echo ""
         fi
        ;;
        network_ipv6.*)
         INDEX="${FUNCTION:13}"
         if [ -e "${DATAPATH}/network_discovery.${INDEX}.ipv6" ]; then
          cat "${DATAPATH}/network_discovery.${INDEX}.ipv6"
         else
          echo ""
         fi
        ;;
# OPENPORTS
        openports)
         if [ -e "${DATAPATH}/openports" ]; then
          cat "${DATAPATH}/openports"
         else
          echo "0"
         fi
        ;;
# PKG
        pkg)
         if [ -e "${DATAPATH}/pkg" ]; then
          cat "${DATAPATH}/pkg"
         else
          echo "0"
         fi
        ;;
# RPING
        discovery_rping)
         if [ -e "${DATAPATH}/rping_discovery" ]; then
          cat "${DATAPATH}/rping_discovery"
         else
          echo ""
         fi
        ;;
        rping_*)
         INDEX="${FUNCTION:6}"
         if [ -e "${DATAPATH}/rping_${INDEX}" ]; then
          cat "${DATAPATH}/rping_${INDEX}"
         else
          echo "0"
         fi
        ;;
        rpl_*)
         INDEX="${FUNCTION:4}"
         if [ -e "${DATAPATH}/rpl_${INDEX}" ]; then
          cat "${DATAPATH}/rpl_${INDEX}"
         else
          echo "100"
         fi
        ;;
# SMART
        discovery_smartctl)
         if [ -e "${DATAPATH}/smartctl_discovery" ]; then
          cat "${DATAPATH}/smartctl_discovery"
         else
          echo ""
         fi
        ;;
        smartctl.*)
         INDEX="${FUNCTION:9}"
         if [ -e "${DATAPATH}/smartctl.${INDEX}" ]; then
          cat "${DATAPATH}/smartctl.${INDEX}"
         else
          echo "0"
         fi
        ;;
# SPEEDTEST
        discovery_speedtest)
         if [ -e "${DATAPATH}/speedtest_discovery" ]; then
          cat "${DATAPATH}/speedtest_discovery"
         else
          echo ""
         fi
        ;;
        speedtest.*.server)
         INDEX="${FUNCTION:10:1}"
         if [ -e "${DATAPATH}/speedtest_${INDEX}.server" ]; then
          cat "${DATAPATH}/speedtest_${INDEX}.server"
         else
          echo ""
         fi
        ;;
        speedtest.*.extip)
         INDEX="${FUNCTION:10:1}"
         if [ -e "${DATAPATH}/speedtest_${INDEX}.extip" ]; then
          cat "${DATAPATH}/speedtest_${INDEX}.extip"
         else
          echo ""
         fi
        ;;
        speedtest.*.down)
         INDEX="${FUNCTION:10:1}"
         if [ -e "${DATAPATH}/speedtest_${INDEX}.down" ]; then
          cat "${DATAPATH}/speedtest_${INDEX}.down"
         else
          echo "0"
         fi
        ;;
        speedtest.*.up)
         INDEX="${FUNCTION:10:1}"
         if [ -e "${DATAPATH}/speedtest_${INDEX}.up" ]; then
          cat "${DATAPATH}/speedtest_${INDEX}.up"
         else
          echo "0"
         fi
        ;;
# SSL_CERT
        discovery_ssl)
         if [ -e "${DATAPATH}/ssl_discovery" ]; then
          cat "${DATAPATH}/ssl_discovery"
         else
          echo ""
         fi
        ;;
        ssl.*)
         INDEX="${FUNCTION:4}"
         if [ -e "${DATAPATH}/ssl_${INDEX}" ]; then
          cat "${DATAPATH}/ssl_${INDEX}"
         else
          echo ""
         fi
        ;;
# other/unknown function request
        *)
         echo "0"
        ;;
esac
