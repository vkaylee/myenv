#!/bin/bash
# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
workDir=$(dirname "$0")
echo "Current directory of the file $0 is ${workDir}"
# Load detect.sh script
source "${workDir}/detect.sh"
# aliases
source "${workDir}/aliases.sh"
