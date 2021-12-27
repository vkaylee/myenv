#!/usr/bin/env bash
# Take working directory
workDir=$(dirname "$0")
# Load lib
source "${workDir}/lib.sh"
# Alias for docker-compose
setAlias 'dkc' 'docker-compose'
