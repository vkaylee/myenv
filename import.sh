#!/usr/bin/env zsh
# Support only zsh shell
myShell=$(ps -hp $$ | awk '{print $5}')
if [ "${myShell}" != "/usr/bin/zsh" ]; then
  echo "You must install and set zsh as your default shell"
  exit 1
fi

# Put this one into your shell load script
## Load customize configuration myenv
#source "${HOME}/Documents/myenv/import.sh"
# Take working directory
this_file_path="$(readlink -f "${(%):-%x}")"
work_dir=$(dirname "${this_file_path}")
# Load environments
source "${work_dir}/env.sh"
# Load detect.sh script
source "${work_dir}/detect.sh"
# aliases
source "${work_dir}/aliases.sh"
# MyContainer
source "${work_dir}/mycontainer.sh"
