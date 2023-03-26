#!/usr/bin/env zsh
# Take working directory
thisFilePath="$(readlink -f "${(%):-%x}")"
workDir=$(dirname "${thisFilePath}")
# Load lib
source "${workDir}/lib.sh"
# Need to run as root
check_run_as_root "You must run this script by root permission" # The function in lib.sh
# Set up zsh
