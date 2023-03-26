#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
# Load lib
source "${work_dir}/lib.sh"
# Alias for docker-compose
set_command_alias 'gshell' 'gcloud cloud-shell ssh --authorize-session'
set_command_alias 'docker-compose' 'docker compose'
set_command_alias 'dkc' 'docker-compose'
