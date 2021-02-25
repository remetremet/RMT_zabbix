#!/usr/local/bin/bash -
ZBXPATH=$( dirname "$(realpath $0)" )
. "${ZBXPATH}/_database.sh"

file_to_update="_cron.sh _database.sh freebsd-update.sh if6_traffic.sh mfi_get.sh network_discovery.sh pkg.sh rping.sh speedtest.sh smartctl.sh"

github_file="_cron.sh"
FILE="https://api.github.com/repos/${github_owner}/${github_repo}/contents/${github_file}"
/usr/local/bin/curl -v --header "Authorization: token ${github_token}" --header "Accept: application/vnd.github.v3.raw" --remote-name --location $FILE

chmod 775 "${ZBXPATH}/*.sh"
