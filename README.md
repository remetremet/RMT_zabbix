# RMT_zabbix
Zabbix plugins and serverside crons (FreeBSD needed and tested)

These scripts are here mainly for my personal use. They monitor FreeBSD server functions and prepare data for Zabbix templates.

Scripts
----
- **_cron.sh** - this script is called as a cron job and it call all other scripts
- **_database.sh** - (used by other scripts) - default definitions
- **_setup.sh** - this script is used for easy setup and first clone of this repo
- **_update.sh** - (called from _cron.sh) - do the automatic sync from this Github repo
- **freebsd-update.sh** - (called from _cron.sh) - check for FreeBSD OS updates
- **if6_traffic.sh** - (called from _cron.sh) - get IPFW2 traffic counts
- **mfi_get.sh** - (called from _cron.sh) - get state of Ubiquiti mFI sockets
- **network_discovery.sh** - (called from _cron.sh) - get network interface state
- **pkg.sh** - (called from _cron.sh) - check for FreeBSD packages updates
- **rping.sh** - (called from _cron.sh) - ping predefined IP addresses and save results
- **smartctl.sh** - (called from _cron.sh) - get SMART info from drives
- **speedtest.sh** - (called from _cron.sh) - check WANs speed by Ookla's Speedtest.Net and save results

Requirements
----
 - git ;-)
 - fping
 - smartmontools
 - curl
 - py-speedtest-cli
 - RMT_ipfw (https://github.com/remetremet/RMT_ipfw)


Use it if like it.
