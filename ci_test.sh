#!/usr/bin/env bash
input_user="$1"
file_dir_url="$2"
sudo su -c "export fileDirUrl=\"${file_dir_url}\"; bash <(curl -sSL \"\${fileDirUrl}/setup.sh?\$(date +%s)\") test" "${input_user}"
