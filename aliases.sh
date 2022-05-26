#!/usr/bin/env zsh
# Take working directory
thisFilePath="$(readlink -f "${(%):-%x}")"
workDir=$(dirname "${thisFilePath}")
# Load lib
source "${workDir}/lib.sh"
# Alias for docker-compose
setAlias 'dkc' 'docker-compose'
