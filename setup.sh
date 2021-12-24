#!/usr/bin/env bash
# Take working directory
workDir=$(dirname "$0")
# Load lib
source "${workDir}/lib.sh"
# Need to run as root
rootNeeded # The function in lib.sh
# Set up zsh
