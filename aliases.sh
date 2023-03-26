#!/usr/bin/env zsh
# Take working directory
thisFilePath="$(readlink -f "${(%):-%x}")"
workDir=$(dirname "${thisFilePath}")
# Load lib
source "${workDir}/lib.sh"
# Alias for docker-compose
set_command_alias 'gshell' 'gcloud cloud-shell ssh --authorize-session'
set_command_alias 'dkc' 'docker compose'
