#!/bin/sh
# Take working directory
this_file_path="$(readlink -f "$0")"
work_dir=$(dirname "${thisFilePath}")
# Load lib
source "${work_dir}/lib.sh"
# Need to run as root
check_run_as_root "You must run this script ${this_file_path} by root permission" # The function in lib.sh
# Set up zsh
