#!/usr/bin/env zsh
# Take working directory
thisFilePath="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${thisFilePath}")
# Load lib
source "${work_dir}/lib.sh"