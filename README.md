# RMT_zabbix
Zabbix plugins and serverside crons (FreeBSD specific and tested)

These scripts are here mainly for my personal use. They monitor FreeBSD server functions and prepare data for Zabbix templates.

Files
----
- **_config.sh** - local server configuration (distributed in /conf/ directory as a sample)
- **_cron.sh** - this script is called as a cron job and it call all other scripts
- **_database.sh** - (used by other scripts) - default definitions
- **_get_data.sh** - (caller by zabbix_agent) - sends data to Zabbix Server/Proxy
- **_setup.sh** - this script is used for easy setup and first clone of this repo
- **_update.sh** - (called by _cron.sh) - do the automatic sync from this Github repo


Scripts (called by _cron.sh)
----
- **freebsd_update.sh** - check for FreeBSD OS updates
- **ipfw_traffic.sh** - get IPFW2 traffic counts
- **mfi_get.sh** - get state of Ubiquiti mFI sockets
- **network_discovery.sh** - get network interface state
- **pkg.sh** - check for FreeBSD packages updates
- **rping.sh** - ping predefined IP addresses and save results
- **smart.sh** - get SMART info from drives
- **speedtest.sh** - check WANs speed by Ookla's Speedtest.Net and save results


Templates
----
- **userparameter_rmtzabbix.conf** - file to be placed info ".../zabbix_agentd.conf.d/"
- **RMT_zabbix.xml** - template to be imported to Zabbix Server 


Setup
----
To download and install use these commands:
```
fetch https://raw.githubusercontent.com/remetremet/RMT_zabbix/master/_setup.sh
_setup.sh
```


Requirements
----
 - git ;-)
 - fping
 - smartmontools
 - curl
 - py-speedtest-cli
 - RMT_ipfw (https://github.com/remetremet/RMT_ipfw)


Use it if like it.
