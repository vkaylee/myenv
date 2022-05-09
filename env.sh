#!/usr/bin/env zsh
# Take working directory
thisFilePath="$(readlink -f "${(%):-%x}")"
workDir=$(dirname "${thisFilePath}")
if [ -r "${workDir}/.env" ]; then
  set -a
  # shellcheck source=currentDir/.env
  source <(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${workDir}/.env")
  set +a
  echo "Some environments in ${workDir}/.env have been set!"
fi
