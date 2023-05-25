#!/usr/bin/env zsh
# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
export MYENV_DIR="${work_dir}"
# Load environments
source "${work_dir}/env.sh"
# Load detect.sh script
source "${work_dir}/detect.sh"
# aliases
source "${work_dir}/aliases.sh"
# MyContainer
source "${work_dir}/mycontainer.sh"

# Load all custom scripts, the list will be ordered by name
find "${work_dir}/custom_scripts/" -maxdepth 1 -type f -name "*.sh" -printf '%h\0%d\0%p\n' | sort -t '\0' -n | awk -F '\0' '{print $3}' | while read custom_script_path
do
    source "${custom_script_path}"
done