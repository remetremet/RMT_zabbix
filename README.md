# RMT_zabbix
Zabbix plugins and serverside crons (FreeBSD needed and tested)

These scripts are here mainly for my personal use. They monitor FreeBSD server functions and prepare data for Zabbix templates.

Files
----
- **_config.sh** - local server configuration (distributed in /conf/ directory)
- **_cron.sh** - this script is called as a cron job and it call all other scripts
- **_database.sh** - (used by other scripts) - default definitions
- **_setup.sh** - this script is used for easy setup and first clone of this repo
- **_update.sh** - (called from _cron.sh) - do the automatic sync from this Github repo


Scripts (called from _cron.sh)
----
- **freebsd_update.sh** - check for FreeBSD OS updates
- **ipfw_traffic.sh** - get IPFW2 traffic counts
- **mfi_get.sh** - get state of Ubiquiti mFI sockets
- **network_discovery.sh** - get network interface state
- **pkg.sh** - check for FreeBSD packages updates
- **rping.sh** - ping predefined IP addresses and save results
- **smart.sh** - get SMART info from drives
- **speedtest.sh** - check WANs speed by Ookla's Speedtest.Net and save results


Requirements
----
 - git ;-)
 - fping
 - smartmontools
 - curl
 - py-speedtest-cli
 - RMT_ipfw (https://github.com/remetremet/RMT_ipfw)


Use it if like it.
