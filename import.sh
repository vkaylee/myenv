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
thisFilePath="$(readlink -f "${(%):-%x}")"
workDir=$(dirname "${thisFilePath}")
echo "Current directory of the file ${thisFilePath} is ${workDir}"
# Load environments
source "${workDir}/env.sh"
# Load detect.sh script
source "${workDir}/detect.sh"
# aliases
source "${workDir}/aliases.sh"
# MyContainer
source "${workDir}/mycontainer.sh"
