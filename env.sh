#!/usr/bin/env bash
# Take working directory
workDir=$(dirname "$0")
if [ -r "${workDir}/.env" ]; then
  set -a
  # shellcheck source=currentDir/.env
  source <(sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g" < "${workDir}/.env")
  set +a
  echo "Some environments in .env have been set!"
fi
