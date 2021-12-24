#!/usr/bin/env bash
# Check running as root
if [ "${EUID}" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# Take working directory
workDir=$(dirname "$0")
# Load lib
source "${workDir}/lib.sh"
# Set up zsh
