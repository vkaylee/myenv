#!/usr/bin/env bash
# Take working directory
thisFilePath="$(readlink -f "${BASH_SOURCE[0]}")"
workDir=$(dirname "${thisFilePath}")
# Load lib
source "${workDir}/lib.sh"