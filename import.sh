#!/usr/bin/env bash
# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
thisFilePath="$(readlink -f "${BASH_SOURCE[0]}")"
workDir=$(dirname "${thisFilePath}")
echo "Current directory of the file ${thisFilePath} is ${workDir}"
# Load environments
source "${workDir}/env.sh"
# Load detect.sh script
source "${workDir}/detect.sh"
# aliases
source "${workDir}/aliases.sh"
