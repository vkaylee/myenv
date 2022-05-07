#!/usr/bin/env bash
# Take working directory
thisFilePath="$(readlink -f "${BASH_SOURCE[0]}")"
workDir=$(dirname "${thisFilePath}")
# Load lib
source "${workDir}/lib.sh"
# Need to run as root
rootNeeded # The function in lib.sh
# Set up zsh
