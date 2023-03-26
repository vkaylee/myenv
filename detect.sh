#!/usr/bin/env zsh
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
# Load lib
source "${work_dir}/lib.sh"