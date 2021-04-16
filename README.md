# RMT_zabbix
Zabbix plugins and serverside crons (FreeBSD specific and tested)

These scripts are here mainly for my personal use. They monitor FreeBSD server functions and prepare data for Zabbix templates.

## Files
- **_config.sh** - local server configuration (distributed in [conf](conf) directory as a sample)
- **_cron.sh** - this script is called as a cron job and it call all other scripts
- **_database.sh** - (used by other scripts as library) - default definitions
- **_get_data.sh** - (called by zabbix_agent) - sends data to Zabbix Server/Proxy
- **_setup.sh** - this script is used for easy setup and first clone of this repo
- **_update.sh** - (called by [_cron.sh](_cron.sh)) - do the automatic sync from this Github repo


## Scripts (called by [_cron.sh](_cron.sh))
Server side scripts for asynchronous gathering of data.
See [scripts/README.md](scripts/README.md)


## Templates
Zabbix templates and configuration plugin.
See [templates/README.md](templates/README.md)


## Setup
To download use `fetch https://raw.githubusercontent.com/remetremet/RMT_zabbix/master/_setup.sh` and to install afterwards `_setup.sh`.


## Requirements
 Almost all the scripts needs to be run as a root.
 
 - `git` - :wink:
 - `fping` - (for **rping.sh** function)
 - `smartmontools` - (for **smart.sh** function)
 - `curl` - (for **network_discovery.sh** and **mfi_get.sh** function)
 - `py-speedtest-cli` - (for **speedtest.sh** function)
 - `speedtest` - Official Ookla's client (for **speedtest.sh** function)
 - [RMT_ipfw](https://github.com/remetremet/RMT_ipfw) - (for **ipfw_traffic.sh** function)


![license-image](https://img.shields.io/github/license/remetremet/RMT_zabbix?style=plastic)
![last-commit-image](https://img.shields.io/github/last-commit/remetremet/RMT_zabbix?style=plastic)
![repo-size-image](https://img.shields.io/github/repo-size/remetremet/RMT_zabbix?style=plastic)

Use it if like it.
